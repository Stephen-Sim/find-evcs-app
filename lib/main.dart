import 'package:find_evcs/blocs/admin/login/login_state.dart';
import 'package:find_evcs/blocs/near_by_station/near_by_station_bloc.dart';
import 'package:find_evcs/blocs/review_station/review_station_bloc.dart';
import 'package:find_evcs/blocs/station/create/create_station_bloc.dart';
import 'package:find_evcs/blocs/station/edit/edit_station_bloc.dart';
import 'package:find_evcs/blocs/station/list/list_station_bloc.dart';
import 'package:find_evcs/blocs/station/list/list_station_state.dart';
import 'package:find_evcs/pages/login_page.dart';
import 'package:find_evcs/pages/station/list_station_page.dart';
import 'package:find_evcs/repositories/admin_repository.dart';
import 'package:find_evcs/repositories/review_repository.dart';
import 'package:find_evcs/repositories/station_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:find_evcs/blocs/admin/login/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var adminId = prefs.getInt('adminId');

  runApp(MyApp(home: (adminId == null ? const LoginPage() : const ListStationPage())));
}

class MyApp extends StatelessWidget {
  final Widget home;
  MyApp({required this.home});

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
        home: this.home,
      ),
    );
  }
}
