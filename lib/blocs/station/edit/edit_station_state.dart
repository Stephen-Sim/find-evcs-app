part of 'edit_station_bloc.dart';

sealed class EditStationState extends Equatable {
  const EditStationState();
  
  @override
  List<Object> get props => [];
}

final class EditStationInitial extends EditStationState {}

class EditStationLoaded extends EditStationState {
  final Station station;

  const EditStationLoaded({required this.station}); 
}

class EditStaionLoading extends EditStationState {}

class EditStaionSuccess extends EditStationState {}

class DeleteStaionSuccess extends EditStationState {}

class EditStaionFailure extends EditStationState {
  final String error;

  const EditStaionFailure(this.error);

  @override
  List<Object> get props => [error];
}

