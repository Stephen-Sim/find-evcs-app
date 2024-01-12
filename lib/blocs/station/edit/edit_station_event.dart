part of 'edit_station_bloc.dart';

sealed class EditStationEvent extends Equatable {
  const EditStationEvent();

  @override
  List<Object> get props => [];
}

class GetStationEvent extends EditStationEvent {
  final int id;

  const GetStationEvent({required this.id});
}

class EditStationButtonPressed extends EditStationEvent {
  final int id;
  final String? name;
  final String? address;
  final int? totalChargingStations;
  final String? image;
  final double? latitude;
  final double? longitude;

  const EditStationButtonPressed({
    required this.id,
    this.name,
    this.address,
    this.totalChargingStations,
    this.image,
    this.latitude,
    this.longitude,
  });
}

class DeleteButtonPressed extends EditStationEvent {
  final int id;

  const DeleteButtonPressed({
    required this.id
  });
}