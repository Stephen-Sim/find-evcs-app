import 'dart:convert';

import 'package:find_evcs/blocs/near_by_station/near_by_station_bloc.dart';
import 'package:find_evcs/models/station.dart';
import 'package:find_evcs/pages/search_station/review_station_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/src/core.dart';

class NearByStationPage extends StatefulWidget {
  const NearByStationPage({Key? key}) : super(key: key);

  @override
  State<NearByStationPage> createState() => _NearByStationPageState();
}

class _NearByStationPageState extends State<NearByStationPage> {
  static CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(0.0, 0.0), zoom: 14);
  final String gApiKey = "AIzaSyCB7cpPFXRdOFprDVVtsOts8SM5zHRaulQ";
  Set<Marker> markerList = {};
  late double? userLat;
  late double? userLng;
  late String? userAddress = "";
  final Mode _mode = Mode.overlay;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  late Set<Circle> circle = {};

  late Position position;

  late List<Station> _nearbystations;

  Station? station;

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _updateMarkerPosition(LatLng latLng) async {
    final chargerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(6, 6)),
      'assets/imgs/charger.png',
    );

    markerList.clear();
    markerList.add(
      Marker(
          markerId: const MarkerId('currentLocation'),
          position: latLng,
          icon: chargerIcon),
    );
    _getAddressFromLatLng(latLng);
    setState(() {});
  }

  Future<void> _setInitialLocation() async {
    try {
      this.position = await determinePosition();
      initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14,
      );

      circle = Set.from([
        Circle(
          circleId: CircleId("current_position"),
          center: LatLng(position.latitude, position.longitude),
          radius: 80,
          fillColor: Color.fromARGB(255, 168, 144, 238),
          strokeColor: Colors.purple,
          strokeWidth: 3,
        )
      ]);

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
          ),
        ),
      );
      _updateMarkerPosition(LatLng(position.latitude, position.longitude));
      context.read<NearByStationBloc>().add(
          GetStationsEvent(lat: position.latitude, long: position.longitude));
      setState(() {});
    } catch (e) {
      print('Error setting initial location: $e');
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placeMark = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    Placemark place = placeMark.isNotEmpty ? placeMark.first : Placemark();

    List<String> addressParts = [];
    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.postalCode != null && place.postalCode!.isNotEmpty) {
      addressParts.add(place.postalCode!);
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }
    if (place.country != null && place.country!.isNotEmpty) {
      addressParts.add(place.country!);
    }

    userAddress = addressParts.join(', ');
    userLat = latLng.latitude;
    userLng = latLng.longitude;
  }

  Future<void> _handlePressedButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: gApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
          hintText: "Search",
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
        ),
        components: [Component(Component.country, "my")]);

    if (p != null) {
      displayPrediction(p!, homeScaffoldKey.currentState);
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    print("display prediction");
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: gApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = userLat = detail.result.geometry!.location.lat;
    final lng = userLng = detail.result.geometry!.location.lng;
    userAddress = "${detail.result.name!} ${detail.result.formattedAddress!}";

    final chargerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(6, 6)),
      'assets/imgs/charger.png',
    );

    markerList.clear();
    //  put new marker
    markerList.add(Marker(
      markerId: const MarkerId("0"),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: detail.result.name),
      icon: chargerIcon,
    ));

    setState(() {});
    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 20.0));
  }

  void _onMarkerTapped(Station station) {
    setState(() {
      this.station = station;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby EV Stations'),
        backgroundColor: Color.fromARGB(255, 168, 144, 238),
      ),
      backgroundColor: Color.fromRGBO(203, 195, 227, 1),
      body: BlocListener<NearByStationBloc, NearByStationState>(
        listener: (context, state) async {
          if (state is NearByStationLoaded) {
            _nearbystations = state.stations;

            final chargerIcon = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(6, 6)),
              'assets/imgs/charger.png',
            );

            final Set<Marker> nearbyMarkers = _nearbystations.map((station) {
              return Marker(
                  markerId: MarkerId(station.id.toString()),
                  position: LatLng(station.latitude!, station.longitude!),
                  icon: chargerIcon,
                  onTap: () {
                    _onMarkerTapped(station);
                  });
            }).toSet();

            markers.addAll(nearbyMarkers);

            setState(() {
              if (_nearbystations.isNotEmpty) {
                station = _nearbystations[0];
              }
            });
          }

          if (state is NearByStationError) {}
        },
        child: BlocBuilder<NearByStationBloc, NearByStationState>(
          builder: (context, state) {
            return Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 1.7,
                  child: GoogleMap(
                    initialCameraPosition: initialCameraPosition,
                    markers: markers,
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    onTap: (LatLng latLng) {
                      // Handle map tap event and update marker position
                      _updateMarkerPosition(latLng);
                    },
                    onMapCreated: (GoogleMapController controller) {
                      googleMapController = controller;
                    },
                    circles: circle,
                  ),
                ),
                Expanded(
                  child: station != null
                      ? Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.memory(
                                        base64Decode(station!.image),
                                        height: 120,
                                        width: 120,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${station!.name.length > 20 ? station!.name.substring(0, 17) + '...' : station!.name} (${station!.avgRating!.toStringAsFixed(2)}⭐)",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 60,
                                        width: 200,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReviewStationPage(
                                                            station: station!,
                                                          ))).then((value) {
                                                if (value != null) {
                                                  _setInitialLocation();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "review is added!")),
                                                  );
                                                }
                                              });
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                              )),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Color.fromARGB(
                                                          255, 168, 144, 238)),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Text(
                                                'Review',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Card(
                          child: Center(
                          child: Text("No Data Yet."),
                        )),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
