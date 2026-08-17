import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/workshops_repo.dart';
import 'workshops_state.dart';

class WorkshopsCubit extends Cubit<WorkshopsState> {
  final WorkshopsRepo _workshopsRepo;

  WorkshopsCubit(this._workshopsRepo) : super(WorkshopsInitialState());

  Future<void> getNearbyWorkshops({
    required double latitude,
    required double longitude,
  }) async {
    emit(WorkshopsLoadingState());
    try {
      final workshops = await _workshopsRepo.getNearbyWorkshops(
        latitude: latitude,
        longitude: longitude,
      );
      emit(WorkshopsSuccessState(workshops));
    } catch (error) {
      emit(WorkshopsErrorState(error.toString()));
    }
  }
}
