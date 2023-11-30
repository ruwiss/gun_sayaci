import 'dart:convert';

class DataModel {
  int? id;
  final DateTime dateTime;
  final String title;
  final int color;
  String? emoji;

  DataModel(this.dateTime, this.title, this.color, [this.emoji]);

  DataModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        dateTime = DateTime.parse(json["dateTime"]),
        title = json["title"],
        color = json["color"],
        emoji = json['emoji'] == null
            ? null
            : utf8.decode(utf8.encode(json['emoji']));

  Map<String, dynamic> toMap() {
    var data = {
      "dateTime": dateTime.toString(),
      "title": title,
      "color": color
    };
    if (emoji != null) data['emoji'] = emoji!;
    return data;
  }
}
