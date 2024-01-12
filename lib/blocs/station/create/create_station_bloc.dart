import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_evcs/models/station.dart';
import 'package:find_evcs/repositories/station_repository.dart';

part 'create_station_event.dart';
part 'create_station_state.dart';

class CreateStationBloc extends Bloc<CreateStationEvent, CreateStationState> {
  final StationRepository repo;

  CreateStationBloc(CreateStationState CreateStationInitial, this.repo)
      : super(CreateStationInitial) {
    on<CreateStationButtonPressed>((event, emit) async {
      emit(CreateStaionLoading());

      if (event.name == null ||
          event.address == null ||
          event.totalChargingStations == null ||
          event.image == null) {
        emit(CreateStaionFailure('All fields are required!'));
        return;
      }

      try {
        var station = Station(
            name: event.name!,
            address: event.address!,
            totalChargingStations: event.totalChargingStations!,
            image: event.image!,
            latitude: event.latitude!,
            longitude: event.longitude!);
        final bool success = await repo.storeStation(station);
        if (success) {
          emit(CreateStaionSuccess());
        } else {
          emit(CreateStaionFailure('Create Station failed'));
        }
      } catch (error) {
        emit(CreateStaionFailure(error.toString()));
      }
    });
  }
}
