import '../data/models/rating_model.dart';

abstract class RatingState {}

class RatingInitialState extends RatingState {}

// حالات جلب قائمة تقييماتي
class RatingsLoadingState extends RatingState {}

class RatingsSuccessState extends RatingState {
  final List<RatingModel> ratings;
  RatingsSuccessState(this.ratings);
}

class RatingsErrorState extends RatingState {
  final String message;
  RatingsErrorState(this.message);
}

// حالات إرسال/تعديل تقييم
class SubmitRatingLoadingState extends RatingState {}

class SubmitRatingSuccessState extends RatingState {
  final RatingModel rating;
  SubmitRatingSuccessState(this.rating);
}

class SubmitRatingErrorState extends RatingState {
  final String message;
  SubmitRatingErrorState(this.message);
}
