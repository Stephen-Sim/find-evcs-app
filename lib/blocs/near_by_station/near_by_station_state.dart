part of 'near_by_station_bloc.dart';

sealed class NearByStationState extends Equatable {
  const NearByStationState();
  
  @override
  List<Object> get props => [];
}

class NearByStationInitial extends NearByStationState {}

class NearByStationLoading extends NearByStationState {}

class NearByStationLoaded extends NearByStationState {
  final List<Station> stations;

  NearByStationLoaded(this.stations); 
}

class NearByStationError extends NearByStationState {
  final String message;

  NearByStationError(this.message);
}
