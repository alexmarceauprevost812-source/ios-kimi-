import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../services/kimi_api_service.dart';
import '../services/supabase_service.dart';

class ChatViewModel extends ChangeNotifier {
  final _api = KimiApiService();
  final _db = SupabaseService();

  final List<ChatMessage> messages = [];
  List<Map<String, dynamic>> conversations = [];
  String? conversationId;
  bool isLoading = false;

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userMessage = ChatMessage(role: MessageRole.user, content: trimmed);
    messages.add(userMessage);
    isLoading = true;
    notifyListeners();

    try {
      // Crée la conversation dans Supabase au premier message
      conversationId ??= await _db.createConversation(
        trimmed.length > 40 ? '${trimmed.substring(0, 40)}…' : trimmed,
      );
      await _db.saveMessage(conversationId!, userMessage);

      final reply = await _api.send(messages);
      final assistantMessage =
          ChatMessage(role: MessageRole.assistant, content: reply);
      messages.add(assistantMessage);
      await _db.saveMessage(conversationId!, assistantMessage);
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

  Future<void> refreshConversations() async {
    try {
      conversations = await _db.listConversations();
      notifyListeners();
    } catch (_) {
      // Hors-ligne ou non configuré : on ignore silencieusement
    }
  }

  Future<void> openConversation(String id) async {
    conversationId = id;
    isLoading = true;
    notifyListeners();
    try {
      messages
        ..clear()
        ..addAll(await _db.loadMessages(id));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void newConversation() {
    conversationId = null;
    messages.clear();
    notifyListeners();
  }
}
