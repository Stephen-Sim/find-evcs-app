import 'package:find_evcs/blocs/station/list/list_station_bloc.dart';
import 'package:find_evcs/blocs/station/list/list_station_event.dart';
import 'package:find_evcs/blocs/station/list/list_station_state.dart';
import 'package:find_evcs/pages/login_page.dart';
import 'package:find_evcs/pages/station/create_station_page.dart';
import 'package:find_evcs/pages/station/edit_station_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListStationPage extends StatefulWidget {
  const ListStationPage({super.key});

  @override
  State<ListStationPage> createState() => _ListStationPageState();
}

class _ListStationPageState extends State<ListStationPage> {
  @override
  void initState() {
    super.initState();
    context.read<ListStationBloc>().add(GetStationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EV Station Management'),
        backgroundColor: Color.fromARGB(255, 168, 144, 238),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Color.fromARGB(255, 49, 45, 45),
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('adminId');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          )
        ],
      ),
      backgroundColor: Color.fromRGBO(203, 195, 227, 1),
      body: BlocBuilder<ListStationBloc, ListStationState>(
        builder: (context, state) {
          if (state is ListStationLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ListStationLoaded) {
            return ListView.builder(
              itemCount: state.stations.length,
              itemBuilder: (context, index) {
                final station = state.stations[index];
                return Card(
                  color: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.electric_car, color: Colors.purple),
                    title: Text(
                      "${station.name.length > 20 ? station.name.substring(0, 17) + '...' : station.name} (${station.avgRating!.toStringAsFixed(2)}⭐)",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${station.address.length > 60 ? station.address.substring(0, 57) + '...' : station.address}",
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.purple),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditStationPage(
                                    id: station.id!,
                                  )),
                        ).then((value) {
                          if (value != null) {
                            context
                                .read<ListStationBloc>()
                                .add(GetStationsEvent());

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Station is ${value == "edit" ? "edited" : "deleted"}.")),
                            );
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is ListStationError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('error'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateStationPage()),
          ).then((value) {
            if (value == true) {
              context.read<ListStationBloc>().add(GetStationsEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Station is added")),
              );
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
