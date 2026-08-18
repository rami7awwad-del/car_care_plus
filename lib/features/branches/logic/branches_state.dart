import '../data/models/branch_model.dart';

enum BranchesStatus { initial, loading, success, error }

class BranchesState {
  final BranchesStatus status;

  /// كل الفروع كما وصلت من السيرفر (تشمل غير الفعّالة)
  final List<BranchModel> allBranches;

  /// الفروع بعد التصفية والبحث والترتيب — هذه التي تُعرض
  final List<BranchModel> visibleBranches;

  final String searchQuery;

  /// موقع المستخدم إن سمح به، لترتيب الفروع حسب الأقرب
  final double? userLat;
  final double? userLng;

  final bool isLocating;
  final String? errorMessage;

  const BranchesState({
    this.status = BranchesStatus.initial,
    this.allBranches = const [],
    this.visibleBranches = const [],
    this.searchQuery = '',
    this.userLat,
    this.userLng,
    this.isLocating = false,
    this.errorMessage,
  });

  bool get hasUserLocation => userLat != null && userLng != null;

  /// عدد الفروع المستبعدة لأنها غير فعّالة
  int get hiddenInactiveCount =>
      allBranches.where((branch) => !branch.isActive).length;

  BranchesState copyWith({
    BranchesStatus? status,
    List<BranchModel>? allBranches,
    List<BranchModel>? visibleBranches,
    String? searchQuery,
    double? userLat,
    double? userLng,
    bool? isLocating,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BranchesState(
      status: status ?? this.status,
      allBranches: allBranches ?? this.allBranches,
      visibleBranches: visibleBranches ?? this.visibleBranches,
      searchQuery: searchQuery ?? this.searchQuery,
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
      isLocating: isLocating ?? this.isLocating,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
