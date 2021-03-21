
class Search {
  Search({
    this.id,
    this.name,
    this.image,
    this.isVisible,
    this.isAvailable,
  });

  int id;
  String name;
  String image;
  String isVisible;
  String isAvailable;

  factory Search.fromJson(Map<String, dynamic> json) => Search(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    isVisible: json["is_visible"],
    isAvailable: json["is_available"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "is_visible": isVisible,
    "is_available": isAvailable,
  };
}
