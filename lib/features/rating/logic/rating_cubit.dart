import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/rating_model.dart';
import '../data/repos/rating_repo.dart';
import 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final RatingRepo _ratingRepo;

  RatingCubit(this._ratingRepo) : super(RatingInitialState());

  List<RatingModel> ratings = [];

  /// جلب تقييماتي
  Future<void> getMyRatings() async {
    emit(RatingsLoadingState());
    try {
      ratings = await _ratingRepo.getMyRatings();
      emit(RatingsSuccessState(ratings));
    } catch (error) {
      emit(RatingsErrorState(error.toString()));
    }
  }

  /// إنشاء تقييم لطلب مكتمل
  Future<void> createRating({
    required int orderId,
    required int serviceRating,
    int? employeeRating,
    int? workshopRating,
    String? comment,
    List<String>? imageUrls,
  }) async {
    emit(SubmitRatingLoadingState());
    try {
      final rating = await _ratingRepo.createRating({
        'order_id': orderId,
        'service_rating': serviceRating,
        if (employeeRating != null) 'employee_rating': employeeRating,
        if (workshopRating != null) 'workshop_rating': workshopRating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
        if (imageUrls != null && imageUrls.isNotEmpty) 'image_urls': imageUrls,
      });
      emit(SubmitRatingSuccessState(rating));
    } catch (error) {
      emit(SubmitRatingErrorState(error.toString()));
    }
  }

  /// تعديل تقييم (الحقول المتغيّرة فقط)
  Future<void> updateRating({
    required int id,
    int? serviceRating,
    int? employeeRating,
    int? workshopRating,
    String? comment,
    List<String>? imageUrls,
  }) async {
    emit(SubmitRatingLoadingState());
    try {
      final rating = await _ratingRepo.updateRating(
        id: id,
        ratingData: {
          if (serviceRating != null) 'service_rating': serviceRating,
          if (employeeRating != null) 'employee_rating': employeeRating,
          if (workshopRating != null) 'workshop_rating': workshopRating,
          if (comment != null) 'comment': comment,
          if (imageUrls != null) 'image_urls': imageUrls,
        },
      );
      emit(SubmitRatingSuccessState(rating));
    } catch (error) {
      emit(SubmitRatingErrorState(error.toString()));
    }
  }
}
