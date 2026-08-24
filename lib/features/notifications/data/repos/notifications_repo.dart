import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import '../models/notification_model.dart';

class NotificationsRepo {
  final ApiService _apiService;

  NotificationsRepo(this._apiService);

  /// 1. جلب قائمة الإشعارات (GET /api/notifications)
  /// ملاحظة: `data` مصفوفة مسطّحة، وبيانات الترقيم في مفتاح `pagination` منفصل
  Future<NotificationsPage> getNotifications({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
  }) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.notifications,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (unreadOnly) 'unread': 1,
      },
    );

    final json = _asMap(response.data);
    _throwIfFailed(json, 'فشل في جلب الإشعارات');

    final rawList = json['data'];
    final items = rawList is List
        ? rawList
              .whereType<Map>()
              .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
        : <NotificationModel>[];

    final rawPagination = json['pagination'];
    final pagination = rawPagination is Map
        ? NotificationsPagination.fromJson(Map<String, dynamic>.from(rawPagination))
        : NotificationsPagination(
            currentPage: page,
            perPage: perPage,
            total: items.length,
            lastPage: page,
          );

    return NotificationsPage(items: items, pagination: pagination);
  }

  /// 2. عدد الإشعارات غير المقروءة للشارة (GET /api/notifications/unread-count)
  Future<int> getUnreadCount() async {
    final response = await _apiService.get(
      endpoint: ApiConstants.unreadNotificationsCount,
    );

    final json = _asMap(response.data);
    _throwIfFailed(json, 'فشل في جلب عدد الإشعارات');

    final data = json['data'];
    if (data is Map) {
      final count = data['unread_count'];
      if (count is num) return count.toInt();
      if (count is String) return int.tryParse(count) ?? 0;
    }
    return 0;
  }

  /// 3. تفاصيل إشعار واحد (GET /api/notifications/{id})
  Future<NotificationModel> getNotification(int id) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.showNotification(id),
    );

    final json = _asMap(response.data);
    _throwIfFailed(json, 'فشل في جلب الإشعار');

    final data = json['data'];
    if (data is Map) {
      return NotificationModel.fromJson(Map<String, dynamic>.from(data));
    }
    throw 'فشل في جلب الإشعار';
  }

  /// 4. تعليم إشعار كمقروء (POST /api/notifications/{id}/read)
  /// العملية idempotent — إعادة تنفيذها على إشعار مقروء لا تغيّر شيئاً
  Future<NotificationModel?> markAsRead(int id) async {
    final response = await _apiService.post(
      endpoint: ApiConstants.readNotification(id),
    );

    final json = _asMap(response.data);
    _throwIfFailed(json, 'فشل في تعليم الإشعار كمقروء');

    final data = json['data'];
    if (data is Map) {
      return NotificationModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  /// 5. تعليم كل الإشعارات كمقروءة (POST /api/notifications/read-all)
  /// الاستجابة تُرجع `data: []` فارغة — لا تقرأ منها شيئاً
  Future<void> markAllAsRead() async {
    final response = await _apiService.post(
      endpoint: ApiConstants.readAllNotifications,
    );

    _throwIfFailed(_asMap(response.data), 'فشل في تعليم الإشعارات كمقروءة');
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    return const {};
  }

  /// المغلّف يرجع `status: 1` عند النجاح و `status: 0` عند الفشل
  void _throwIfFailed(Map<String, dynamic> json, String fallbackMessage) {
    if (json.isEmpty) throw fallbackMessage;
    if (json['status'] == 0 || json['status'] == '0') {
      final message = json['message'];
      throw (message is String && message.isNotEmpty) ? message : fallbackMessage;
    }
  }
}
