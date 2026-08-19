import 'dart:async';

import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:car_care_plus/features/booking/data/models/booking_quote_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/booking_model.dart';
import '../data/models/rebook_prefill_model.dart';
import '../data/order_rules.dart';
import '../data/repos/order_actions_repo.dart';
import '../logic/order_actions_cubit.dart';
import '../logic/order_actions_state.dart';

/// شاشة إعادة الحجز.
///
/// الخدمة الأساسية مقفلة من الباك اند، وكل ما عداها يأتي معبّأً من الحجز الأصلي.
/// نعرض للتعديل الحقول التي تهم المستخدم فعلاً عند تكرار طلب (الموعد، طريقة
/// الدفع، VIP، الملاحظات) ونمرّر باقي الحقول كما وصلت — المواد والخدمات الفرعية
/// وتفاصيل السحب والصيانة والمساعدة على الطريق — دون المساس بها.
class RebookPage extends StatelessWidget {
  final BookingModel order;

  const RebookPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OrderActionsCubit(OrderActionsRepo())..loadRebookForm(order.id),
      child: _RebookBody(order: order),
    );
  }
}

class _RebookBody extends StatefulWidget {
  final BookingModel order;

  const _RebookBody({required this.order});

  @override
  State<_RebookBody> createState() => _RebookBodyState();
}

class _RebookBodyState extends State<_RebookBody> {
  final TextEditingController _notesController = TextEditingController();

  bool _isImmediate = false;
  DateTime? _scheduledAt;
  bool _isVip = false;
  String _paymentMethod = 'cash';
  int? _userPackageId;

  /// عدّاد صلاحية التسعيرة (15 دقيقة) — يعيد البناء كل ثانية
  Timer? _expiryTicker;

  static const Map<String, String> _paymentMethods = {
    'cash': 'نقداً',
    'wallet': 'المحفظة',
    'points': 'النقاط',
    'package': 'باقة',
  };

