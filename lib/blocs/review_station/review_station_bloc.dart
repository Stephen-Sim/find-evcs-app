import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_evcs/models/review.dart';
import 'package:find_evcs/repositories/review_repository.dart';

part 'review_station_event.dart';
part 'review_station_state.dart';

class ReviewStationBloc extends Bloc<ReviewStationEvent, ReviewStationState> {
  final ReviewRepository repo;

  ReviewStationBloc(ReviewStationState ReviewStationInitial, this.repo) : super(ReviewStationInitial) {
    on<GetReviewsEvent>((event, emit) async {
      emit(ReviewStationLoading());
      try {
        var reviews = await repo.getReviewsByStationId(event.stationId);

        if (reviews.isNotEmpty) {
          emit(ReviewStationLoaded(reviews));
        } else {
          emit(ReviewStaionIsNull('There is no reviews.'));
        }
      } catch (error) {
        emit(ReviewStaionFailure(error.toString()));
      }
    });

    on<CreateReviewButtonPressed>((event, emit) async {
      emit(ReviewStationLoading());

      if (event.description!.isEmpty || event.guestName!.isEmpty)
      {
        emit(ReviewStaionFailure("All fields are required!"));
        return;
      }

      try {
        var review = Review(rating: event.rating!, description: event.description!, guestName: event.guestName!, stationId: event.stationId);
        final bool success = await repo.storeReview(review);

        if (success) {
          emit(ReviewStaionSuccess());
        } else {
          emit(ReviewStaionFailure('failed to store.'));
        }
      } catch (error) {
        emit(ReviewStaionFailure(error.toString()));
      }
    });
  }
}
