
class Items {
  Items({
    this.id,
    this.name,
    this.image,
    this.icon,
    this.foods,
  });

  int id;
  String name;
  String image;
  String icon;
  List<Food> foods;

  factory Items.fromJson(Map<String, dynamic> json) => Items(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    icon: json["icon"],
    foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "icon": icon,
    "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
  };
}

class Food {
  Food({
    this.id,
    this.name,
    this.image,
    this.pivot,
    this.price,
  });

  int id;
  String name;
  String image;
  Pivot pivot;
  List<Price> price;

  // factory Food.fromJson(dynamic json) {
  //   return Food(json['id'] as int, json['name'] as String, json['image'] as String, json['pivot'] as Pivot, json['price'] as List<Price>);
  // }
  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    pivot: Pivot.fromJson(json["pivot"]),
    price: List<Price>.from(json["price"].map((x) => Price.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "pivot": pivot.toJson(),
    "price": List<dynamic>.from(price.map((x) => x.toJson())),
  };
}

class Pivot {
  Pivot({
    this.foodItemCategoryId,
    this.foodItemId,
    this.createdAt,
    this.updatedAt,
  });

  String foodItemCategoryId;
  String foodItemId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    foodItemCategoryId: json["food_item_category_id"],
    foodItemId: json["food_item_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "food_item_category_id": foodItemCategoryId,
    "food_item_id": foodItemId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
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
