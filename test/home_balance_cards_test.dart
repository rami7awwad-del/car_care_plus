import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/features/home/ui/widgets/home_balance_cards.dart';
import 'package:car_care_plus/features/points/data/models/points_response_model.dart';
import 'package:car_care_plus/features/points/data/repos/points_repo.dart';
import 'package:car_care_plus/features/points/logic/points_cubit.dart';
import 'package:car_care_plus/features/points/logic/points_state.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/models/wallet_response_model.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/repos/wallet_payment_repo.dart';
import 'package:car_care_plus/features/wallet_and_payments/logic/wallet_payment_cubit.dart';
import 'package:car_care_plus/features/wallet_and_payments/logic/wallet_payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// نسخ تُثبَّت على حالة محدّدة دون أي نداء شبكة
class _StubWalletCubit extends WalletPaymentCubit {
  _StubWalletCubit(WalletPaymentState initial)
      : super(WalletPaymentRepo(ApiService())) {
    emit(initial);
  }
}

class _StubPointsCubit extends PointsCubit {
  _StubPointsCubit(PointsState initial) : super(PointsRepo(ApiService())) {
    emit(initial);
  }
}

WalletData _wallet(String balance) =>
    WalletData(id: 1, userId: 1, balance: balance);

Future<void> _pumpCards(
  WidgetTester tester, {
  required Size viewport,
  required WalletPaymentState walletState,
  required PointsState pointsState,
}) async {
  tester.view.physicalSize = viewport;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: viewport.width > viewport.height
          ? const Size(812, 375)
          : const Size(375, 812),
      minTextAdapt: true,
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider<WalletPaymentCubit>(
            create: (_) => _StubWalletCubit(walletState),
          ),
          BlocProvider<PointsCubit>(
            create: (_) => _StubPointsCubit(pointsState),
          ),
        ],
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: const HomeBalanceCards(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('تعرض الرصيد والنقاط بعد نجاح الجلب', (tester) async {
    await _pumpCards(
      tester,
      viewport: const Size(375, 812),
      walletState: WalletPaymentSuccessState(
        wallet: _wallet('12.5'),
        transactions: const [],
      ),
      pointsState: PointsSuccessState(PointsData(id: 1, balance: 340)),
    );

    // الرصيد النصّي القادم من الباك اند يُعرض دائماً برقمين عشريين
    expect(find.text('12.50'), findsOneWidget);
    expect(find.text('د.أ'), findsOneWidget);
    expect(find.text('340'), findsOneWidget);
    expect(find.text('نقطة'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('تعرض مؤشر تحميل أثناء الجلب', (tester) async {
    await _pumpCards(
      tester,
      viewport: const Size(375, 812),
      walletState: WalletPaymentLoadingState(),
      pointsState: PointsLoadingState(),
    );

    expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('تعرض شرطة بدل رقم مضلّل عند فشل الجلب', (tester) async {
    await _pumpCards(
      tester,
      viewport: const Size(375, 812),
      walletState: WalletPaymentErrorState('فشل الاتصال'),
      pointsState: PointsErrorState('فشل الاتصال'),
    );

    expect(find.text('—'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('لا تتجاوز حدودها مع رصيد ونقاط كبيرة في الوضعين',
      (tester) async {
    for (final viewport in const [Size(320, 640), Size(812, 375)]) {
      await _pumpCards(
        tester,
        viewport: viewport,
        walletState: WalletPaymentSuccessState(
          wallet: _wallet('1234567.89'),
          transactions: const [],
        ),
        pointsState: PointsSuccessState(PointsData(id: 1, balance: 9999999)),
      );

      expect(tester.takeException(), isNull, reason: 'عند المقاس $viewport');
    }
  });
}
