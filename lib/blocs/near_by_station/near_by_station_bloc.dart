import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_evcs/models/station.dart';
import 'package:find_evcs/repositories/station_repository.dart';

part 'near_by_station_event.dart';
part 'near_by_station_state.dart';

class NearByStationBloc extends Bloc<NearByStationEvent, NearByStationState> {
  final StationRepository repo;

  NearByStationBloc(NearByStationState NearByStationInitial, this.repo) : super(NearByStationInitial) {
    on<GetStationsEvent>((event, emit) async {
      emit(NearByStationLoading());
      try {
        var stations = await repo.getNearByStations(event.lat, event.long);

        if (stations.isNotEmpty) {
          emit(NearByStationLoaded(stations));
        } else {
          emit(NearByStationError('There is no stations.'));
        }
      } catch (error) {
        emit(NearByStationError(error.toString()));
      }
    });
  }
}
