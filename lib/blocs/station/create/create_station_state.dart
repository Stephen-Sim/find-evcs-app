part of 'create_station_bloc.dart';

sealed class CreateStationState extends Equatable {
  const CreateStationState();
  
  @override
  List<Object> get props => [];
}

final class CreateStationInitial extends CreateStationState {}

class CreateStaionLoading extends CreateStationState {}

class CreateStaionSuccess extends CreateStationState {}

class CreateStaionFailure extends CreateStationState {
  final String error;

  const CreateStaionFailure(this.error);

  @override
  List<Object> get props => [error];
}
