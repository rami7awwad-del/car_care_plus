import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:car_care_plus/Localization/l10n/app_localization.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/core/helper/locale_controller.dart';
import 'package:car_care_plus/core/networking/dio_factory.dart';
import 'package:car_care_plus/core/routing/app_routes.dart';

import 'package:car_care_plus/features/auth/data/auth_remote_data_source.dart';
import 'package:car_care_plus/features/auth/data/auth_repository_impl.dart';
import 'package:car_care_plus/features/auth/presentation/cubit/auth_cubit.dart';

import 'package:car_care_plus/features/cars/data/repos/cars_repo.dart';
import 'package:car_care_plus/features/cars/logic/cars_cubit.dart';

import 'package:car_care_plus/features/points/data/repos/points_repo.dart';
import 'package:car_care_plus/features/points/logic/points_cubit.dart';

// 👈 1. استيراد كلاسات الباقات المضافة حديثاً
import 'package:car_care_plus/features/packages/data/repos/packages_repo.dart';
import 'package:car_care_plus/features/packages/logic/packages_cubit.dart';

// 👈 استيراد كلاسات المساعد الذكي
import 'package:car_care_plus/features/ai_chat/data/repos/ai_chat_repo.dart';
import 'package:car_care_plus/features/ai_chat/logic/ai_chat_cubit.dart';

// 👈 استيراد كلاسات الإشعارات
import 'package:car_care_plus/features/notifications/data/repos/notifications_repo.dart';
import 'package:car_care_plus/features/notifications/logic/notifications_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// لغة الواجهة — يتحكّم بها زر تبديل اللغة في القائمة الجانبية
  late final LocaleController _localeController;

  late final AppRouter _appRouter;
  late final AuthRepositoryImpl _authRepository;
  late final CarsRepo _carsRepo;
  late final PointsRepo _pointsRepo;
  late final PackagesRepo _packagesRepo; // 👈 2. تعريف متغيّر PackagesRepo
  late final NotificationsRepo _notificationsRepo;
  late final AiChatRepo _aiChatRepo;
  late final ApiService _apiService;

  @override
  void initState() {
    super.initState();

    // 1️⃣ تهيئة Dio والـ ApiService
    final dio = DioFactory.getDio();
    _apiService = ApiService();

    // 2️⃣ تهيئة الطبقات الخاصة بـ Auth و Cars و Points و Packages
    final authRemoteDataSource = AuthRemoteDataSourceImpl(dio: dio);
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
    );
    _carsRepo = CarsRepo(_apiService);
    _pointsRepo = PointsRepo(_apiService);
    _packagesRepo = PackagesRepo(_apiService); // 👈 3. إنشاء كائن PackagesRepo
    _notificationsRepo = NotificationsRepo(_apiService);
    _aiChatRepo = AiChatRepo(_apiService);

    // 3️⃣ استعادة اللغة المحفوظة من الجلسة السابقة (تبدأ بالعربية ريثما تصل)
    _localeController = LocaleController()..loadSavedLocale();

    // 4️⃣ تهيئة الـ AppRouter
    _appRouter = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            // توفير ApiService لكل صفحات التطبيق والـ Router
            Provider<ApiService>.value(value: _apiService),

            // 👈 متحكّم اللغة: يقرأه زر التبديل في القائمة الجانبية
            ChangeNotifierProvider<LocaleController>.value(
              value: _localeController,
            ),

            // توفير الـ Cubits
            BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(authRepository: _authRepository),
            ),
            BlocProvider<CarsCubit>(
              create: (context) => CarsCubit(_carsRepo)..getUserCars(),
            ),
            BlocProvider<PointsCubit>(
              create: (context) => PointsCubit(_pointsRepo),
            ),
            
            // 👈 4. إضافة PackagesCubit ليصبح متاحاً للـ BottomNavigationBar والصفحات بالكامل
            BlocProvider<PackagesCubit>(
              create: (context) => PackagesCubit(_packagesRepo),
            ),

            // 👈 5. الإشعارات على مستوى التطبيق: شارة العدد في الهيدر
            // والقائمة في شاشة الإشعارات تشتركان في نفس الـ Cubit
            BlocProvider<NotificationsCubit>(
              create: (context) => NotificationsCubit(_notificationsRepo),
            ),

            // 👈 6. المساعد الذكي على مستوى التطبيق: السيرفر لا يحفظ أي جلسة
            // للمحادثة، فنحن من يحمل سجل الأسئلة والأجوبة — وتوفير الـ Cubit
            // هنا يمنع ضياعه عند مغادرة شاشة المحادثة والعودة إليها
            BlocProvider<AiChatCubit>(
              create: (context) => AiChatCubit(_aiChatRepo),
            ),
          ],
          // تغيير اللغة يعيد بناء الـ MaterialApp وحده، فيقلب الاتجاه
          // بين RTL و LTR ويُحدّث كل النصوص المترجمة
          child: Consumer<LocaleController>(
            builder: (context, localeController, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: localeController.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              initialRoute: Routes.login,
              onGenerateRoute: _appRouter.generateRoute,
            ),
          ),
        );
      },
    );
  }
}