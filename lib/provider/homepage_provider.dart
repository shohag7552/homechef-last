
import 'package:flutter/cupertino.dart';
import 'package:home_chef/model/categories.dart';
import 'package:home_chef/server/http_request.dart';

class CategoriesProvider with ChangeNotifier{

  List<Categories> categoriesList = [];
  bool onProgress = false;

  getCategories(context,bool onProgress) async {
    onProgress = true;

    print('$onProgress');

    categoriesList = await CustomHttpRequest.getCategories(context);
    //print(productsList);
    onProgress = false;
    print('$onProgress');
    notifyListeners();
  }
}