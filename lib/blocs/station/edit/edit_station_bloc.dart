import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_evcs/models/station.dart';
import 'package:find_evcs/repositories/station_repository.dart';

part 'edit_station_event.dart';
part 'edit_station_state.dart';

class EditStationBloc extends Bloc<EditStationEvent, EditStationState> {
  final StationRepository repo;

  EditStationBloc(EditStationState CreateStationInitial, this.repo)
      : super(CreateStationInitial) {
    on<GetStationEvent>((event, emit) async {
      emit(EditStaionLoading());

      Station station = await this.repo.getStationById(event.id);
      emit(EditStationLoaded(station: station));
    });

    on<DeleteButtonPressed>((event, emit) async {
      emit(EditStaionLoading());

      bool success = await this.repo.deleteStation(event.id);
      if (success) {
        emit(DeleteStaionSuccess());
      } else {
        emit(EditStaionFailure('Delete Station failed'));
      }
    });

    on<EditStationButtonPressed>((event, emit) async {
      emit(EditStaionLoading());

      if (event.name == null ||
          event.address == null ||
          event.totalChargingStations == null ||
          event.image == null) {
        emit(EditStaionFailure('All fields are required!'));
        return;
      }

      try {
        var station = Station(
            id: event.id,
            name: event.name!,
            address: event.address!,
            totalChargingStations: event.totalChargingStations!,
            image: event.image!,
            latitude: event.latitude!,
            longitude: event.longitude!);
        final bool success = await repo.editStation(station);
        if (success) {
          emit(EditStaionSuccess());
        } else {
          emit(EditStaionFailure('Edit Station failed'));
        }
      } catch (error) {
        emit(EditStaionFailure(error.toString()));
      }
    });
  }
}
