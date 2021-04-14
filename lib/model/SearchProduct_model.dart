class Search {
  Search({
    this.id,
    this.name,
    this.image,
    this.isVisible,
    this.isAvailable,
    this.price,
  });

  int id;
  String name;
  String image;
  String isVisible;
  String isAvailable;
  List<Price> price;

  factory Search.fromJson(Map<String, dynamic> json) => Search(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    isVisible: json["is_visible"],
    isAvailable: json["is_available"],
    price: List<Price>.from(json["price"].map((x) => Price.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "is_visible": isVisible,
    "is_available": isAvailable,
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
