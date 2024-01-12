import 'dart:convert';
import 'package:find_evcs/models/review.dart';
import 'package:find_evcs/repositories/api_constant.dart';
import 'package:http/http.dart' as http;

class ReviewRepository {
  Future<List<Review>> getReviewsByStationId(int stationId) async {
    final response =
        await http.get(Uri.parse('${APIConstant.GET_REVIEW_URL}$stationId'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => Review.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<bool> storeReview(Review review) async {
    final response = await http.post(
      Uri.parse('${APIConstant.STORE_REVIEW_URL}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'rating': review.rating,
        'description': review.description,
        'guest_name': review.guestName,
        'station_id': review.stationId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}
