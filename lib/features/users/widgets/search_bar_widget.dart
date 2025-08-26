import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/user_provider.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;

  const SearchBarWidget({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          context.read<UserProvider>().searchUsers(value);
        },
        decoration: InputDecoration(
          hintText: 'Search users by name or email...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    searchController.clear();
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
    );
  }
}
