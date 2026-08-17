import '../data/models/workshop_model.dart';

abstract class WorkshopsState {}

class WorkshopsInitialState extends WorkshopsState {}

class WorkshopsLoadingState extends WorkshopsState {}

class WorkshopsSuccessState extends WorkshopsState {
  final List<WorkshopModel> workshops;
  WorkshopsSuccessState(this.workshops);
}

class WorkshopsErrorState extends WorkshopsState {
  final String message;
  WorkshopsErrorState(this.message);
}
