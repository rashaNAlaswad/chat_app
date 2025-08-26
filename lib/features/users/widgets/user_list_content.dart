import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_text_styles.dart';
import 'user_tile.dart';

class UserListContent extends StatelessWidget {
  const UserListContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userProvider.filteredUsers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64.w,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  userProvider.searchQuery.isNotEmpty
                      ? 'No users found'
                      : 'No users available',
                  style: AppTextStyles.font16Gray60SemiBold,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: userProvider.filteredUsers.length,
          itemBuilder: (context, index) {
            final user = userProvider.filteredUsers[index];
            return UserTile(
              user: user,
              onTap: () => _handleUserTap(context, user),
            );
          },
        );
      },
    );
  }

  void _handleUserTap(BuildContext context, user) {

  }
}
