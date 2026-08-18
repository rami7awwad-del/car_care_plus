import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../data/models/branch_model.dart';
import '../data/repos/branches_repo.dart';
import 'branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  final BranchesRepo _repo;

  BranchesCubit(this._repo) : super(const BranchesState());

  void _safeEmit(BranchesState state) {
    if (!isClosed) emit(state);
  }

  /// القائمة صغيرة ولا يوجد بحث من السيرفر، فنجلبها كاملة بصفحة واحدة
  Future<void> fetchBranches() async {
    _safeEmit(state.copyWith(status: BranchesStatus.loading, clearError: true));
    try {
      final response = await _repo.getBranches(perPage: 50);
      final branches = response.data;

      _safeEmit(
        state.copyWith(
          status: BranchesStatus.success,
          allBranches: branches,
          visibleBranches: _applyFilters(
            branches,
            state.searchQuery,
            state.userLat,
            state.userLng,
          ),
          clearError: true,
        ),
      );
    } catch (error) {
      _safeEmit(
        state.copyWith(
          status: BranchesStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void search(String query) {
    _safeEmit(
      state.copyWith(
        searchQuery: query,
        visibleBranches: _applyFilters(
          state.allBranches,
          query,
          state.userLat,
          state.userLng,
        ),
      ),
    );
  }

  /// ترتيب الفروع حسب الأقرب. لا نطلب إذن الموقع عند فتح الشاشة،
  /// بل عند ضغط المستخدم على الزر فقط.
  Future<void> sortByNearest() async {
    if (state.isLocating) return;
    _safeEmit(state.copyWith(isLocating: true, clearError: true));

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _safeEmit(
          state.copyWith(
            isLocating: false,
            errorMessage: 'خدمة الموقع الجغرافي معطلة على الجهاز',
          ),
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _safeEmit(
          state.copyWith(
            isLocating: false,
            errorMessage: 'نحتاج إذن الموقع لترتيب الفروع حسب الأقرب إليك',
          ),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _safeEmit(
        state.copyWith(
          isLocating: false,
          userLat: position.latitude,
          userLng: position.longitude,
          visibleBranches: _applyFilters(
            state.allBranches,
            state.searchQuery,
            position.latitude,
            position.longitude,
          ),
          clearError: true,
        ),
      );
    } catch (error) {
      _safeEmit(
        state.copyWith(
          isLocating: false,
          errorMessage: 'تعذر تحديد موقعك، حاول مرة أخرى',
        ),
      );
    }
  }

  /// التصفية والبحث والترتيب كلها محلية — الباك اند لا يوفّر أياً منها.
  List<BranchModel> _applyFilters(
    List<BranchModel> branches,
    String query,
    double? userLat,
    double? userLng,
  ) {
    // الفروع غير الفعّالة تُرفض عند الحجز، فلا نعرضها للزبون أصلاً
    var result = branches.where((branch) => branch.isActive).toList();

    final normalized = query.trim().toLowerCase();
    if (normalized.isNotEmpty) {
      result = result.where((branch) {
        return branch.displayName.toLowerCase().contains(normalized) ||
            branch.name.toLowerCase().contains(normalized) ||
            branch.nameAr.toLowerCase().contains(normalized) ||
            branch.city.toLowerCase().contains(normalized) ||
            branch.address.toLowerCase().contains(normalized);
      }).toList();
    }

    if (userLat != null && userLng != null) {
      // الفروع بلا إحداثيات تبقى في النهاية بدل أن تُحذف
      result.sort((a, b) {
        final distanceA = a.distanceKmFrom(userLat, userLng);
        final distanceB = b.distanceKmFrom(userLat, userLng);
        if (distanceA == null && distanceB == null) return 0;
        if (distanceA == null) return 1;
        if (distanceB == null) return -1;
        return distanceA.compareTo(distanceB);
      });
    }

    return result;
  }
}
