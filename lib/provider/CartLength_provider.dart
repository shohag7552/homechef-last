import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:home_chef/model/cartItems.dart';
import 'package:home_chef/server/http_request.dart';


/*class CartModel extends ChangeNotifier{

  // Internal, private state of the cart.
  final List<CartItem> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  /// The current total price of all items (assuming all items cost $42).
  int get totalPrice => _items.length * 42;
  int get cartLength => _items.length;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(CartItem item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}*/

class CartLengthProvider with ChangeNotifier{
  List<CartItem> cartList = [];
  fetchLength(context) async {
    cartList = await CustomHttpRequest.getCartLength(context);
    print(cartList.length.toString());
    notifyListeners();
  }
}