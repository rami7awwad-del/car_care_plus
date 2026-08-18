import '../data/models/notification_model.dart';

enum NotificationsStatus { initial, loading, success, error }

/// حالة واحدة تجمع القائمة وشارة العدد معاً، لأن الشارة والقائمة يشتركان
/// في نفس الـ Cubit حتى لا يتعارض العدّاد بين الواجهات
class NotificationsState {
  final NotificationsStatus status;
  final List<NotificationModel> items;
  final NotificationsPagination? pagination;
  final bool isLoadingMore;
  final bool unreadOnly;
  final int unreadCount;
  final String? errorMessage;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.items = const [],
    this.pagination,
    this.isLoadingMore = false,
    this.unreadOnly = false,
    this.unreadCount = 0,
    this.errorMessage,
  });

  bool get hasMore => pagination?.hasNextPage ?? false;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationModel>? items,
    NotificationsPagination? pagination,
    bool? isLoadingMore,
    bool? unreadOnly,
    int? unreadCount,
    String? errorMessage,
    bool clearError = false,
    bool clearPagination = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      items: items ?? this.items,
      pagination: clearPagination ? null : (pagination ?? this.pagination),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      unreadOnly: unreadOnly ?? this.unreadOnly,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
