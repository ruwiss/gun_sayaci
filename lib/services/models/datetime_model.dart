class DateTimeModel {
  int year, month, day, hour, minute;
  DateTimeModel(this.year, this.month, this.day, this.hour, this.minute);
  DateTimeModel.empty()
      : year = 2025,
        month = 1,
        day = 1,
        hour = 0,
        minute = 0;

  DateTime createDateTime() => DateTime(year, month, day, hour, minute);
  DateTimeModel.convert(DateTime dateTime)
      : year = dateTime.year,
        month = dateTime.month,
        day = dateTime.day,
        hour = dateTime.hour,
        minute = dateTime.minute;
}
