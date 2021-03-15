import 'dart:convert';

import 'package:http/http.dart' as http;

class CustomHttpRequest {
  static const String uri = "https://apihomechef.masudlearn.com"; //common api

  static const Map<String, String> defaultHeader = {
    "Accept": "application/json",
  };

  static Future<dynamic> getItems() async {
    try {
      var response = await http.get(
        "$uri/api/category",
      );
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
      return {"error": "Something Wrong Exception"};
    }
  }

  static Future<dynamic> getBurger() async {
    try {
      var response = await http.get("$uri/api/category/1/products/",headers: defaultHeader);
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
      return {"error": "Something Wrong Exception"};
    }
  }

  static Future<dynamic> getSubCategory(int id) async {
    try {
      var response = await http.get(
        "$uri/api/category/$id/products/",
        headers:  defaultHeader,
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200)
        return data;
      else
        return "error";
    } catch (e) {
      print(e);
      return "User details data not found";
    }
  }
}
