import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/notification_model.dart';
import '../data/repos/notifications_repo.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo _repo;

  NotificationsCubit(this._repo) : super(const NotificationsState());

  static const int _perPage = 20;

  /// لا يوجد Push ولا WebSocket في الباك اند حالياً، لذلك نعتمد على استطلاع
  /// خفيف لعدد غير المقروء طالما التطبيق في المقدمة فقط
  static const Duration _pollInterval = Duration(seconds: 45);

  Timer? _pollTimer;
  bool _isFetching = false;

  // ==================== شارة عدد الإشعارات غير المقروءة ====================

  Future<void> refreshUnreadCount() async {
    try {
      final count = await _repo.getUnreadCount();
      if (isClosed) return;
      emit(state.copyWith(unreadCount: count));
    } catch (_) {
      // الشارة ليست حرجة — نتجاهل فشلها حتى لا نزعج المستخدم برسائل خطأ
    }
  }

  /// تُستدعى عند فتح التطبيق أو عودته من الخلفية
  void startBadgePolling() {
    refreshUnreadCount();
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) => refreshUnreadCount());
  }

  /// تُستدعى عند ذهاب التطبيق للخلفية
  void stopBadgePolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  // ==================== القائمة ====================

  Future<void> fetchNotifications() async {
    if (_isFetching) return;
    _isFetching = true;

    emit(state.copyWith(status: NotificationsStatus.loading, clearError: true));
    try {
      final page = await _repo.getNotifications(
        perPage: _perPage,
        unreadOnly: state.unreadOnly,
      );
      if (isClosed) return;
      emit(
        state.copyWith(
          status: NotificationsStatus.success,
          items: page.items,
          pagination: page.pagination,
          isLoadingMore: false,
          clearError: true,
        ),
      );
      // نحدّث الشارة مع كل تحميل للقائمة حتى تبقى متطابقة مع الخادم
      await refreshUnreadCount();
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: NotificationsStatus.error,
          errorMessage: error.toString(),
        ),
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<void> loadMore() async {
    final pagination = state.pagination;
    if (_isFetching || state.isLoadingMore || pagination == null) return;
    if (!pagination.hasNextPage) return;

    _isFetching = true;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final page = await _repo.getNotifications(
        page: pagination.currentPage + 1,
        perPage: _perPage,
        unreadOnly: state.unreadOnly,
      );
      if (isClosed) return;

      // الخادم قد يعيد صفوفاً مكررة إذا تغيّرت النتائج بين الصفحات،
      // لذلك ندمج بالاعتماد على الـ id
      final existingIds = state.items.map((e) => e.id).toSet();
      final merged = [
        ...state.items,
        ...page.items.where((e) => !existingIds.contains(e.id)),
      ];

      emit(
        state.copyWith(
          items: merged,
          pagination: page.pagination,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(state.copyWith(isLoadingMore: false, errorMessage: error.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> toggleUnreadOnly(bool unreadOnly) async {
    if (state.unreadOnly == unreadOnly) return;
    emit(
      state.copyWith(
        unreadOnly: unreadOnly,
        items: const [],
        clearPagination: true,
      ),
    );
    await fetchNotifications();
  }

  // ==================== تعليم كمقروء ====================

  /// تحديث تفاؤلي: نعلّم محلياً أولاً ثم نرسل للخادم، وإن فشل نتراجع.
  /// ملاحظة: لا نحذف العنصر من قائمة "غير المقروءة" بعد قراءته حتى لا
  /// تتغيّر نتائج الخادم بين طلبات الصفحات فتُفقد صفوف أثناء التمرير.
  Future<void> markAsRead(NotificationModel notification) async {
    if (notification.isRead) return;

    final previousItems = state.items;
    final previousCount = state.unreadCount;

    emit(
      state.copyWith(
        items: _replace(
          previousItems,
          notification.copyWith(isRead: true, readAt: DateTime.now()),
        ),
        unreadCount: previousCount > 0 ? previousCount - 1 : 0,
        clearError: true,
      ),
    );

    try {
      final updated = await _repo.markAsRead(notification.id);
      if (isClosed || updated == null) return;
      emit(state.copyWith(items: _replace(state.items, updated)));
    } catch (error) {
      if (isClosed) return;
      // تراجع عن التحديث التفاؤلي ثم أعد مزامنة العدّاد مع الخادم
      emit(
        state.copyWith(
          items: previousItems,
          unreadCount: previousCount,
          errorMessage: error.toString(),
        ),
      );
      await refreshUnreadCount();
    }
  }

  Future<void> markAllAsRead() async {
    if (state.unreadCount == 0 && state.items.every((e) => e.isRead)) return;

    final previousItems = state.items;
    final previousCount = state.unreadCount;
    final now = DateTime.now();

    emit(
      state.copyWith(
        items: previousItems
            .map((e) => e.isRead ? e : e.copyWith(isRead: true, readAt: now))
            .toList(),
        unreadCount: 0,
        clearError: true,
      ),
    );

    try {
      await _repo.markAllAsRead();
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          items: previousItems,
          unreadCount: previousCount,
          errorMessage: error.toString(),
        ),
      );
      await refreshUnreadCount();
    }
  }

  /// تُستدعى عند تسجيل الخروج لتفريغ الشارة والقائمة المخزّنة
  void clear() {
    stopBadgePolling();
    emit(const NotificationsState());
  }

  List<NotificationModel> _replace(
    List<NotificationModel> items,
    NotificationModel updated,
  ) {
    return items.map((e) => e.id == updated.id ? updated : e).toList();
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }
}
