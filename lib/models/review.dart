class Review{
  final int? id;
  final int rating;
  final String description;
  final String guestName;
  final int stationId;

  const Review({this.id, required this.rating, required this.description, required this.guestName, required this.stationId});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      rating: json['rating'] as int,
      description: json['description'] as String,
      guestName: json['guest_name'] as String,
      stationId: json['station_id'] as int,
    );
  }
}