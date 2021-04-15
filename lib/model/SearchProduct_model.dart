
class Search {
  Search({
    this.id,
    this.name,
    this.image,
    this.price,
  });

  int id;
  String name;
  String image;
  List<Price> price;

  factory Search.fromJson(Map<String, dynamic> json) => Search(
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
