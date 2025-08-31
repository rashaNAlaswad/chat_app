import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSendMessage;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSendMessage,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isComposing = widget.controller.text.isNotEmpty;
    });
  }

  void _handleSubmitted(String text) {
    if (text.trim().isNotEmpty) {
      widget.onSendMessage(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: TextField(
                  controller: widget.controller,
                  onSubmitted: _handleSubmitted,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              decoration: BoxDecoration(
                color: _isComposing ? AppColors.greenPrimary : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed:
                    _isComposing
                        ? () => _handleSubmitted(widget.controller.text)
                        : null,
                icon: Icon(
                  Icons.send,
                  color: _isComposing ? AppColors.white : Colors.grey[500],
                  size: 20.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
