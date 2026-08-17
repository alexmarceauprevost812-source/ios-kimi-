import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../services/kimi_api_service.dart';

class ChatViewModel extends ChangeNotifier {
  final _api = KimiApiService();

  final List<ChatMessage> messages = [];
  bool isLoading = false;

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    messages.add(ChatMessage(role: MessageRole.user, content: trimmed));
    isLoading = true;
    notifyListeners();

    try {
      final reply = await _api.send(messages);
      messages.add(ChatMessage(role: MessageRole.assistant, content: reply));
    } catch (e) {
      messages.add(ChatMessage(
        role: MessageRole.assistant,
        content: 'Erreur : $e',
      ));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
