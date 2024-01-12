import 'package:find_evcs/models/station.dart';

abstract class ListStationState {}

class ListStationInitial extends ListStationState {}

class ListStationLoading extends ListStationState {}

class ListStationLoaded extends ListStationState {
  final List<Station> stations;

  ListStationLoaded(this.stations); 
}

class ListStationError extends ListStationState {
  final String message;

  ListStationError(this.message);
}
