import 'package:flutter/cupertino.dart';
import 'package:home_chef/model/category_model.dart';
import 'package:home_chef/server/http_request.dart';

class MyitemsProvider with ChangeNotifier {
  List<CategoryModel> _category = [];

  List<CategoryModel> get category {
    return _category;
  }

  /*Future<dynamic> fetchCategoryData() async {

    final data = await CustomHttpRequest.getItems();
    print("value are $data");
    for (var entries in data) {
      CategoryModel model = CategoryModel(
        id: entries["id"],
        name: entries['name'],
        image: entries['image'],
      );
      try {
        print(" view my entries are  ${entries['name']}");
        _category.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        _category.add(model);
      }
    }
    notifyListeners();
  }*/
}
