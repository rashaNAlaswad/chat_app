import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/models/user_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const UserTile({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: _UserAvatar(user: user),
        title: _UserInfoSection(user: user),
        trailing: _ChatActionButton(onTap: onTap),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final UserModel user;

  const _UserAvatar({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.greenPrimary,
          radius: 25.r,
          child: Text(
            _getInitials(),
            style: AppTextStyles.font18WhiteSemiBold,
          ),
        ),
        if (user.isOnline) _buildOnlineIndicator(),
      ],
    );
  }

  String _getInitials() {
    if (user.displayName.isEmpty) return '?';
    
    final nameParts = user.displayName.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return user.displayName[0].toUpperCase();
  }

  Widget _buildOnlineIndicator() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        width: 12.w,
        height: 12.h,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2.w,
          ),
        ),
      ),
    );
  }
}

class _UserInfoSection extends StatelessWidget {
  final UserModel user;

  const _UserInfoSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.displayName,
          style: AppTextStyles.font16Gray60SemiBold.copyWith(
            color: AppColors.black100,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          user.email,
          style: AppTextStyles.font14Gray60Regular,
        ),
        SizedBox(height: 4.h),
        
        _buildStatusText(),
      ],
    );
  }

  Widget _buildStatusText() {
    final statusText = user.isOnline 
        ? 'Online' 
        : 'Last seen ${_formatLastSeen(user.lastSeen)}';
    final statusColor = user.isOnline ? Colors.green : Colors.grey[500];
    
    return Text(
      statusText,
      style: AppTextStyles.font12Gray60Regular.copyWith(
        color: statusColor,
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'just now';
    }
  }
}

class _ChatActionButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ChatActionButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.greenPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.chat_bubble_outline,
          color: AppColors.greenPrimary,
          size: 20.w,
        ),
      ),
    );
  }
}
