// To parse this JSON data, do
//
//     final cartItems = cartItemsFromJson(jsonString);
//
// import 'dart:convert';
//
// List<CartItems> cartItemsFromJson(String str) => List<CartItems>.from(json.decode(str).map((x) => CartItems.fromJson(x)));
//
// String cartItemsToJson(List<CartItems> data) => json.encode(
//     List<dynamic>.from(data.map((x) => x.toJson())));

class CartItem {
  CartItem({
    this.id,
    this.quantity,
    this.price,
    this.totalPrice,
    this.foodItem,
  });

  int id;
  String quantity;
  String price;
  String totalPrice;
  FoodItem foodItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["id"],
    quantity: json["quantity"],
    price: json["price"],
    totalPrice: json["total_price"],
    foodItem: FoodItem.fromJson(json["food_item"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quantity": quantity,
    "price": price,
    "total_price": totalPrice,
    "food_item": foodItem.toJson(),
  };
}

class FoodItem {
  FoodItem({
    this.id,
    this.name,
    this.image,
    this.price,
  });

  int id;
  String name;
  String image;
  List<Price> price;

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    price: List<Price>.from(json["price"].map((x) => Price.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "price": List<dynamic>.from(price.map((x) => x.toJson())),
  };
}

class Price {
  Price({
    this.originalPrice,
    this.discountedPrice,
  });

  String originalPrice;
  String discountedPrice;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    originalPrice: json["original_price"],
    discountedPrice: json["discounted_price"],
  );

  Map<String, dynamic> toJson() => {
    "original_price": originalPrice,
    "discounted_price": discountedPrice,
  };
}
