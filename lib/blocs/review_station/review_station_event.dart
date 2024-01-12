part of 'review_station_bloc.dart';

sealed class ReviewStationEvent extends Equatable {
  const ReviewStationEvent();

  @override
  List<Object> get props => [];
}

class GetReviewsEvent extends ReviewStationEvent {
  final int stationId;
  const GetReviewsEvent({required this.stationId});
}

class CreateReviewButtonPressed extends ReviewStationEvent {
  final int? rating;
  final String? description;
  final String? guestName;
  final int stationId;

  const CreateReviewButtonPressed({
    this.rating,
    this.description,
    this.guestName,
    required this.stationId,
  });
}

