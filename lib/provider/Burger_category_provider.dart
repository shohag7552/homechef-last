import 'package:flutter/cupertino.dart';
import 'package:home_chef/model/All_items_model.dart';
import 'package:home_chef/server/http_request.dart';

class BurgerCategoryProvider with ChangeNotifier {
  List<Items> _foodItems = [];
  List<Items> get foodItems {
    return _foodItems;
  }


  Items items;
  Future<dynamic> fetchSubCategories() async {

    final data = await CustomHttpRequest.getBurger();

    print("User data are $data");
    items = Items.fromJson(data);
    print('....#####################..................................................................');
    print(items);
    print('.......#############################..........................................................');

    try {
      _foodItems.firstWhere((element) => element.id == items.id);
    } catch (e) {
      _foodItems.add(items);
    }
    notifyListeners();
  }
}
