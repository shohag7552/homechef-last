import 'package:flutter/cupertino.dart';
import 'package:home_chef/model/cartItems.dart';
import 'package:home_chef/server/http_request.dart';

class CartLengthProvider with ChangeNotifier{
  List<CartItem> items = [];
  Future<dynamic> fetchLength() async {
    final data = await CustomHttpRequest.getCartItems();
    print("||fetchCategoryData $data");
    CartItem cartItem;
    for (var item in data) {
      try {
        cartItem = CartItem.fromJson(item);
        items.firstWhere((element) => element.id == cartItem.id);
        if(items.length == null){
          print('empty');
        }
      } catch (e) {
        items.add(cartItem);
      }
    }
    notifyListeners();
  }




}