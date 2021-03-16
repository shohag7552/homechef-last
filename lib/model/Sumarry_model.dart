
class Sumary {
  Sumary({
    this.id,
    this.quantity,
    this.price,
    this.discount,
    this.vat,
    this.orderDateAndTime,
    this.orderFoodItems,
  });

  int id;
  String quantity;
  String price;
  dynamic discount;
  dynamic vat;
  DateTime orderDateAndTime;
  List<OrderFoodItem> orderFoodItems;

  factory Sumary.fromJson(Map<String, dynamic> json) => Sumary(
    id: json["id"],
    quantity: json["quantity"],
    price: json["price"],
    discount: json["discount"],
    vat: json["VAT"],
    orderDateAndTime: DateTime.parse(json["order_date_and_time"]),
    orderFoodItems: List<OrderFoodItem>.from(json["order_food_items"].map((x) => OrderFoodItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quantity": quantity,
    "price": price,
    "discount": discount,
    "VAT": vat,
    "order_date_and_time": orderDateAndTime.toIso8601String(),
    "order_food_items": List<dynamic>.from(orderFoodItems.map((x) => x.toJson())),
  };
}

class OrderFoodItem {
  OrderFoodItem({
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

  factory OrderFoodItem.fromJson(Map<String, dynamic> json) => OrderFoodItem(
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
    this.orderId,
    this.foodItemId,
    this.foodItemPriceId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  String orderId;
  String foodItemId;
  String foodItemPriceId;
  String quantity;
  DateTime createdAt;
  DateTime updatedAt;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    orderId: json["order_id"],
    foodItemId: json["food_item_id"],
    foodItemPriceId: json["food_item_price_id"],
    quantity: json["quantity"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "food_item_id": foodItemId,
    "food_item_price_id": foodItemPriceId,
    "quantity": quantity,
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
