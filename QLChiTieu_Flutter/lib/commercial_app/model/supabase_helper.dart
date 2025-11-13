import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';


final supabase = Supabase.instance.client;

Future<String> uploadImage(
    {required File image, required String bucket, required String path}) async {
  await supabase.storage.from(bucket).upload(path, image,
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false));

  final String publicUrl = supabase.storage.from(bucket).getPublicUrl(path);

  return publicUrl;
}

//updateImage
Future<String> updateImage({required File image, required String bucket, required String path}) async{
  await supabase.storage.from(bucket).update(
    path,
    image,
    fileOptions: FileOptions(cacheControl: '3600', upsert: false),
  );
  final String publicUrl = supabase
      .storage
      .from(bucket)
      .getPublicUrl(path);
  return publicUrl +"?ts=${DateTime.now().millisecond}";
}

Future<void> removeImage({required String bucket, required String path}) async {
  await supabase.storage.from(bucket).remove([path]);
}

Stream<List<T>> getDataStream<T>(
    {required String table,
      required List<String> ids,
      required T Function(Map<String, dynamic> json) fromJson}) {
  var stream = supabase.from(table).stream(primaryKey: ids);

  return stream.map(
        (mapList) => mapList
        .map(
          (mapObj) => fromJson(mapObj),
    )
        .toList(),
  );
}

Future<Map<int, T>> getMapData<T>(
    {required String table,
      required T Function(Map<String, dynamic> json) fromJson,
      required int Function(T) getId}) async {
  final data = await supabase.from(table).select();

  var iterable = data.map(
        (e) => fromJson,
  );

  Map<int, T> _maps = Map.fromIterable(
    iterable,
    key: (t) => getId(t),
    value: (t) => t,
  );

  return _maps;
}

listenDatachange<T>(Map<int, T> maps,
    {required String channel,
      required String schema,
      required String table,
      required T Function(Map<String, dynamic> json) fromJson,
      required int Function(T) getId,
      Function()? updateUI}) async {
  final supabase = Supabase.instance.client;

  supabase
      .channel(channel)
      .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: schema,
      table: table,
      callback: (payload) {
        switch (payload.eventType) {
        // case "INSERT" "UPDATE":
          case PostgresChangeEvent.insert:
          case PostgresChangeEvent.update:
            {
              T t = fromJson(payload.newRecord);
              maps[getId(t)] = t;
              updateUI?.call();
              break;
            }

          case PostgresChangeEvent.delete:
            {
              maps.remove(payload.oldRecord["id"]);
              updateUI?.call();
              break;
            }

          default:
            {}
        }
      })
      .subscribe();
}