import 'package:find_evcs/blocs/station/list/list_station_event.dart';
import 'package:find_evcs/blocs/station/list/list_station_state.dart';
import 'package:find_evcs/repositories/station_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListStationBloc extends Bloc<ListStationEvent, ListStationState> {
  final StationRepository repo;

  ListStationBloc(ListStationState ListStationInitial, this.repo) : super(ListStationInitial) {
    on<GetStationsEvent>((event, emit) async {
      emit(ListStationLoading());
      try {
        var stations = await repo.getStations();

        if (stations.isNotEmpty) {
          emit(ListStationLoaded(stations));
        } else {
          emit(ListStationError('There is no stations.'));
        }
      } catch (error) {
        emit(ListStationError(error.toString()));
      }
    });
  }
}
