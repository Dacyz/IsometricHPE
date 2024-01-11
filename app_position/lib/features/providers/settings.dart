import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Settings extends ChangeNotifier {
  final _flutterTts = FlutterTts();
  Settings() {
    _initTTS();
  }

  List<Map> get voices => availableVoices
      .where((element) => localeVoices.isEmpty
          ? false
          : element['locale'] == localeVoices[_indexVoice])
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

  void _initTTS() async {
    final voiceList = await _flutterTts.getVoices;
    try {
      final voicesList = List<Map>.from(voiceList);
      for (var element in voicesList) {
        final e = element['locale'] as String;
        // if (e.contains('es') || e.contains('en')) {
        if (e.contains('es')) {
          availableVoices.add(element);
          if (!localeVoices.contains(e)) {
            localeVoices.add(e);
          }
        }
      }
      notifyListeners();
    } catch (ex) {
      print(ex);
    }
  }

  void _setVoice() {
    if (currentVoice == null) return;
    final locale = currentVoice!['locale'] as String;
    _flutterTts.setVoice({
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
      _flutterTts.speak('No puedo reproducir un texto vació');
      return;
    }
    _flutterTts.speak(textToSpetch.text);
  }

}
