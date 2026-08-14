import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:car_care_plus/Localization/l10n/app_localization.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar'); // اللغة الافتراضية

  late final AppRouter _appRouter;
  late final AuthRepositoryImpl _authRepository;
  late final CarsRepo _carsRepo;
  late final PointsRepo _pointsRepo;
  late final PackagesRepo _packagesRepo; // 👈 2. تعريف متغيّر PackagesRepo
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

    // 3️⃣ تهيئة الـ AppRouter
    _appRouter = AppRouter(
      onLanguageChanged: (newLocale) {
        setState(() {
          _locale = newLocale;
        });
      },
    );
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
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: _locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: Routes.login,
            onGenerateRoute: _appRouter.generateRoute,
          ),
        );
      },
    );
  }
}