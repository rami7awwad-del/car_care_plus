import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import '../../data/repos/rating_repo.dart';
import '../../logic/rating_cubit.dart';
import '../../logic/rating_state.dart';
import '../widgets/star_rating_bar.dart';

class CreateRatingView extends StatelessWidget {
  final int orderId;

  const CreateRatingView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RatingCubit(RatingRepo(ApiService())),
      child: _CreateRatingBody(orderId: orderId),
    );
  }
}

class _CreateRatingBody extends StatefulWidget {
  final int orderId;

  const _CreateRatingBody({required this.orderId});

  @override
  State<_CreateRatingBody> createState() => _CreateRatingBodyState();
}

class _CreateRatingBodyState extends State<_CreateRatingBody> {
  int _serviceRating = 0;
  int _employeeRating = 0;
  int _workshopRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_serviceRating < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تقييم الخدمة أولاً'),
          backgroundColor: AppColors.warningColor,
        ),
      );
      return;
    }
    context.read<RatingCubit>().createRating(
          orderId: widget.orderId,
          serviceRating: _serviceRating,
          employeeRating: _employeeRating > 0 ? _employeeRating : null,
          workshopRating: _workshopRating > 0 ? _workshopRating : null,
          comment: _commentController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surfaceWhite,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'قيّم الخدمة',
          style: TextStyles.Size18
              .withWeight(FontWeight.bold)
              .withColor(AppColors.darkBlueBlack),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<RatingCubit, RatingState>(
          listener: (context, state) {
            if (state is SubmitRatingSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('شكراً لك! تم إرسال تقييمك بنجاح'),
                  backgroundColor: AppColors.primaryBlue,
                ),
              );
              Navigator.pop(context, true);
            } else if (state is SubmitRatingErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.errorColor,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is SubmitRatingLoadingState;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'رأيك يهمّنا',
                    style: TextStyles.Size24
                        .withColor(AppColors.darkBlueBlack)
                        .withWeight(FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'قيّم تجربتك مع هذا الطلب لمساعدتنا على التحسّن',
                    style: TextStyles.Size15.withColor(AppColors.coolGrey),
                  ),
                  const SizedBox(height: 24),
                  _RatingSection(
                    title: 'الخدمة',
                    subtitle: 'إلزامي',
                    value: _serviceRating,
                    onChanged: (v) => setState(() => _serviceRating = v),
                  ),
                  const SizedBox(height: 14),
                  _RatingSection(
                    title: 'الموظف',
                    subtitle: 'اختياري',
                    value: _employeeRating,
                    onChanged: (v) => setState(() => _employeeRating = v),
                  ),
                  const SizedBox(height: 14),
                  _RatingSection(
                    title: 'الورشة',
                    subtitle: 'اختياري',
                    value: _workshopRating,
                    onChanged: (v) => setState(() => _workshopRating = v),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'تعليق (اختياري)',
                    style: TextStyles.Size15
                        .withColor(AppColors.darkBlueBlack)
                        .withWeight(FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    maxLength: 2000,
                    decoration: InputDecoration(
                      hintText: 'اكتب رأيك عن الخدمة...',
                      filled: true,
                      fillColor: AppColors.surfaceWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SubmitButton(onPressed: isLoading ? null : _submit, isLoading: isLoading),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RatingSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final ValueChanged<int> onChanged;

  const _RatingSection({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyles.Size18
                    .withColor(AppColors.darkBlueBlack)
                    .withWeight(FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                subtitle,
                style: TextStyles.Size10.withColor(AppColors.coolGrey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: StarRatingBar(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _SubmitButton({required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: AppColors.buttonGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: AppColors.surfaceWhite)
            : Text(
                'إرسال التقييم',
                style: TextStyles.Size18
                    .withColor(AppColors.surfaceWhite)
                    .withWeight(FontWeight.bold),
              ),
      ),
    );
  }
}
