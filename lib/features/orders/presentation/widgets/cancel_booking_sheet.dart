import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/booking_model.dart';
import '../../data/order_rules.dart';

/// ورقة تأكيد إلغاء الحجز.
///
/// سبب الإلغاء **مطلوب** من الباك اند (حد أقصى 500 حرف) وإغفاله يعطي 422،
/// لذلك الحقل إلزامي هنا ولا يمكن التأكيد بدونه.
/// تعيد السبب عند التأكيد، أو null عند التراجع.
class CancelBookingSheet extends StatefulWidget {
  final BookingModel order;

  const CancelBookingSheet({super.key, required this.order});

  static Future<String?> show(BuildContext context, BookingModel order) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CancelBookingSheet(order: order),
    );
  }

  @override
  State<CancelBookingSheet> createState() => _CancelBookingSheetState();
}

class _CancelBookingSheetState extends State<CancelBookingSheet> {
  final TextEditingController _reasonController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const int _maxReasonLength = 500;

  /// أسباب جاهزة تختصر الكتابة على المستخدم
  static const List<String> _presetReasons = [
    'غيّرت رأيي',
    'الموعد لم يعد مناسباً',
    'حجزت عن طريق الخطأ',
    'وجدت خدمة أخرى',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    Navigator.pop(context, _reasonController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final deadline = OrderRules.cancelDeadline(widget.order);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.borderGrey,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),

                Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: AppColors.errorColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        Icons.event_busy_rounded,
                        color: AppColors.errorColor,
                        size: 22.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'إلغاء الحجز',
                            style: TextStyles.Size18
                                .withColor(AppColors.darkBlueBlack)
                                .withWeight(FontWeight.bold),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'الطلب رقم #${widget.order.id}',
                            style: TextStyles.Size10.withColor(
                              AppColors.coolGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // المستخدم لا يخفي صفاً من القائمة — هذه آثار فعلية على رصيده
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColors.lightGoldSurface,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: AppColors.goldAccent.withOpacity(0.35),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16.r,
                            color: AppColors.goldAccent,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'ماذا يحدث عند الإلغاء؟',
                            style: TextStyles.Size10
                                .withColor(AppColors.darkBlueBlack)
                                .withWeight(FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      const _ConsequenceLine(
                        'يُعاد المبلغ المدفوع حسب طريقة الدفع',
                      ),
                      const _ConsequenceLine(
                        'تُسترجع نقاط الولاء التي رُبحت من الطلب',
                      ),
                      const _ConsequenceLine('تُعاد المواد المحجوزة إلى المخزون'),
                      const _ConsequenceLine('يبقى الطلب في السجل بحالة ملغي'),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  'سبب الإلغاء (مطلوب)',
                  style: TextStyles.Size15
                      .withColor(AppColors.darkBlueBlack)
                      .withWeight(FontWeight.w600),
                ),
                SizedBox(height: 10.h),

                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _presetReasons.map((reason) {
                    final isSelected = _reasonController.text == reason;
                    return InkWell(
                      onTap: () =>
                          setState(() => _reasonController.text = reason),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.lightBlueSurface,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          reason,
                          style: TextStyles.Size10.withColor(
                            isSelected
                                ? AppColors.surfaceWhite
                                : AppColors.darkBlueBlack,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12.h),

                TextFormField(
                  controller: _reasonController,
                  maxLines: 3,
                  maxLength: _maxReasonLength,
                  textInputAction: TextInputAction.done,
                  style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
                  decoration: InputDecoration(
                    hintText: 'اكتب سبب الإلغاء هنا',
                    hintStyle: TextStyles.Size15.withColor(AppColors.coolGrey),
                    filled: true,
                    fillColor: AppColors.bgLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(color: AppColors.borderGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(color: AppColors.borderGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(color: AppColors.primaryBlue),
                    ),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'سبب الإلغاء مطلوب';
                    if (text.length > _maxReasonLength) {
                      return 'الحد الأقصى $_maxReasonLength حرف';
                    }
                    return null;
                  },
                ),

                if (deadline != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14.r,
                        color: AppColors.coolGrey,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          'الإلغاء متاح حتى ${OrderRules.formatDateTime(deadline)}',
                          style: TextStyles.Size10.withColor(AppColors.coolGrey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                ],

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.borderGrey),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          'تراجع',
                          style: TextStyles.Size15
                              .withColor(AppColors.darkBlueBlack)
                              .withWeight(FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorColor,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          'تأكيد الإلغاء',
                          style: TextStyles.Size15
                              .withColor(AppColors.surfaceWhite)
                              .withWeight(FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConsequenceLine extends StatelessWidget {
  final String text;

  const _ConsequenceLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Container(
              width: 4.r,
              height: 4.r,
              decoration: const BoxDecoration(
                color: AppColors.coolGrey,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.Size10
                  .withColor(AppColors.darkBlueBlack)
                  .withHeight(1.6),
            ),
          ),
        ],
      ),
    );
  }
}
