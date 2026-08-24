import '../data/models/points_response_model.dart';

abstract class PointsState {}

class PointsInitialState extends PointsState {}

class PointsLoadingState extends PointsState {}

class PointsSuccessState extends PointsState {
  final PointsData pointsData;
  PointsSuccessState(this.pointsData);
}

class PointsErrorState extends PointsState {
  final String message;
  PointsErrorState(this.message);
}