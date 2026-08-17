enum MessageRole { user, assistant }

class ChatMessage {
  ChatMessage({
    required this.role,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final MessageRole role;
  final String content;
  final DateTime timestamp;

  Map<String, String> toApiJson() => {
        'role': role == MessageRole.user ? 'user' : 'assistant',
        'content': content,
      };
}
