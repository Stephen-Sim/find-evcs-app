import 'dart:convert';
import 'package:find_evcs/repositories/api_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminRepository {

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${APIConstant.ADMIN_LOGIN_URL}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var result = int.parse(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('adminId', result);
      return true;
    } 

    return false;
  }
}
