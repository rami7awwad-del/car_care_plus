import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import '../../data/repos/rating_repo.dart';
import '../../logic/rating_cubit.dart';
import '../../logic/rating_state.dart';
import '../widgets/rating_card.dart';

class MyRatingsView extends StatelessWidget {
  const MyRatingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RatingCubit(RatingRepo(ApiService()))..getMyRatings(),
      child: Scaffold(
        backgroundColor: AppColors.bgLight,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.surfaceWhite,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'تقييماتي',
            style: TextStyles.Size18
                .withWeight(FontWeight.bold)
                .withColor(AppColors.darkBlueBlack),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<RatingCubit, RatingState>(
            builder: (context, state) {
              final cubit = context.read<RatingCubit>();

              if (state is RatingsLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryBlue),
                );
              }

              if (state is RatingsErrorState && cubit.ratings.isEmpty) {
                return _ErrorRetry(
                  message: state.message,
                  onRetry: () => cubit.getMyRatings(),
                );
              }

              if (cubit.ratings.isEmpty) {
                return const _EmptyRatings();
              }

              return RefreshIndicator(
                color: AppColors.primaryBlue,
                onRefresh: () => cubit.getMyRatings(),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  itemCount: cubit.ratings.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 14),
                  itemBuilder: (context, index) =>
                      RatingCard(rating: cubit.ratings[index]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyRatings extends StatelessWidget {
  const _EmptyRatings();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_border_rounded,
            size: 64,
            color: AppColors.coolGrey.withOpacity(0.6),
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد تقييمات بعد',
            style: TextStyles.Size15.withColor(AppColors.coolGrey),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: AppColors.errorColor),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
            ),
            const SizedBox(height: 14),
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
