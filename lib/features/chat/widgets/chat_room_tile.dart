import 'package:chat_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/chat_room.dart';
import '../../../core/theme/app_colors.dart';

class ChatRoomTile extends StatelessWidget {
  final ChatRoom chatRoom;
  final VoidCallback onTap;

  const ChatRoomTile({
    super.key,
    required this.chatRoom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final otherParticipantId = chatRoom.participantIds
        .firstWhere((id) => id != currentUserId, orElse: () => '');
    final otherParticipantName = chatRoom.participantNames[otherParticipantId] ?? 'Unknown';

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.greenPrimary,
          radius: 25.r,
          child: Text(
            otherParticipantName.isNotEmpty ? otherParticipantName[0].toUpperCase() : '?',
            style: AppTextStyles.font16WhiteSemiBold,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                otherParticipantName,
                style: AppTextStyles.font16WhiteSemiBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (chatRoom.unreadCount > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.greenPrimary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  chatRoom.unreadCount.toString(),
                  style: AppTextStyles.font12WhiteSemiBold,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    chatRoom.lastMessage,
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
        ),
        trailing: chatRoom.lastMessageSenderId == currentUserId
            ? Icon(
                Icons.done_all,
                size: 16.w,
                color: chatRoom.unreadCount > 0 ? Colors.grey : AppColors.greenPrimary,
              )
            : null,
      ),
    );
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
