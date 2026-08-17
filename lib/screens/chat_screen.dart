import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/chat_view_model.dart';
import '../widgets/mascot_avatar.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChatViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            MascotAvatar(size: 32),
            SizedBox(width: 10),
            Text('Kimi'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: vm.messages.isEmpty
                ? const _Welcome()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: vm.messages.length,
                    itemBuilder: (context, i) =>
                        MessageBubble(message: vm.messages[i]),
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Écris ton message…',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: vm.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    onPressed: vm.isLoading
                        ? null
                        : () {
                            vm.send(_controller.text);
                            _controller.clear();
                            _scrollToBottom();
                          },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Écran d'accueil affiché quand il n'y a pas encore de messages.
class _Welcome extends StatelessWidget {
  const _Welcome();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MascotAvatar(size: 120),
          const SizedBox(height: 16),
          Text(
            'Salut ! Je suis Kimi.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Pose-moi ta question pour commencer.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
