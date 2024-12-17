import 'dart:convert';

import 'package:chatapp/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiService {
  static Future<Response> getRequest(
      {required String endPoint, Map<String, String>? headers}) async {
    try {
      String url = AppConfig.baseUrl + endPoint;
      var response = await http.get(Uri.parse(url), headers: headers ?? {});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        print(response.body);
        throw Exception('Failed to load ');
      }
    } catch (e) {
      throw Exception('Failed to load $e');
    }
  }

  static Future<Response> postRequest(
      {required String endPoint,
      Map<String, String>? headers,
      Map<String, dynamic>? body}) async {
    try {
      String url = AppConfig.baseUrl + endPoint;
      var response = await http.post(Uri.parse(url),
          headers: headers ?? {}, body: jsonEncode(body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        print(response.body);
        throw Exception('Failed to update');
      }
    } catch (e) {
      throw Exception('Failed to update $e');
    }
  }
}

getHeaders() async {
  //local storage
}
