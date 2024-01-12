import 'dart:convert';
import 'package:find_evcs/models/station.dart';
import 'package:find_evcs/repositories/api_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StationRepository {
  Future<List<Station>> getStations() async {
    final response =
        await http.get(Uri.parse('${APIConstant.GET_STATION_URL}'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => Station.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load stations');
    }
  }

  Future<bool> storeStation(Station station) async {
    var pref = await SharedPreferences.getInstance();
    int? adminId = pref.getInt("adminId");
    final response = await http.post(
      Uri.parse('${APIConstant.STORE_STATION_URL}'),
      body:json.encode({
        "name": station.name,
        "address": station.address,
        "total_charging_stations": station.totalChargingStations,
        "image": station.image,
        "latitude": station.latitude,
        "longitude": station.longitude,
        "admin_id": adminId!,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }

  Future<bool> editStation(Station station) async {
    final response = await http.post(
      Uri.parse('${APIConstant.EDIT_STATION_URL}/${station.id}'),
      body: json.encode({
        "name": station.name,
        "address": station.address,
        "total_charging_stations": station.totalChargingStations,
        "image": station.image,
        "latitude": station.latitude,
        "longitude": station.longitude,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }

  Future<Station> getStationById(int id) async {
    final response =
        await http.get(Uri.parse('${APIConstant.GET_STATION_URL}$id'));

    if (response.statusCode == 200) {
      return Station.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load station');
    }
  }

  Future<bool> deleteStation(int id) async {
    final response =
        await http.delete(Uri.parse('${APIConstant.DELETE_STATION_URL}$id'));

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }

  Future<List<Station>> getNearByStations(
      double currentLatitude, double currentLongitude) async {
    final response = await http
        .get(Uri.parse('${APIConstant.GET_NEAR_BY_STATION_URL}?current_latitude=${currentLatitude}&current_longitude=${currentLongitude}'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => Station.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load nearby stations');
    }
  }
}
