import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class Album{
  int albumId, id;//ten truong trung ten
  String title, url, thumbnailUrl;

  Album({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl
  });

  Map<String, dynamic> toMap() {
    return {
      'albumId': this.albumId,
      'id': this.id,
      'title': this.title,
      'url': this.url,
      'thumbnailUrl': this.thumbnailUrl,
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      albumId: map['albumId'] as int,
      id: map['id'] as int,
      title: map['title'] as String,
      url: map['url'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String,
    );
  }

}

Future<List<Album>> docDL() async{
  var response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
  if(response.statusCode == 200){
    var list = json.decode(response.body) as List; //List các Map<String, dynamic> object
    List<Album> albums;
    albums = list.map(
          (e) => Album.fromMap(e),
      // (e) => Album.fromJson(e),
    ).toList();
    return albums;
  }
  return Future.error(response.statusCode);

}