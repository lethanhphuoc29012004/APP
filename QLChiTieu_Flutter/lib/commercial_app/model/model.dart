import 'package:thanhphuoc_flutter/commercial_app/model/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Fruit{
  int id;
  int? gia;
  String ten;
  String? moTa, anh;
  Fruit({required this.id, this.gia, required this.ten, this.moTa, this.anh});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'gia': this.gia,
      'ten': this.ten,
      'moTa': this.moTa,
      'anh': this.anh,
    };
  }

  factory Fruit.fromMap(Map<String, dynamic> map) {
    return Fruit(
      id: map['id'] as int,
      gia: map['gia'] as int,
      ten: map['ten'] as String,
      moTa: map['moTa'] as String,
      anh: map['anh'] as String,
    );
  }
}

//sau se sua nay de online
class FruitSnapshot{

  static Future<void> update(Fruit newFruit) async{
    await supabase
        .from('fruits')
        .update(newFruit.toMap())
        .eq('id', newFruit.id);
  }

  static Future<void> delete(int id) async{
    await supabase
        .from('fruits')
        .delete()
        .eq('id', id);
    await removeImage(bucket: "fruit", path: "fruit_$id");
  }

  static Stream<List<Fruit>> getFruitStream(){
    // var stream = supabase.from("fruits").stream(
    //     primaryKey: ["id"]);
    // return stream.map((maps) => maps.map(
    //       (e) => Fruit.fromMap(e),
    // ).toList());
    return getDataStream(
      table: "fruits",
      ids: ["id"],
      fromJson: (json) => Fruit.fromMap(json),
    );
  }

  static Future<void> insert(Fruit fruit) async{
    await supabase
        .from('fruits')
        .insert(fruit.toMap());
  }

  static Future<Map<int,Fruit>> getMapFruit()async{
    final supabase = Supabase.instance.client;
    Map<int, Fruit> _map = {};
    var data = await supabase.from("fruits").select();
    var iterable = data.map((e) => Fruit.fromMap(e),);
    _map = Map.fromIterable(
      iterable,
      key: (fruit) => fruit.id,
      value: (fruit) => fruit,
    );

    return _map;
  }

  static unsubriceListenFruitChange()
  {
    final supabase = Supabase.instance.client;
    supabase.channel("public:fruits").unsubscribe();
  }
  static listenChangeData(Map<int, Fruit> maps,{Function() ? updateUI}){
    final supabase = Supabase.instance.client;
    supabase
        .channel('public:fruits')
        .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'fruits',
        callback: (payload) {
          print('Change received: ${payload.toString()}');
          switch(payload.eventType){
            case PostgresChangeEvent.insert:
            case PostgresChangeEvent.update:
              {
                Fruit f = Fruit.fromMap(payload.newRecord);
                maps[f.id] = f;
                updateUI?.call();
                break;
              }
            case PostgresChangeEvent.delete:{
              // Fruit f = Fruit.fromMap(payload.oldRecord);
              maps.remove(payload.oldRecord["id"]);
              updateUI?.call();
              break;
            }
            default:{}
          }
        })
        .subscribe();
  }
  static List<Fruit> getAll(){
    return data;
  }


  static Future<Map<int, Fruit>> getFruit() async{
    final supabase = Supabase.instance.client;
    var data = await supabase.from("fruits").select();
    var iterable = data.map((e) => Fruit.fromMap(e),);
    Map<int, Fruit> _map = Map.fromIterable(
      iterable,
      key: (fruit) => fruit.id,
      value: (fruit) => fruit,
    );
    return _map;
  }
}

final data =<Fruit>[
  Fruit(id: 1, ten:"Lê", gia:40000,moTa:"Lê Việt Nam CLC", anh:"https://media.istockphoto.com/id/1299073137/vi/anh/l%C3%AA-b%E1%BB%8B-c%C3%B4-l%E1%BA%ADp-m%E1%BB%99t-qu%E1%BA%A3-l%C3%AA-xanh-r%C6%B0%E1%BB%A1i-v%E1%BB%9Bi-l%C3%A1-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng-l%C3%A1t-l%C3%AA-v%E1%BB%9Bi-%C4%91%C6%B0%E1%BB%9Dng-d%E1%BA%ABn-c%E1%BA%AFt-%C4%91%E1%BB%99-s%C3%A2u-tr%C6%B0%E1%BB%9Dng.jpg?s=612x612&w=0&k=20&c=F64HvCoe-fQIjpyk95kcP9YNH-wrtds0UWoXd6C1bvg="),
  Fruit(id: 2, ten:"Dâu tây", gia:30000,moTa:"Dâu tây trồng ở xứ ta", anh:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRf5EiIMtZmo7yxqd9ZENO-Pw_JRwDVrzWR-Q&s"),
  Fruit(id: 3, ten:"Na", gia:20000,moTa:"Na Việt Nam CLC", anh:"https://login.medlatec.vn//ImagePath/images/20221119/20221119_qua-na-2.jpg"),
  Fruit(id: 4, ten:"Táo", gia:40000,moTa:""
      "", anh:"https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474092LAo/anh-qua-tao-dep-nhat_095349569.jpg"),
  Fruit(id: 5, ten:"Mận", gia:20000,moTa:"Mận Việt Nam CLC", anh:"https://dulieuxanh.com/wp-content/uploads/2019/12/cay_man-1.jpg"),
  Fruit(id: 6, ten:"Sầu riêng", gia:70000,moTa:"Sầu riêng ri6 chín cây", anh:"https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474116FuX/anh-nen-trai-sau-rieng-ngon-nhat_042722109.jpg"),
  Fruit(id: 7, ten:"Ổi", gia:20000,moTa:"Mận Việt Nam CLC", anh:"https://media.istockphoto.com/id/686678072/vi/anh/tr%C3%A1i-%E1%BB%95i-%C4%91%E1%BB%8F-c%C3%B4-l%E1%BA%ADp-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng.jpg?s=612x612&w=0&k=20&c=JLnnlY2ESK52OG7omhXel4p7b1F7ktGZEyOoVHXnfvs="),
  Fruit(id: 8, ten:"Nho", gia:20000,moTa:"Nho Việt Nam CLC", anh:"https://media.istockphoto.com/id/682505832/vi/anh/nho-%C4%91%E1%BB%8F-ch%C3%ADn-b%C3%B3-m%C3%A0u-h%E1%BB%93ng-v%E1%BB%9Bi-l%C3%A1-b%E1%BB%8B-c%C3%B4-l%E1%BA%ADp-tr%C3%AAn-m%C3%A0u-tr%E1%BA%AFng-v%E1%BB%9Bi-%C4%91%C6%B0%E1%BB%9Dng-d%E1%BA%ABn-c%E1%BA%AFt-%C4%91%E1%BB%99-s%C3%A2u-tr%C6%B0%E1%BB%9Dng-%E1%BA%A3nh-%C4%91%E1%BA%A7y.jpg?s=612x612&w=0&k=20&c=Wr26RKYB5lE1-WSXqWKkdFJN8XyynANw09Jm-bC-aaQ="),
  // Fruit(id: 9, ten:"Na", gia:20000,moTa:"Na Việt Nam CLC", anh:"https://login.medlatec.vn//ImagePath/images/20221119/20221119_qua-na-2.jpg"),
];

