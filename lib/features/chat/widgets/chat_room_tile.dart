import 'package:chat_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/models/chat_room.dart';
import '../../../core/providers/chat_provider.dart';
import '../../../core/theme/app_colors.dart';

class ChatRoomTile extends StatelessWidget {
  final ChatRoom chatRoom;
  final VoidCallback onTap;

  const ChatRoomTile({super.key, required this.chatRoom, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final chatProvider = getIt<ChatProvider>();
    final currentUserId = chatProvider.currentUserId;
    final otherParticipantName = _getOtherParticipantName();

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: _buildAvatar(otherParticipantName),
        title: _buildTitle(otherParticipantName),
        subtitle: _buildSubtitle(currentUserId, chatProvider),
        trailing: _buildTrailingIcon(currentUserId),
      ),
    );
  }

  String _getOtherParticipantName() {
    return chatRoom.otherUserName.isNotEmpty
        ? chatRoom.otherUserName
        : 'Unknown User';
  }

  Widget _buildAvatar(String participantName) {
    return CircleAvatar(
      backgroundColor: AppColors.greenPrimary,
      radius: 25.r,
      child: Text(
        participantName[0].toUpperCase(),
        style: AppTextStyles.font16WhiteSemiBold,
      ),
    );
  }

  Widget _buildTitle(String participantName) {
    return Row(
      children: [
        Expanded(
          child: Text(
            participantName,
            style: AppTextStyles.font16Gray60SemiBold.copyWith(
              color: AppColors.black100,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (chatRoom.unreadCount > 0) _buildUnreadBadge(),
      ],
    );
  }

  Widget _buildUnreadBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.greenPrimary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        chatRoom.unreadCount.toString(),
        style: AppTextStyles.font12WhiteSemiBold,
      ),
    );
  }

  Widget _buildSubtitle(String? currentUserId, ChatProvider chatProvider) {
    final lastMessageText = _getLastMessageText(currentUserId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: Text(
                lastMessageText,
                style: AppTextStyles.font14Gray60Regular,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              _formatTime(chatRoom.lastMessageTime),
              style: AppTextStyles.font12Gray60Regular,
            ),
          ],
        ),
      ],
    );
  }

  String _getLastMessageText(String? currentUserId) {
    final isFromOtherUser = chatRoom.lastMessageSenderId != currentUserId;
    final hasSenderName = chatRoom.lastMessageSenderName?.isNotEmpty == true;

    if (isFromOtherUser && hasSenderName) {
      return '${chatRoom.lastMessageSenderName}: ${chatRoom.lastMessage}';
    }

    return chatRoom.lastMessage;
  }

  Widget? _buildTrailingIcon(String? currentUserId) {
    final isFromCurrentUser = chatRoom.lastMessageSenderId == currentUserId;

    if (!isFromCurrentUser) return null;

    final hasUnreadMessages = chatRoom.unreadCount > 0;
    final icon = hasUnreadMessages ? Icons.done_all : Icons.done;
    final color = hasUnreadMessages ? AppColors.greenPrimary : Colors.grey;

    return Icon(icon, size: 16.w, color: color);
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
