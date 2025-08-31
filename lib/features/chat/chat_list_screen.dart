import 'package:chat_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/providers/chat_provider.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/helper/navigation_extensions.dart';
import 'widgets/chat_room_tile.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadChatRooms();
    });
  }

  Future<void> _loadChatRooms() async {
    await context.read<ChatProvider>().loadChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenPrimary,
        foregroundColor: AppColors.white,
        title: const Text('Chats'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(Routes.profile);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading chats...'),
                ],
              ),
            );
          }

          if (chatProvider.chatRooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80.w,
                    color: AppColors.gray60.withAlpha(50),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No chats yet',
                    style: AppTextStyles.font16Gray600Regular,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Start a conversation with someone!',
                    style: AppTextStyles.font14Gray60Regular,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadChatRooms,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: chatProvider.chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = chatProvider.chatRooms[index];
                return ChatRoomTile(
                  chatRoom: chatRoom,
                  onTap:
                      () => context.pushNamed(
                        Routes.chatDetail,
                        arguments: chatRoom.otherUserId,
                      ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(Routes.userList);
        },
        backgroundColor: AppColors.greenPrimary,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
