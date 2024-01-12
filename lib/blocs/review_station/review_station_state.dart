part of 'review_station_bloc.dart';

sealed class ReviewStationState extends Equatable {
  const ReviewStationState();
  
  @override
  List<Object> get props => [];
}

final class ReviewStationInitial extends ReviewStationState {}

class ReviewStationLoading extends ReviewStationState {}

class ReviewStationLoaded extends ReviewStationState {
  final List<Review> reviews;

  ReviewStationLoaded(this.reviews); 
}

class ReviewStaionIsNull extends ReviewStationState {
  final String error;

  const ReviewStaionIsNull(this.error);

  @override
  List<Object> get props => [error];
}

class ReviewStaionSuccess extends ReviewStationState {}

class ReviewStaionFailure extends ReviewStationState {
  final String error;

  const ReviewStaionFailure(this.error);

  @override
  List<Object> get props => [error];
}
