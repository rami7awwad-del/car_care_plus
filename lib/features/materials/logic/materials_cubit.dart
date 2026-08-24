import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/material_model.dart';
import '../data/repos/materials_repo.dart';

abstract class MaterialsState {}
class MaterialsInitialState extends MaterialsState {}
class MaterialsLoadingState extends MaterialsState {}
class MaterialsSuccessState extends MaterialsState {
  final List<MaterialModel> materials;
  MaterialsSuccessState(this.materials);
}
class MaterialsErrorState extends MaterialsState {
  final String message;
  MaterialsErrorState(this.message);
}

class MaterialsCubit extends Cubit<MaterialsState> {
  final MaterialsRepo _materialsRepo;
  MaterialsCubit(this._materialsRepo) : super(MaterialsInitialState());

  List<MaterialModel> materials = [];

  Future<void> fetchMaterials() async {
    emit(MaterialsLoadingState());
    try {
      materials = await _materialsRepo.getMaterials();
      emit(MaterialsSuccessState(materials));
    } catch (e) {
      emit(MaterialsErrorState(e.toString()));
    }
  }
}