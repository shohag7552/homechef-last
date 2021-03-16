import 'package:flutter/cupertino.dart';
import 'package:home_chef/model/All_items_model.dart';
import 'package:home_chef/server/http_request.dart';
// T cast<T>(x) => x is T ? x : null;
class BurgerCategoryProvider with ChangeNotifier {
  List<Items> _foodItems = [];
  List<Items> get foodItems {
    return _foodItems;
  }


  Items items;
  Future<dynamic> fetchSubCategories(int id) async {
    _foodItems.clear();
    final data = await CustomHttpRequest.getSubCategory(id);

    //items = cast<Items>(data);
    print(id);
    print("User data are $data");
    items = Items.fromJson(data);
    print('....#####################..................................................................');
    print(items);
    print('.......#########################..........................................................');

    try {
      _foodItems.firstWhere((element) => element.id == items.id);
    } catch (e) {
      _foodItems.add(items);
    }
    notifyListeners();
  }
}
