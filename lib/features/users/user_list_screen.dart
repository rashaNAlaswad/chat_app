import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/user_provider.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_results_header.dart';
import 'widgets/user_list_content.dart';

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

  void _clearSearch() {
    _searchController.clear();
    context.read<UserProvider>().searchUsers('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          SearchBarWidget(searchController: _searchController),
          SearchResultsHeader(onClearSearch: _clearSearch),
          const Expanded(
            child: UserListContent(),
          ),
        ],
      ),
    );
  }
}

