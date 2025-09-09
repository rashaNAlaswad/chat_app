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
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed && _isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ChatProvider>().refreshChatRooms();
        }
      });
    }
  }

  Future<void> _initializeScreen() async {
    if (_isInitialized) return;
    await _loadChatRooms();
    _isInitialized = true;
  }

  Future<void> _loadChatRooms() async {
    try {
      _clearError();
      await context.read<ChatProvider>().loadChatRooms();
    } catch (e) {
      if (mounted) {
        _setError('Failed to load chats. Please check your connection.');
      }
    }
  }

  void _setError(String message) {
    if (mounted) {
      setState(() {
        _errorMessage = message;
      });
    }
  }

  void _clearError() {
    if (mounted && _errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.greenPrimary,
      foregroundColor: AppColors.white,
      title: const Text('Chats'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () => context.pushNamed(Routes.profile),
          icon: const Icon(Icons.person),
          tooltip: 'Profile',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (_errorMessage != null) {
          return _buildErrorState();
        }

        if (chatProvider.isLoading && chatProvider.chatRooms.isEmpty) {
          return _buildLoadingState();
        }

        if (chatProvider.chatRooms.isEmpty) {
          return _buildEmptyState();
        }

        return _buildChatList(chatProvider);
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80.w,
              color: AppColors.red.withAlpha(50),
            ),
            SizedBox(height: 16.h),
            Text(
              'Something went wrong',
              style: AppTextStyles.font16Gray60SemiBold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              _errorMessage ?? 'An unexpected error occurred',
              style: AppTextStyles.font14Gray60Regular,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: _loadChatRooms,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenPrimary,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80.w,
              color: AppColors.gray60.withAlpha(50),
            ),
            SizedBox(height: 16.h),
            Text('No chats yet', style: AppTextStyles.font16Gray60SemiBold),
            SizedBox(height: 8.h),
            Text(
              'Start a conversation with someone!',
              style: AppTextStyles.font14Gray60Regular,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(ChatProvider chatProvider) {
    return RefreshIndicator(
      onRefresh: _loadChatRooms,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: chatProvider.chatRooms.length,
        itemBuilder: (context, index) {
          final chatRoom = chatProvider.chatRooms[index];
          return ChatRoomTile(
            key: ValueKey(chatRoom.id),
            chatRoom: chatRoom,
            currentUserId: chatProvider.currentUserId,
            onTap:
                () => context.pushNamed(
                  Routes.chatDetail,
                  arguments: chatRoom.id,
                ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => context.pushNamed(Routes.userList),
      backgroundColor: AppColors.greenPrimary,
      foregroundColor: AppColors.white,
      child: const Icon(Icons.person_add),
    );
  }
}
