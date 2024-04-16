extension IntegerExtension on int {
  String get toHex => '0x${toRadixString(16)}';

  String get toBinary => '0b${toRadixString(2)}';

  String get toOctal => '0o${toRadixString(8)}';

  String get toDecimal => toString();

  Duration get toDuration => Duration(milliseconds: this);
}