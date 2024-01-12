class Station {
  final int? id;
  final String name;
  final String address;
  final int totalChargingStations;
  final String image;
  final double latitude;
  final double longitude;
  final int? adminId;

  final String? username;
  final double? avgRating;

  Station({
    this.id,
    required this.name,
    required this.address,
    required this.totalChargingStations,
    required this.image,
    required this.latitude,
    required this.longitude,
    this.adminId,
    this.username,
    this.avgRating,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      totalChargingStations: json['total_charging_stations'] as int,
      image: json['image'] as String,
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      adminId: json['admin_id'] as int,
      username: json['username'] as String,
      avgRating: double.parse(json['avg_rating']),
    );
  }
}