  @override
  void dispose() {
    _expiryTicker?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  void _seedFromPrefill(RebookPrefillModel prefill) {
    _isImmediate = prefill.isImmediate;
    _isVip = prefill.isVip;
    _paymentMethod = _paymentMethods.containsKey(prefill.paymentMethod)
        ? prefill.paymentMethod
        : 'cash';
    _notesController.text = prefill.notes;
    // الموعد الأصلي يعود دائماً فارغاً لأنه في الماضي — المستخدم يختار موعداً جديداً
    _scheduledAt = null;
    // باقة الطلب القديم غالباً مستهلكة، لا نفترض صلاحيتها
    _userPackageId = null;
  }

  void _startExpiryTicker() {
    _expiryTicker?.cancel();
    _expiryTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt ?? now.add(const Duration(hours: 2)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _scheduledAt ?? now.add(const Duration(hours: 2)),
      ),
    );
    if (time == null || !mounted) return;

    setState(() {
      _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _requestQuote() {
    // الحجز المجدول يتطلب موعداً مستقبلياً، ولا يُرسل الموعد أصلاً للحجز الفوري
    if (!_isImmediate) {
      if (_scheduledAt == null) {
        _showMessage('اختر موعد الحجز أولاً');
        return;
      }
      if (!_scheduledAt!.isAfter(DateTime.now())) {
        _showMessage('يجب اختيار موعد في المستقبل');
        return;
      }
    }

    context.read<OrderActionsCubit>().requestQuote(
      bookingId: widget.order.id,
      isImmediate: _isImmediate,
      scheduledAt: _scheduledAt,
      paymentMethod: _paymentMethod,
      isVip: _isVip,
      notes: _notesController.text,
      userPackageId: _userPackageId,
    );
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? AppColors.errorColor
              : AppColors.successColor,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: BlocConsumer<OrderActionsCubit, OrderActionsState>(
        listener: (context, state) {
          if (state is RebookPrefillSuccessState) {
            setState(() => _seedFromPrefill(state.prefill));
          }

          if (state is RebookQuoteSuccessState) {
            _startExpiryTicker();
          }

          if (state is RebookPackageSelectionState) {
            _expiryTicker?.cancel();
            _showMessage('اختر الباقة التي تريد استخدامها');
          }

          if (state is RebookErrorState) {
            _showMessage(state.message);
          }

          if (state is RebookConfirmSuccessState) {
            _expiryTicker?.cancel();
            _showMessage(state.message, isError: false);
            // نعيد true ليعرف السجل أنه يحتاج تحديثاً
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          final cubit = context.read<OrderActionsCubit>();
          final prefill = cubit.prefill;

          if (state is RebookPrefillLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }

          if (prefill == null) {
            return _ErrorRetry(
              message: state is RebookErrorState
                  ? state.message
                  : 'تعذر تحميل بيانات إعادة الحجز',
              onRetry: () => cubit.loadRebookForm(widget.order.id),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(order: widget.order, prefill: prefill),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
                  children: [
                    _LockedServiceCard(order: widget.order, prefill: prefill),
                    SizedBox(height: 16.h),
                    _buildTimingSection(),
                    SizedBox(height: 16.h),
                    _buildPaymentSection(state),
                    SizedBox(height: 16.h),
                    _buildExtrasSection(),
                    SizedBox(height: 20.h),
                    if (state is RebookQuoteSuccessState) ...[
                      _QuoteCard(quote: state.quote),
                      SizedBox(height: 16.h),
                    ],
                    _buildActionButton(context, state, cubit),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==================== الأقسام ====================

  Widget _buildTimingSection() {
    return _Section(
      title: 'موعد الحجز',
      icon: Icons.event_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _ChoiceChip(
                  label: 'مجدول',
                  isSelected: !_isImmediate,
                  onTap: () => setState(() => _isImmediate = false),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _ChoiceChip(
                  label: 'فوري',
                  isSelected: _isImmediate,
                  onTap: () => setState(() => _isImmediate = true),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (_isImmediate)
            _InfoNote(
              icon: Icons.bolt_rounded,
              text: 'سيبدأ التنفيذ خلال ساعة من تأكيد الحجز',
            )
          else
            InkWell(
              onTap: _pickDateTime,
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: _scheduledAt == null
                        ? AppColors.borderGrey
                        : AppColors.primaryBlue,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 18.r,
                      color: AppColors.primaryBlue,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        _scheduledAt == null
                            ? 'اختر التاريخ والوقت'
                            : OrderRules.formatDateTime(_scheduledAt),
                        style: TextStyles.Size15.withColor(
                          _scheduledAt == null
                              ? AppColors.coolGrey
                              : AppColors.darkBlueBlack,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 13.r,
                      color: AppColors.coolGrey,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(OrderActionsState state) {
    return _Section(
      title: 'طريقة الدفع',
      icon: Icons.payments_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _paymentMethods.entries.map((entry) {
              return _ChoiceChip(
                label: entry.value,
                isSelected: _paymentMethod == entry.key,
                isCompact: true,
                onTap: () => setState(() {
                  _paymentMethod = entry.key;
                  // الباقة تُختار من القائمة التي يعيدها السيرفر
                  _userPackageId = null;
                }),
              );
            }).toList(),
          ),

          // السيرفر يطلب اختيار الباقة بردّ 200 منفصل بلا تسعيرة
          if (state is RebookPackageSelectionState) ...[
            SizedBox(height: 14.h),
            Text(
              'اختر الباقة',
              style: TextStyles.Size10
                  .withColor(AppColors.darkBlueBlack)
                  .withWeight(FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            if (state.availablePackages.isEmpty)
              _InfoNote(
                icon: Icons.error_outline_rounded,
                text: 'لا توجد باقات صالحة لهذا الحجز، اختر طريقة دفع أخرى',
              )
            else
              ...state.availablePackages.map((package) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _PackageOption(
                    package: package,
                    isSelected: _userPackageId == package.id,
                    onTap: () => setState(() => _userPackageId = package.id),
                  ),
                );
              }),
          ],
        ],
      ),
    );
  }

  Widget _buildExtrasSection() {
    return _Section(
      title: 'تفاصيل إضافية',
      icon: Icons.tune_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile.adaptive(
            value: _isVip,
            onChanged: (value) => setState(() => _isVip = value),
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.primaryBlue,
            title: Text(
              'خدمة VIP',
              style: TextStyles.Size15
                  .withColor(AppColors.darkBlueBlack)
                  .withWeight(FontWeight.w600),
            ),
            subtitle: Text(
              'أولوية في التنفيذ مقابل رسوم إضافية',
              style: TextStyles.Size10.withColor(AppColors.coolGrey),
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _notesController,
            maxLines: 3,
            maxLength: 1000,
            style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
            decoration: InputDecoration(
              hintText: 'ملاحظات للفني (اختياري)',
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
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    OrderActionsState state,
    OrderActionsCubit cubit,
  ) {
    final isQuoting = state is RebookQuoteLoadingState;
    final isConfirming = state is RebookConfirmLoadingState;
    final hasQuote = state is RebookQuoteSuccessState;

    if (hasQuote) {
      final expired = cubit.isQuoteExpired;
      return Column(
        children: [
          if (expired)
            _InfoNote(
              icon: Icons.timer_off_rounded,
              text: 'انتهت صلاحية التسعيرة، أعد التسعير للمتابعة',
              isWarning: true,
            ),
          SizedBox(height: expired ? 12.h : 0),
          SizedBox(
            height: 52.h,
            child: ElevatedButton.icon(
              // تعطيل مزدوج: أثناء الإرسال وبعد انتهاء الصلاحية،
              // فالرمز يُستهلك مرة واحدة وإعادة إرساله تعطي 422
              onPressed: (isConfirming || expired)
                  ? null
                  : () => cubit.confirmRebooking(),
              icon: isConfirming
                  ? SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.surfaceWhite,
                      ),
                    )
                  : Icon(
                      Icons.check_circle_rounded,
                      size: 20.r,
                      color: AppColors.surfaceWhite,
                    ),
              label: Text(
                isConfirming ? 'جارٍ التأكيد' : 'تأكيد الحجز',
                style: TextStyles.Size15
                    .withColor(AppColors.surfaceWhite)
                    .withWeight(FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successColor,
                disabledBackgroundColor: AppColors.coolGrey,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          TextButton(
            onPressed: isConfirming ? null : _requestQuote,
            child: Text(
              'إعادة التسعير',
              style: TextStyles.Size10
                  .withColor(AppColors.primaryBlue)
                  .withWeight(FontWeight.bold),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height: 52.h,
      child: ElevatedButton.icon(
        onPressed: isQuoting ? null : _requestQuote,
        icon: isQuoting
            ? SizedBox(
                width: 18.r,
                height: 18.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.surfaceWhite,
                ),
              )
            : Icon(
                Icons.receipt_long_rounded,
                size: 20.r,
                color: AppColors.surfaceWhite,
              ),
        label: Text(
          isQuoting ? 'جارٍ حساب السعر' : 'احسب السعر',
          style: TextStyles.Size15
              .withColor(AppColors.surfaceWhite)
              .withWeight(FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          disabledBackgroundColor: AppColors.coolGrey,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}

// ==================== أجزاء الواجهة ====================

class _Header extends StatelessWidget {
  final BookingModel order;
  final RebookPrefillModel prefill;

  const _Header({required this.order, required this.prefill});

  @override
  Widget build(BuildContext context) {
    return GradientHeader(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.surfaceWhite,
                  size: 22.r,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'إعادة الحجز',
                  style: TextStyles.Size24
                      .withColor(AppColors.surfaceWhite)
                      .withWeight(FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'تُنشأ نسخة جديدة من الطلب #${order.id} — الطلب الأصلي يبقى كما هو',
            style: TextStyles.Size10.withColor(
              AppColors.surfaceWhite.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _LockedServiceCard extends StatelessWidget {
  final BookingModel order;
  final RebookPrefillModel prefill;

  const _LockedServiceCard({required this.order, required this.prefill});

  @override
  Widget build(BuildContext context) {
    final serviceName =
        order.service?.nameAr ?? order.service?.name ?? 'الخدمة الأصلية';

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.lightBlueSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.lock_rounded,
              color: AppColors.primaryBlue,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: TextStyles.Size15
                      .withColor(AppColors.darkBlueBlack)
                      .withWeight(FontWeight.bold),
                ),
                SizedBox(height: 3.h),
                Text(
                  'الخدمة غير قابلة للتغيير في إعادة الحجز',
                  style: TextStyles.Size10.withColor(AppColors.coolGrey),
                ),
                if (order.car != null) ...[
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.directions_car_rounded,
                        size: 13.r,
                        color: AppColors.coolGrey,
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          '${order.car!.model} (${order.car!.plateNumber})',
                          style: TextStyles.Size10.withColor(
                            AppColors.darkBlueBlack,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final QuoteData quote;

  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    final expiresAt = quote.expiresAt == null
        ? null
        : DateTime.tryParse(quote.expiresAt!)?.toLocal();
    final remaining = expiresAt?.difference(DateTime.now());

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: AppColors.darkCardGradient,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: AppColors.cyanAccent,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'التسعيرة الجديدة',
                style: TextStyles.Size15
                    .withColor(AppColors.surfaceWhite)
                    .withWeight(FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'السعر محسوب بالأسعار الحالية وقد يختلف عن الطلب السابق',
            style: TextStyles.Size10.withColor(
              AppColors.surfaceWhite.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 14.h),

          ...quote.invoice.expand(
            (item) => [
              ...item.priceItems.map(
                (line) => _QuoteLine(label: line.label, amount: line.amount),
              ),
              if (item.priceItems.isEmpty)
                _QuoteLine(label: 'قيمة الخدمة', amount: item.servicePrice),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(
              height: 1,
              color: AppColors.surfaceWhite.withOpacity(0.15),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الإجمالي',
                style: TextStyles.Size15
                    .withColor(AppColors.surfaceWhite)
                    .withWeight(FontWeight.bold),
              ),
              Text(
                '${quote.totalPrice.toStringAsFixed(0)} ل.س',
                style: TextStyles.Size24
                    .withColor(AppColors.cyanAccent)
                    .withWeight(FontWeight.bold),
              ),
            ],
          ),

          if (quote.cashDueTotal != null) ...[
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المتبقي نقداً',
                  style: TextStyles.Size10.withColor(
                    AppColors.surfaceWhite.withOpacity(0.8),
                  ),
                ),
                Text(
                  '${quote.cashDueTotal!.toStringAsFixed(0)} ل.س',
                  style: TextStyles.Size15
                      .withColor(AppColors.goldAccent)
                      .withWeight(FontWeight.bold),
                ),
              ],
            ),
          ],

          if (remaining != null) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 14.r,
                    color: remaining.isNegative
                        ? AppColors.errorColor
                        : AppColors.cyanAccent,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    remaining.isNegative
                        ? 'انتهت صلاحية التسعيرة'
                        : 'صالحة ${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')} دقيقة',
                    style: TextStyles.Size10.withColor(AppColors.surfaceWhite),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuoteLine extends StatelessWidget {
  final String label;
  final double amount;

  const _QuoteLine({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyles.Size10.withColor(
                AppColors.surfaceWhite.withOpacity(0.85),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            '${amount.toStringAsFixed(0)} ل.س',
            style: TextStyles.Size10.withColor(AppColors.surfaceWhite),
          ),
        ],
      ),
    );
  }
}

class _PackageOption extends StatelessWidget {
  final AvailablePackage package;
  final bool isSelected;
  final VoidCallback onTap;

  const _PackageOption({
    required this.package,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightBlueSurface : AppColors.bgLight,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.borderGrey,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: 18.r,
              color: isSelected ? AppColors.primaryBlue : AppColors.coolGrey,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                package.name,
                style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _Section({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.04),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.r, color: AppColors.primaryBlue),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyles.Size15
                    .withColor(AppColors.darkBlueBlack)
                    .withWeight(FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCompact;

  const _ChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 16.w : 12.w,
          vertical: 11.h,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.bgLight,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.borderGrey,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.Size15
              .withColor(
                isSelected ? AppColors.surfaceWhite : AppColors.darkBlueBlack,
              )
              .withWeight(FontWeight.w600),
        ),
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isWarning;

  const _InfoNote({
    required this.icon,
    required this.text,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isWarning ? AppColors.errorColor : AppColors.primaryBlue;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.r, color: color),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.Size10.withColor(AppColors.darkBlueBlack),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 46.r,
              color: AppColors.errorColor,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
              ),
              child: Text(
                'إعادة المحاولة',
                style: TextStyles.Size15.withColor(AppColors.surfaceWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
