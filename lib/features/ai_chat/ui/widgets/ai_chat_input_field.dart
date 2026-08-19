import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// حقل إدخال المحادثة.
///
/// الزر معطّل طالما هناك طلب قيد التنفيذ — لا يوجد أي تحديد لمعدّل الطلبات
/// على السيرفر، فمنع الضغط المتكرر مسؤولية الواجهة
class AiChatInputField extends StatefulWidget {
  final String hint;
  final bool enabled;
  final ValueChanged<String> onSend;

  const AiChatInputField({
    super.key,
    required this.hint,
    required this.enabled,
    required this.onSend,
  });

  @override
  State<AiChatInputField> createState() => _AiChatInputFieldState();
}

class _AiChatInputFieldState extends State<AiChatInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty || !widget.enabled) return;
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        border: Border(top: BorderSide(color: AppColors.borderGrey)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: widget.enabled,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyles.Size15.withColor(AppColors.coolGrey),
                  filled: true,
                  fillColor: AppColors.bgLight,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: const BorderSide(color: AppColors.borderGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: const BorderSide(color: AppColors.borderGrey),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: const BorderSide(color: AppColors.borderGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: const BorderSide(color: AppColors.primaryBlue),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Material(
              color: widget.enabled ? AppColors.primaryBlue : AppColors.coolGrey,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: widget.enabled ? _send : null,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Icon(
                    Icons.send_rounded,
                    color: AppColors.surfaceWhite,
                    size: 20.r,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
