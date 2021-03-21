
class Shipping {
  Shipping({
    this.data,
  });

  Data data;

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.shippingAddress,
  });

  ShippingAddress shippingAddress;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    shippingAddress: ShippingAddress.fromJson(json["shipping_address"]),
  );

  Map<String, dynamic> toJson() => {
    "shipping_address": shippingAddress.toJson(),
  };
}

class ShippingAddress {
  ShippingAddress({
    this.area,
    this.appartment,
    this.house,
    this.road,
    this.city,
    this.district,
    this.zipCode,
    this.contact,
  });

  String area;
  String appartment;
  String house;
  String road;
  String city;
  String district;
  String zipCode;
  String contact;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    area: json["area"],
    appartment: json["appartment"],
    house: json["house"],
    road: json["road"],
    city: json["city"],
    district: json["district"],
    zipCode: json["zip_code"],
    contact: json["contact"],
  );

  Map<String, dynamic> toJson() => {
    "area": area,
    "appartment": appartment,
    "house": house,
    "road": road,
    "city": city,
    "district": district,
    "zip_code": zipCode,
    "contact": contact,
  };
}
