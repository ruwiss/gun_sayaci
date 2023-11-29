class DataModel {
  int? id;
  final DateTime dateTime;
  final String title;
  final int color;

  DataModel(this.dateTime, this.title, this.color);

  DataModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        dateTime = DateTime.parse(json["dateTime"]),
        title = json["title"],
        color = json["color"];

  Map<String, dynamic> toMap() {
    return {"dateTime": dateTime.toString(), "title": title, "color": color};
  }
}
