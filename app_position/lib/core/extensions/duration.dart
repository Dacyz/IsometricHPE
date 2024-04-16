extension DurationExtension on Duration {
  String get toTime =>
      '${inMinutes.toString().padLeft(2, '0')}:${(inSeconds % 60).toString().padLeft(2, '0')}.${(inMilliseconds % 1000).toString().padLeft(3, '0')}';
}
