part of 'near_by_station_bloc.dart';

sealed class NearByStationEvent extends Equatable {
  const NearByStationEvent();

  @override
  List<Object> get props => [];
}

class GetStationsEvent extends NearByStationEvent {
  final double lat;
  final double long;

  const GetStationsEvent({required this.lat, required this.long});
}
