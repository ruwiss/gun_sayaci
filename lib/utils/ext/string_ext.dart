extension StringExtensions on String {
  bool parseBool() => this == 'true';

  bool isEmoji() => RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')
      .hasMatch(this);
}
