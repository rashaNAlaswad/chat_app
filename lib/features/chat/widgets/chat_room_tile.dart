import 'package:chat_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/models/chat_room.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/time_formatter.dart';

class ChatRoomTile extends StatelessWidget {
  final ChatRoom chatRoom;
  final VoidCallback onTap;
  final String? currentUserId;

  const ChatRoomTile({
    super.key,
    required this.chatRoom,
    required this.onTap,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final otherParticipantName = _getOtherParticipantName();

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: _buildAvatar(otherParticipantName),
        title: _buildTitle(otherParticipantName),
        subtitle: _buildSubtitle(),
        trailing: _buildTrailingIcon(),
      ),
    );
  }

  String _getOtherParticipantName() {
    return chatRoom.otherUserName.isNotEmpty
        ? chatRoom.otherUserName
        : 'Unknown User';
  }

  Widget _buildAvatar(String participantName) {
    final firstLetter = participantName[0].toUpperCase();

    return CircleAvatar(
      backgroundColor: AppColors.greenPrimary,
      radius: 25.r,
      child: Text(firstLetter, style: AppTextStyles.font16WhiteSemiBold),
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
        if (chatRoom.unreadCount > 0) UnreadBadge(count: chatRoom.unreadCount),
      ],
    );
  }

  Widget _buildSubtitle() {
    final lastMessageText = _getLastMessageText();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            const SizedBox(width: 8),
            Text(
              TimeFormatter.formatRelativeTime(chatRoom.lastMessageTime),
              style: AppTextStyles.font12Gray60Regular,
            ),
          ],
        ),
      ],
    );
  }

  String _getLastMessageText() {
    final isFromOtherUser = chatRoom.lastMessageSenderId != currentUserId;
    final hasSenderName = chatRoom.lastMessageSenderName?.isNotEmpty == true;

    if (isFromOtherUser && hasSenderName) {
      return '${chatRoom.lastMessageSenderName}: ${chatRoom.lastMessage}';
    }

    return chatRoom.lastMessage;
  }

  Widget? _buildTrailingIcon() {
    final isFromCurrentUser = chatRoom.lastMessageSenderId == currentUserId;

    if (!isFromCurrentUser) return null;

    final hasUnreadMessages = chatRoom.unreadCount > 0;
    final icon = hasUnreadMessages ? Icons.done_all : Icons.done;
    final color = hasUnreadMessages ? AppColors.greenPrimary : Colors.grey;

    return Icon(icon, size: 16.w, color: color);
  }
}

class UnreadBadge extends StatelessWidget {
  final int count;

  const UnreadBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.greenPrimary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(count.toString(), style: AppTextStyles.font12WhiteSemiBold),
    );
  }
}
