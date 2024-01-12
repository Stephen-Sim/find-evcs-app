part of 'create_station_bloc.dart';

sealed class CreateStationEvent extends Equatable {
  const CreateStationEvent();

  @override
  List<Object> get props => [];
}

class CreateStationButtonPressed extends CreateStationEvent {
  final String? name;
  final String? address;
  final int? totalChargingStations;
  final String? image;
  final double? latitude;
  final double? longitude;

  const CreateStationButtonPressed({
    this.name,
    this.address,
    this.totalChargingStations,
    this.image,
    this.latitude,
    this.longitude,
  });
}
