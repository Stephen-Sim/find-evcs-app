import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/src/core.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static CameraPosition initialCameraPosition = CameraPosition(target: LatLng(0.0, 0.0), zoom: 14);
  final String gApiKey = "AIzaSyCB7cpPFXRdOFprDVVtsOts8SM5zHRaulQ";
  Set<Marker> markerList = {};
  late double? userLat;
  late double? userLng;
  late String? userAddress = "";
  final Mode _mode = Mode.overlay;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController googleMapController;

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
  }

  Future<void> _setInitialLocation() async {
    try {
      Position position = await determinePosition();
      initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14,
      );

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
          ),
        ),
      );

      _updateMarkerPosition(LatLng(position.latitude, position.longitude));
      setState(() {});
    } catch (e) {
      print('Error setting initial location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title:
            Text("Pick address", style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: Color.fromARGB(255, 168, 144, 238),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markerList,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
            onTap: (LatLng latLng) {
              _updateMarkerPosition(latLng);
            },
          ),
          Container(
              margin: const EdgeInsets.all(13.0),
              child: TextFormField(
                readOnly: true,
                onTap: _handlePressedButton,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    suffixIconColor: Color.fromARGB(255, 168, 144, 238),
                    fillColor: Colors.white,
                    hintText: "Type address here...",
                    filled: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 168, 144, 238)),
                    )),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (userAddress!.isEmpty == true) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Please pick a location",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ));
            return;
          }
          Navigator.pop(context,
              {'lat': userLat, 'lng': userLng, 'address': userAddress});
        },
        tooltip: "Current Location",
        child: Icon(Icons.add_location, color: Colors.black),
        backgroundColor: Color.fromARGB(255, 168, 144, 238),
      ),
    );
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
        icon: chargerIcon
      ),
    );
    _getAddressFromLatLng(latLng);
    setState(() {});
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

    markerList.clear();

    final chargerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(6, 6)),
      'assets/imgs/charger.png',
    );

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
}
