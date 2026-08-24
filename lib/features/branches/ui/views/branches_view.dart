import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/repos/branches_repo.dart';
import '../../logic/branches_cubit.dart';
import '../../logic/branches_state.dart';
import '../widgets/branch_card.dart';
import 'branch_details_view.dart';

class BranchesView extends StatelessWidget {
  const BranchesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BranchesCubit(BranchesRepo(ApiService()))..fetchBranches(),
      child: const _BranchesBody(),
    );
  }
}

class _BranchesBody extends StatefulWidget {
  const _BranchesBody();

  @override
  State<_BranchesBody> createState() => _BranchesBodyState();
}

class _BranchesBodyState extends State<_BranchesBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: BlocConsumer<BranchesCubit, BranchesState>(
        listenWhen: (previous, current) =>
            current.errorMessage != null &&
            current.status == BranchesStatus.success &&
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.errorColor,
              ),
            );
        },
        builder: (context, state) {
          final cubit = context.read<BranchesCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(state: state, onSortByNearest: cubit.sortByNearest),
              _SearchBar(
                controller: _searchController,
                onChanged: cubit.search,
              ),
              Expanded(child: _buildBody(context, state, cubit)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    BranchesState state,
    BranchesCubit cubit,
  ) {
    if (state.status == BranchesStatus.loading && state.allBranches.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBlue),
      );
    }

    if (state.status == BranchesStatus.error && state.allBranches.isEmpty) {
      return _ErrorRetry(
        message: state.errorMessage ?? 'تعذر جلب الفروع',
        onRetry: cubit.fetchBranches,
      );
    }

    if (state.visibleBranches.isEmpty) {
      return _EmptyBranches(hasQuery: state.searchQuery.trim().isNotEmpty);
    }

    return RefreshIndicator(
      color: AppColors.primaryBlue,
      onRefresh: cubit.fetchBranches,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
        itemCount: state.visibleBranches.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final branch = state.visibleBranches[index];
          return BranchCard(
            branch: branch,
            distanceKm: branch.distanceKmFrom(state.userLat, state.userLng),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BranchDetailsView(
                  branch: branch,
                  distanceKm: branch.distanceKmFrom(
                    state.userLat,
                    state.userLng,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final BranchesState state;
  final Future<void> Function() onSortByNearest;

  const _Header({required this.state, required this.onSortByNearest});

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
                  'فروعنا',
                  style: TextStyles.Size24
                      .withColor(AppColors.surfaceWhite)
                      .withWeight(FontWeight.bold),
                ),
              ),
              Icon(
                Icons.storefront_rounded,
                color: AppColors.cyanAccent,
                size: 26.r,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  state.visibleBranches.isEmpty
                      ? 'اعثر على أقرب فرع إليك'
                      : '${state.visibleBranches.length} فرع متاح',
                  style: TextStyles.Size15.withColor(AppColors.cyanAccent),
                ),
              ),
              InkWell(
                onTap: state.isLocating ? null : onSortByNearest,
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.surfaceWhite.withOpacity(0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.isLocating)
                        SizedBox(
                          width: 13.r,
                          height: 13.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.surfaceWhite,
                          ),
                        )
                      else
                        Icon(
                          state.hasUserLocation
                              ? Icons.near_me_rounded
                              : Icons.near_me_outlined,
                          color: AppColors.surfaceWhite,
                          size: 15.r,
                        ),
                      SizedBox(width: 6.w),
                      Text(
                        state.hasUserLocation ? 'الأقرب إليك' : 'رتّب بالأقرب',
                        style: TextStyles.Size10
                            .withColor(AppColors.surfaceWhite)
                            .withWeight(FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
        decoration: InputDecoration(
          hintText: 'ابحث باسم الفرع أو المدينة',
          hintStyle: TextStyles.Size15.withColor(AppColors.coolGrey),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.coolGrey,
            size: 20.r,
          ),
          filled: true,
          fillColor: AppColors.surfaceWhite,
          contentPadding: EdgeInsets.symmetric(vertical: 4.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(color: AppColors.borderGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(color: AppColors.borderGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(color: AppColors.primaryBlue),
          ),
        ),
      ),
    );
  }
}

class _EmptyBranches extends StatelessWidget {
  final bool hasQuery;

  const _EmptyBranches({required this.hasQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84.w,
              height: 84.h,
              decoration: const BoxDecoration(
                color: AppColors.lightBlueSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasQuery ? Icons.search_off_rounded : Icons.storefront_outlined,
                size: 38.r,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              hasQuery ? 'لا يوجد فرع مطابق' : 'لا توجد فروع متاحة حالياً',
              style: TextStyles.Size18
                  .withColor(AppColors.darkBlueBlack)
                  .withWeight(FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              hasQuery
                  ? 'جرّب اسماً أو مدينة أخرى'
                  : 'سنضيف فروعاً جديدة قريباً',
              textAlign: TextAlign.center,
              style: TextStyles.Size15.withColor(AppColors.coolGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

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
