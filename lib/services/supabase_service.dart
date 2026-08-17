import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_message.dart';

/// Accès à la base de données Supabase : conversations + messages.
class SupabaseService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<String> createConversation(String title) async {
    final row = await _client
        .from('conversations')
        .insert({
          'user_id': _client.auth.currentUser!.id,
          'title': title,
        })
        .select('id')
        .single();
    return row['id'] as String;
  }

  Future<void> saveMessage(String conversationId, ChatMessage message) async {
    await _client.from('messages').insert({
      'conversation_id': conversationId,
      'role': message.role == MessageRole.user ? 'user' : 'assistant',
      'content': message.content,
    });
  }

  Future<List<Map<String, dynamic>>> listConversations() async {
    final rows = await _client
        .from('conversations')
        .select('id, title, updated_at')
        .order('updated_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<List<ChatMessage>> loadMessages(String conversationId) async {
    final rows = await _client
        .from('messages')
        .select('role, content, created_at')
        .eq('conversation_id', conversationId)
        .order('created_at');
    return rows
        .map<ChatMessage>((r) => ChatMessage(
              role:
                  r['role'] == 'user' ? MessageRole.user : MessageRole.assistant,
              content: r['content'] as String,
              timestamp: DateTime.parse(r['created_at'] as String),
            ))
        .toList();
  }
}
