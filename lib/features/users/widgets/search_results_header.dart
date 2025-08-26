import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_font_weight.dart';
import '../../../core/theme/app_text_styles.dart';

class SearchResultsHeader extends StatelessWidget {
  final VoidCallback onClearSearch;

  const SearchResultsHeader({
    super.key,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.searchQuery.isEmpty) return const SizedBox.shrink();

        return Container(
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
                onPressed: onClearSearch,
                child: const Text('Clear'),
              ),
            ],
          ),
        );
      },
    );
  }
}
