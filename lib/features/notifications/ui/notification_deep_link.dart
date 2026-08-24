import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/features/orders/logic/order_cubit.dart';
import 'package:car_care_plus/features/orders/presentation/orders_page.dart';
import 'package:car_care_plus/features/wallet_and_payments/ui/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/notification_model.dart';

/// يحوّل `reference_type` + `reference_id` إلى الشاشة المناسبة داخل التطبيق.
///
/// قائمة الأنواع مفتوحة من جهة الباك اند — أي نوع جديد أو غير مدعوم يعيد
/// `null` ونبقى في شاشة الإشعارات بدل إظهار خطأ.
class NotificationDeepLink {
  const NotificationDeepLink._();

  static bool canOpen(NotificationModel notification) =>
      _builderFor(notification) != null;

  static Future<void> open(
    BuildContext context,
    NotificationModel notification,
  ) async {
    final builder = _builderFor(notification);
    if (builder == null) return;

    await Navigator.push(context, MaterialPageRoute(builder: builder));
  }

  static WidgetBuilder? _builderFor(NotificationModel notification) {
    if (!notification.hasReference) return null;

    switch (notification.referenceType) {
      case NotificationReferenceTypes.order:
        return (context) => BlocProvider(
          create: (_) => OrderCubit(ApiService())..fetchUserOrders(),
          child: const OrdersPage(),
        );

      // لا توجد شاشة تفاصيل دفع مفعّلة حالياً، لذلك نفتح المحفظة التي تعرض
      // سجل المدفوعات
      case NotificationReferenceTypes.payment:
      case NotificationReferenceTypes.wallet:
        return (context) => const WalletScreen();

      // rating / points / inventory / purchase_request / spare_part_request
      // وأي نوع جديد: لا توجد شاشة مخصصة في تطبيق العميل، فنبقى في مكاننا
      default:
        return null;
    }
  }
}
