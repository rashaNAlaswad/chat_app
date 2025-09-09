import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/providers/chat_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatRoomId;

  const ChatDetailScreen({super.key, required this.chatRoomId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _cachedParticipantName = 'Chat';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  Future<void> _initializeChat() async {
    final chatProvider = context.read<ChatProvider>();

    if (widget.chatRoomId.isNotEmpty) {
      chatProvider.setCurrentChatRoom(widget.chatRoomId);

      final name = await chatProvider.getOtherUserName(widget.chatRoomId);
      if (mounted) {
        setState(() {
          _cachedParticipantName = name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenPrimary,
        foregroundColor: AppColors.white,
        title: Text(_cachedParticipantName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (chatProvider.messages.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildMessagesList(chatProvider);
              },
            ),
          ),
          MessageInput(
            controller: _messageController,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80.w, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text('No messages yet', style: AppTextStyles.font16Gray600Regular),
          SizedBox(height: 8.h),
          Text(
            'Start the conversation!',
            style: AppTextStyles.font14Gray60Regular,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(ChatProvider chatProvider) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: EdgeInsets.all(16.w),
      itemCount: chatProvider.messages.length,
      itemBuilder: (context, index) {
        final message = chatProvider.messages[index];
        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        final isMe = message.senderId == currentUserId;

        return MessageBubble(
          key: ValueKey(message.id ?? index),
          message: message,
          isMe: isMe,
        );
      },
    );
  }

  void _sendMessage(String message) {
    if (message.trim().isNotEmpty) {
      context.read<ChatProvider>().sendMessage(message.trim());
      _messageController.clear();

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
