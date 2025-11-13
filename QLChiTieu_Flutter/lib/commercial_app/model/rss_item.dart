

import '../controllers/rss_resource.dart';

class RssItem{
  String? title, pubDate, link, imageUrl, description;

  RssItem.empty();
  RssItem fromJson(Map<String, dynamic> json, rssresource resource){
    this.title = json["title"];
    this.link = json["link"];
    this.pubDate = json["pubDate"];
    this.imageUrl = getImageUrl(json["description"], resource);
    this.description = getDescription(json["description"], resource);
    return this;
  }
}
String? getImageUrl(String rawDescription, rssresource resource){
  String startRegex = resource.startImageRegrex;
  String endRegrex = resource.endImageRegrex;
  int start = rawDescription.indexOf(startRegex) + startRegex.length;
  if(start >= startRegex.length){
    if(endRegrex.length>0){
      int end = rawDescription.indexOf(endRegrex, start);
      return rawDescription.substring(start,end);
    }
    return rawDescription.substring(start);
  }
  return null;
}
String getDescription(String rawDescription, rssresource resource){
  String startRegrex = resource.startDescriptionRegrex;
  String endRegrex = resource.endDescriptionRegrex;
  int start = rawDescription.indexOf(startRegrex) + startRegrex.length;
  if(start >= startRegrex.length){
    if (endRegrex.length > 0){
      int end = rawDescription.indexOf(endRegrex, start);
      return rawDescription.substring(start, end);
    }
    return rawDescription.substring(start);
  }
  return "";
}