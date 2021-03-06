import 'dart:convert';

import 'package:home_chef/model/cartItems.dart';
import 'package:home_chef/model/categories.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomHttpRequest {
  static const String uri = "https://apihomechef.antapp.space"; //common api


  static const Map<String, String> defaultHeader = {
    "Accept": "application/json",
  };
  static SharedPreferences sharedPreferences;

  static Future<Map<String, String>> getHeaderWithToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Accept": "application/json",
      "Authorization": "bearer ${sharedPreferences.getString("token")}",
    };
    print("user token is :${sharedPreferences.getString('token')}");
    return header;
  }

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

  //provider...
  static Future<dynamic> getCategories(context) async{
    Categories categories;
    List<Categories> categoryList = [];
    try{


      String url = "$uri/api/category";
      Uri myUri = Uri.parse(url);
      http.Response response = await http.get(
          myUri,headers: await getHeaderWithToken()
      );
      print("Categories status :  ${response.statusCode}");

      final item = json.decode(response.body);
      print("Categories :  $item");
      if(response.statusCode == 200){

        final item = json.decode(response.body);
        print(item);
        for(var i in item){
          categories = Categories.fromJson(i);
          categoryList.add(categories);
        }


      }
      else{
        print('Data not found');
      }
    } catch(e){
      print(e);
    }
    return categoryList;
  }

  static Future<dynamic> SearchItems() async {
    try {
      var response = await http.get(
        "$uri/api/products",
      );
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
      return {"error": "Something Wrong Exception"};
    }
  }

  static Future<dynamic> getProfile() async {
    try {
      var response = await http.get(
        "$uri/api/user/profile",headers: await getHeaderWithToken()
      );
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
      return {"error": "Something Wrong Exception"};
    }
  }

  static Future<dynamic> getShippingAddress(int id) async {
    try {
      var response = await http.get(
        "$uri/api/order/shipping/address/$id",headers: await getHeaderWithToken()
      );
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
      return {"error": "Something Wrong Exception"};
    }
  }

 static Future<dynamic> getCartItems()async{
   List<CartItem> items = [];
   try {
     var response = await http.get(
       "$uri/api/view/cart",headers: await getHeaderWithToken(),
     );
     final data = jsonDecode(response.body);
     return data;
   } catch (e) {
     print(e);
     return {"error": "Something Wrong Exception"};
   }
 }
  //provider...
  static Future<dynamic> getCartLength(context) async{
    CartItem cartItem;
    List<CartItem> cartList = [];
    try{
      String url = "$uri/api/view/cart";
      Uri myUri = Uri.parse(url);
      http.Response response = await http.get(
          myUri,headers: await getHeaderWithToken()
      );
      print(" cart status${response.statusCode}");
      if(response.statusCode == 200){

        final item = json.decode(response.body);
        print(item);
        for(var i in item){
          cartItem = CartItem.fromJson(i);
          cartList.add(cartItem);
          print(cartList.length);
        }

      }
      else{
        print('Data not found');
      }
    } catch(e){
      print(e);
    }
    return cartList;
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
  static Future<dynamic> getSummaryItems(int id) async {
    try {
      var response = await http.get(
        "$uri/api/user/order/$id/summary",
        headers: await getHeaderWithToken() ,
      );
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200)
        return data;
      else
        return "error";
    } catch (e) {
      print(e);
      return "User details data not found";
    }
  } static Future<dynamic> searchItenDetails(int id) async {
    try {
      var response = await http.get(
        "$uri/api/product/$id/view",
        headers: defaultHeader ,
      );
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200)
        return data;
      else
        return "error";
    } catch (e) {
      print(e);
      return "User details data not found";
    }
  }
  static Future<dynamic> deleteItem(int id)async{
    try{
      var response = await http.delete(
        "$uri/api/cart/$id/delete",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);

      if(response.statusCode==200){
        print(data);
        print("delete sucessfully");
        return response;
      }
      else{
        throw Exception("Cant delete ");
      }
    }catch(e){
      print(e);
    }
  }

  static Future<String> login(String email, String password) async {
    try {
      String url = "$uri/api/sign-in";
      var map = Map<String, dynamic>();
      map['email'] = email;
      map['password'] = password;
      final response = await http.post(url, body: map, headers: defaultHeader);
      print(response.body);
      if (response.statusCode == 200) {
        return response.body;
      }
      print(response.body);
      return "Something Wrong";
    } catch (e) {
      return e.toString();
    }
  }
}
