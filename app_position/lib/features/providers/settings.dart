import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

mixin Settings on ChangeNotifier {
  final flutterTts = FlutterTts();

  List<Map> get voices => availableVoices
      .where((element) => localeVoices.isEmpty ? false : element['locale'] == localeVoices[_indexVoice])
      .toList();
  final List<String> localeVoices = [];
  final List<Map> availableVoices = [];

  final textToSpetch = TextEditingController(text: 'Mensaje de prueba');

  int get indexVoice => _indexVoice;
  int _indexVoice = 0;
  set indexVoice(int value) {
    _indexVoice = value;
    _indexAvailableVoice = 0;
    notifyListeners();
  }

  int _indexAvailableVoice = 0;
  int get indexAvailableVoice => _indexAvailableVoice;
  set indexAvailableVoice(int value) {
    _indexAvailableVoice = value;
    notifyListeners();
  }

  Map? get currentVoice => voices.isEmpty ? null : voices[indexAvailableVoice];

  void proof() {
    _setVoice();
    _speak();
  }

  void _setVoice() {
    if (currentVoice == null) return;
    final locale = currentVoice!['locale'] as String;
    flutterTts.setVoice({
      'name': currentVoice!['name'],
      'locale': locale,
    });
    // if (locale.contains('es')) {
    //   _flutterTts.speak('Mensaje de prueba');
    // } else {
    //   _flutterTts.speak('Proof message');
    // }
  }

  void _speak() {
    if (textToSpetch.text.trim().isEmpty) {
      flutterTts.speak('No puedo reproducir un texto vació');
      return;
    }
    flutterTts.speak(textToSpetch.text);
  }

  void talk([String? text]) {
    try {
      flutterTts.speak(text ?? textToSpetch.text);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
