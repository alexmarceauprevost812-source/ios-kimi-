import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/chat_message.dart';

/// Client minimal pour l'API Kimi (Moonshot AI).
///
/// Passe ta clé API avec :
///   flutter run --dart-define=KIMI_API_KEY=sk-...
class KimiApiService {
  static const _apiKey = String.fromEnvironment('KIMI_API_KEY');
  static const _model = 'kimi-k2-0711-preview';
  static final _endpoint =
      Uri.parse('https://api.moonshot.ai/v1/chat/completions');

  Future<String> send(List<ChatMessage> messages) async {
    if (_apiKey.isEmpty) {
      throw Exception('Clé API Kimi manquante (KIMI_API_KEY).');
    }

    final response = await http.post(
      _endpoint,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'messages': messages.map((m) => m.toApiJson()).toList(),
        'temperature': 0.6,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur API (${response.statusCode}) : ${response.body}');
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return json['choices'][0]['message']['content'] as String;
  }
}
