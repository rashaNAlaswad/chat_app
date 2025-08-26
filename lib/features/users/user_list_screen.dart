import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/providers/user_provider.dart';
import '../../core/theme/app_colors.dart';

import '../../core/theme/app_font_weight.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/user_tile.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenPrimary,
        foregroundColor: AppColors.white,
        title: const Text('Find People'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<UserProvider>().searchUsers(value);
              },
              decoration: InputDecoration(
                hintText: 'Search users by name or email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          context.read<UserProvider>().searchUsers('');
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                if (userProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    if (userProvider.searchQuery.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Row(
                          children: [
                            Text(
                              'Found ${userProvider.filteredUsers.length} user${userProvider.filteredUsers.length == 1 ? '' : 's'}',
                              style: AppTextStyles.font14Gray60Regular.copyWith(
                                fontWeight: AppFontWeight.semiBold,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                context.read<UserProvider>().searchUsers('');
                              },
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: userProvider.filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = userProvider.filteredUsers[index];
                          return UserTile(
                            user: user,
                            onTap: () => {},
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

