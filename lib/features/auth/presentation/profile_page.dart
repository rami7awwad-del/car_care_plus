import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/routing/app_routes.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:car_care_plus/features/auth/data/user_model.dart';
import 'package:car_care_plus/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:car_care_plus/features/auth/presentation/cubit/auth_state.dart';
import 'package:car_care_plus/features/orders/presentation/orders_page.dart';
import 'package:car_care_plus/features/points/logic/points_cubit.dart';
import 'package:car_care_plus/features/points/logic/points_state.dart';
import 'package:car_care_plus/features/wallet_and_payments/ui/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // جلب بيانات البروفايل والنقاط عند التنزيل
    context.read<AuthCubit>().fetchProfile();
    context.read<PointsCubit>().fetchUserPoints();
  }

  // دالة إظهار نافذة تأكيد تسجيل الخروج
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت تأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().logout();
            },
            child: const Text('خروج', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // دالة إظهار نافذة التعديل السفلية
  void _showEditProfileBottomSheet(BuildContext context, UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 24.h,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تعديل الملف الشخصي',
                    style: TextStyles.Size18
                        .withColor(AppColors.darkBlueBlack)
                        .withWeight(FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 24.r),
                    onPressed: () => Navigator.pop(bottomSheetContext),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم الكامل',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  prefixIcon: const Icon(Icons.phone_android),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(bottomSheetContext);
                    context.read<AuthCubit>().updateProfile(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: phoneController.text.trim(),
                        );
                  },
                  child: Text(
                    'حفظ التعديلات',
                    style: TextStyles.Size15.withColor(AppColors.surfaceWhite),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueSurface,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: AppColors.errorColor,
              ),
            );
          } else if (state is AuthInitial) {
            // توجيه المستخدم لشاشة تسجيل الدخول ومسح السجل السابق عند النجاح
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }

          if (state is AuthFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage,
                    style: TextStyles.Size15.withColor(AppColors.errorColor),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () => context.read<AuthCubit>().fetchProfile(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is AuthSuccess) {
            final user = state.user;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GradientHeader(
                  padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.edit, color: AppColors.surfaceWhite, size: 24.r),
                          onPressed: () => _showEditProfileBottomSheet(context, user),
                        ),
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 46.r,
                            backgroundColor: AppColors.surfaceWhite.withOpacity(0.15),
                            child: Text(
                            user.name.isNotEmpty
                                ? user.name.characters.first.toUpperCase()
                                  : 'U',
                              style: TextStyles.Size32
                                  .withColor(AppColors.surfaceWhite)
                                  .withWeight(FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        user.name,
                        style: TextStyles.Size24
                            .withColor(AppColors.surfaceWhite)
                            .withWeight(FontWeight.bold),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        user.email,
                        style: TextStyles.Size15.withColor(
                          AppColors.surfaceWhite.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _WalletCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WalletScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 14.h),
                        const _PointsCard(),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'معلومات الحساب',
                              style: TextStyles.Size18
                                  .withColor(AppColors.darkBlueBlack)
                                  .withWeight(FontWeight.bold),
                            ),
                            TextButton.icon(
                              onPressed: () => _showEditProfileBottomSheet(context, user),
                              icon: Icon(Icons.edit_outlined, size: 18.r),
                              label: const Text('تعديل'),
                            )
                          ],
                        ),
                        SizedBox(height: 10.h),
                        _InfoTile(
                          icon: Icons.phone_android_rounded,
                          label: 'رقم الهاتف',
                          value: user.phone,
                        ),
                        SizedBox(height: 12.h),
                        _InfoTile(
                          icon: Icons.email_outlined,
                          label: 'البريد الإلكتروني',
                          value: user.email,
                        ),
                        SizedBox(height: 12.h),

                        // مدخل الطلبات والتقييمات
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OrdersPage(),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(18.r),
                          child: Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceWhite,
                              borderRadius: BorderRadius.circular(18.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.darkBlueBlack.withOpacity(0.05),
                                  blurRadius: 14.r,
                                  offset: Offset(0, 5.h),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 46.w,
                                  height: 46.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightBlueSurface,
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Icon(
                                    Icons.receipt_long_rounded,
                                    color: AppColors.primaryBlue,
                                    size: 24.r,
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Text(
                                  'الطلبات والتقييمات',
                                  style: TextStyles.Size15
                                      .withColor(AppColors.darkBlueBlack)
                                      .withWeight(FontWeight.w600),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16.r,
                                  color: AppColors.coolGrey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // زر تسجيل الخروج
                        InkWell(
                          onTap: () => _showLogoutDialog(context),
                          borderRadius: BorderRadius.circular(18.r),
                          child: Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(color: Colors.red.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 46.w,
                                  height: 46.h,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Icon(Icons.logout_rounded, color: Colors.red, size: 24.r),
                                ),
                                SizedBox(width: 14.w),
                                Text(
                                  'تسجيل الخروج',
                                  style: TextStyles.Size15
                                      .withColor(Colors.red)
                                      .withWeight(FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 28.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  final VoidCallback onTap;

  const _WalletCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          gradient: AppColors.darkCardGradient,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBlueBlack.withOpacity(0.2),
              blurRadius: 16.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                gradient: AppColors.cyanGlowGradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: AppColors.surfaceWhite,
                size: 26.r,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المحفظة والمدفوعات',
                    style: TextStyles.Size18
                        .withColor(AppColors.surfaceWhite)
                        .withWeight(FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'عرض الرصيد الحالي وسجل المدفوعات',
                    style: TextStyles.Size10.withColor(
                      AppColors.coolGrey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.cyanAccent,
              size: 18.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _PointsCard extends StatelessWidget {
  const _PointsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF232526), Color(0xFF414345)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.15),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.amber, Colors.orangeAccent],
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.stars_rounded,
              color: AppColors.surfaceWhite,
              size: 28.r,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نقاط المكافآت',
                  style: TextStyles.Size18
                      .withColor(AppColors.surfaceWhite)
                      .withWeight(FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  'استبدل نقاطك بخصومات على الحجوزات',
                  style: TextStyles.Size10.withColor(
                    AppColors.coolGrey,
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<PointsCubit, PointsState>(
            builder: (context, state) {
              if (state is PointsLoadingState) {
                return SizedBox(
                  width: 18.w,
                  height: 18.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.amber,
                  ),
                );
              }

              int balance = 0;
              if (state is PointsSuccessState) {
                balance = state.pointsData.balance ?? 0;
              }

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.amber.withOpacity(0.4)),
                ),
                child: Text(
                  '$balance نقطة',
                  style: TextStyles.Size10
                      .withColor(Colors.amber)
                      .withWeight(FontWeight.bold),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
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
            color: AppColors.darkBlueBlack.withOpacity(0.05),
            blurRadius: 14.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.h,
            decoration: BoxDecoration(
              color: AppColors.lightBlueSurface,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 24.r),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyles.Size10.withColor(AppColors.coolGrey),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyles.Size15
                    .withColor(AppColors.darkBlueBlack)
                    .withWeight(FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}