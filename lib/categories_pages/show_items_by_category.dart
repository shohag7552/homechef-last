// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:home_chef/model/All_items_model.dart';
import 'package:home_chef/provider/Burger_category_provider.dart';
import 'package:home_chef/provider/CartLength_provider.dart';
import 'package:home_chef/screens/product_details_page.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:home_chef/widgets/product_card.dart';
import 'package:home_chef/widgets/spin_kit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class ShowItemsByCategory extends StatefulWidget {
  final int id;

  ShowItemsByCategory({this.id});

  @override
  _ShowItemsByCategoryState createState() => _ShowItemsByCategoryState();
}

class _ShowItemsByCategoryState extends State<ShowItemsByCategory> {
  bool onProgress = false;
  List<Items> item = [];

  Items allItems;

  Future<dynamic> fetchSubCategories(int id) async {
    final data = await CustomHttpRequest.getSubCategory(id);

    //items = cast<Items>(data);
    print(id);
    print("User data are $data");
    allItems = Items.fromJson(data);
    print(
        '....#####################..................................................................');
    print(allItems);
    print(
        '.......#############################..........................................................');

    try {
      item.firstWhere((element) => element.id == allItems.id);
    } catch (e) {
      if (mounted) {
        setState(() {
          item.add(allItems);
        });
      }
    }
    //notifyListeners();
  }

  /*loadAllData() async {
    print("All data areeeeeee");
    final data = await Provider.of<BurgerCategoryProvider>(context, listen: false)
        .fetchSubCategories(widget.id);
    print("mehadiiiii $data");
  }*/

  @override
  void initState() {
    fetchSubCategories(widget.id);
    final cartLength = Provider.of<CartLengthProvider>(context, listen: false);
    cartLength.fetchLength(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //item = Provider.of<BurgerCategoryProvider>(context).foodItems;
    final cartLength = Provider.of<CartLengthProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: onProgress,
      opacity: 0.1,
     // progressIndicator: Spin(),
      child: Container(
        child: item.isNotEmpty
            ? GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: allItems.foods.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      cartLength.fetchLength(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DetailsProductsPage(
                          id: allItems.foods[index].id,
                          name: allItems.foods[index].name,
                          image: allItems.foods[index].image,
                          originalPrice:
                              allItems.foods[index].price[0].originalPrice,
                          discountPrice:
                              allItems.foods[index].price[0].discountedPrice,
                        );
                      }));
                    },

                    child: Hero(
                      tag: "image",
                      child: ProductCard(
                        image:
                            "https://homechef.masudlearn.com/images/${allItems.foods[index].image}",
                        name: allItems.foods[index].name ?? "",
                        price: allItems.foods[index].price[0].originalPrice,
                        disprice: allItems.foods[index].price[0].discountedPrice,
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Spin(),
              ),
      ),
    );
  }
}
