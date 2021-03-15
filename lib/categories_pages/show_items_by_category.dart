import 'package:flutter/material.dart';
import 'package:home_chef/model/All_items_model.dart';
import 'package:home_chef/provider/Burger_category_provider.dart';
import 'package:home_chef/widgets/product_card.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
class BurgerCategoryPage extends StatefulWidget {
   int id=1;
 // BurgerCategoryPage({this.id});


  BurgerCategoryPage(int id) {
    this.id=id;
    print("1---$id");
  }
  @override
  _BurgerCategoryPageState createState() => _BurgerCategoryPageState(this.id);
}

class _BurgerCategoryPageState extends State<BurgerCategoryPage> {

  bool onProgress = false;
  List<Items> item = [];
  Items it;

   int id;
  _BurgerCategoryPageState( int id){
  this.id=id;
  }

  loadAllData() async {
    print("2---$id");
    print("All data areeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    final data = await Provider.of<BurgerCategoryProvider>(context, listen: false)
        .fetchSubCategories(this.id);
    print("mehadiiiii $data");
  }
  @override
  void initState() {
    loadAllData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    item = Provider.of<BurgerCategoryProvider>(context).foodItems;
    return ModalProgressHUD(
      inAsyncCall: onProgress,
      child: Container(
        child: item.isNotEmpty
            ? GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: it.foods.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (BuildContext context, int index) {

            print('................');
            print(it.foods[index].price[index].originalPrice);
            print(it.foods[index].price[index].discountedPrice);
            print(it.foods[index].name);
            print('................');

            // return Text(it.foods[index].price[index].discountedPrice);
            return InkWell(
              // onTap: () {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => DetailsProductsPage(
              //                 products: item[index],
              //               )));
              // },

              child: ProductCard(
                price: it.foods[index].price[index].originalPrice ?? "",
                disprice: it.foods[index].price[index].discountedPrice ?? "",
                image: it.foods[index].image ?? "",
                name: it.foods[index].name ?? "",
              ),
            );
          },
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
