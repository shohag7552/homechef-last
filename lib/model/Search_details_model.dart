// To parse this JSON data, do
//
//     final searchDetails = searchDetailsFromJson(jsonString);

import 'dart:convert';

SearchDetails searchDetailsFromJson(String str) => SearchDetails.fromJson(json.decode(str));

String searchDetailsToJson(SearchDetails data) => json.encode(data.toJson());

class SearchDetails {
  SearchDetails({
    this.id,
    this.name,
    this.image,
    this.price,
  });

  int id;
  String name;
  String image;
  List<Price> price;

  factory SearchDetails.fromJson(Map<String, dynamic> json) => SearchDetails(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    price: json["price"] == null ? null : List<Price>.from(json["price"].map((x) => Price.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "price": price == null ? null : List<dynamic>.from(price.map((x) => x.toJson())),
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
    originalPrice: json["original_price"] == null ? null : json["original_price"],
    discountedPrice: json["discounted_price"] == null ? null : json["discounted_price"],
  );

  Map<String, dynamic> toJson() => {
    "original_price": originalPrice == null ? null : originalPrice,
    "discounted_price": discountedPrice == null ? null : discountedPrice,
  };
}
