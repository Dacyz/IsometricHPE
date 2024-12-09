
import 'package:app_position/features/voice/presentation/voice_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoiceSettings extends StatelessWidget {
  const VoiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final setting = context.read<VoiceRepository>();
    final localeVoices = setting.localeVoices;
    final indexVoice = setting.indexVoice;
    final voices = setting.voices;
    final indexAvailableVoice = setting.indexAvailableVoice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Idioma disponible'),
        if (localeVoices.isNotEmpty)
          DropdownButton(
              value: localeVoices[indexVoice],
              isExpanded: true,
              items: localeVoices
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setting.indexVoice = localeVoices.indexOf(value);
              }),
        const SizedBox(height: 16),
        const Text('Voz disponible en idioma seleccionado'),
        if (localeVoices.isNotEmpty && voices.isNotEmpty)
          DropdownButton(
              value: voices[indexAvailableVoice],
              isExpanded: true,
              items: voices
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text('${e['name']}')))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setting.indexAvailableVoice = voices.indexOf(value);
              }),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextFormField(
                  controller: setting.textToSpetch,
                  decoration: const InputDecoration(labelText: 'Texto a leer'),
                  onChanged: (value) {
                    setting.textToSpetch.text = value;
                  }),
            ),
            ElevatedButton.icon(
                onPressed: setting.proof,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Reproducir')),
          ],
        )
      ],
    );
  }
}
