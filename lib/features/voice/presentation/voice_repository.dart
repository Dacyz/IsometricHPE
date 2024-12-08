import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceRepository with ChangeNotifier {
  VoiceRepository() {
    _initTTS();
  }
  final flutterTts = FlutterTts();

  void _initTTS() async {
    final voiceList = await flutterTts.getVoices;
    flutterTts.awaitSpeakCompletion(true);
    flutterTts.awaitSynthCompletion(true);
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
      debugPrint(ex.toString());
    }
  }

  List<Map> get voices => availableVoices
      .where((element) => localeVoices.isEmpty
          ? false
          : element['locale'] == localeVoices[_indexVoice])
      .toList();
  final List<String> localeVoices = [];
  final List<Map> availableVoices = [];

  bool _isSpeaking = false;

  bool get isSpeaking => !_isSpeaking;
  set isSpeaking(bool value) {
    _isSpeaking = value;
    notifyListeners();
  }

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
  }

  void _speak() {
    if (textToSpetch.text.trim().isEmpty) {
      flutterTts.speak('No puedo reproducir un texto vació');
      return;
    }
    flutterTts.speak(textToSpetch.text);
  }

  void talk([String? text, bool priority = true]) async {
    if (_isSpeaking && !priority) return;
    try {
      _isSpeaking = true;
      await flutterTts.speak(text ?? textToSpetch.text);
      _isSpeaking = false;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
