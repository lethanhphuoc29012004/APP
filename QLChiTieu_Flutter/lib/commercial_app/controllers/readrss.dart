import 'dart:convert';

import 'package:thanhphuoc_flutter/commercial_app/controllers/rss_resource.dart';
import 'package:thanhphuoc_flutter/commercial_app/model/rss_item.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
void main() async {
  var url = "https://vnexpress.net/rss/tin-moi-nhat.rss";

  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Xml2Json xml2json = Xml2Json();
    xml2json.parse(utf8.decode(response.bodyBytes));

    String body = xml2json.toParker();

    var data = json.decode(body)["rss"]["channel"]["item"] as List;

    var rssItem = RssItem.empty().fromJson(data[0], rssResource[0]);
  }
}