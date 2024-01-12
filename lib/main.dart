import 'package:find_evcs/blocs/admin/login/login_state.dart';
import 'package:find_evcs/blocs/near_by_station/near_by_station_bloc.dart';
import 'package:find_evcs/blocs/review_station/review_station_bloc.dart';
import 'package:find_evcs/blocs/station/create/create_station_bloc.dart';
import 'package:find_evcs/blocs/station/edit/edit_station_bloc.dart';
import 'package:find_evcs/blocs/station/list/list_station_bloc.dart';
import 'package:find_evcs/blocs/station/list/list_station_state.dart';
import 'package:find_evcs/pages/login_page.dart';
import 'package:find_evcs/repositories/admin_repository.dart';
import 'package:find_evcs/repositories/review_repository.dart';
import 'package:find_evcs/repositories/station_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:find_evcs/blocs/admin/login/login_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(LoginInitial(), AdminRepository()),
        ),
        BlocProvider<ListStationBloc>(
          create: (context) => ListStationBloc(ListStationInitial(), StationRepository()),
        ),
        BlocProvider<CreateStationBloc>(
          create: (context) => CreateStationBloc(CreateStationInitial(), StationRepository()),
        ),
        BlocProvider<EditStationBloc>(
          create: (context) => EditStationBloc(EditStationInitial(), StationRepository()),
        ),
        BlocProvider<NearByStationBloc>(
          create: (context) => NearByStationBloc(NearByStationInitial(), StationRepository()),
        ),
        BlocProvider<ReviewStationBloc>(
          create: (context) => ReviewStationBloc(ReviewStationInitial(), ReviewRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Find EVCS',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
