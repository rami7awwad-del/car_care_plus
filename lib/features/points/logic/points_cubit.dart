import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/points_repo.dart';
import 'points_state.dart';

class PointsCubit extends Cubit<PointsState> {
  final PointsRepo _pointsRepo;

  PointsCubit(this._pointsRepo) : super(PointsInitialState());

  Future<void> fetchUserPoints() async {
    emit(PointsLoadingState());
    try {
      final response = await _pointsRepo.getUserPoints();
      if (response.status == 1 && response.data != null) {
        emit(PointsSuccessState(response.data!));
      } else {
        emit(PointsErrorState(response.message ?? 'فشل في جلب رصيد النقاط'));
      }
    } catch (error) {
      // ApiErrorHandler يرمي String مباشرة عند الفشل
      emit(PointsErrorState(error.toString()));
    }
  }
}