import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_chef/categories_pages/burger_category.dart';
import 'package:home_chef/categories_pages/biriyani_category.dart';
import 'package:home_chef/categories_pages/chicken_category.dart';
import 'package:home_chef/categories_pages/hotDog_category.dart';
import 'package:home_chef/categories_pages/pizza_category.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/model/category_model.dart';
import 'package:home_chef/provider/homepage_provider.dart';
import 'package:home_chef/screens/cart_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<String> categories = [
  //   "All",
  //   "Burgers",
  //   "Pizza",
  //   "Hot dog",
  //   "Chicken fry"
  // ];
 List<CategoryModel> categories = [];

  int selectIndex = 0;
  int itemSelect = 0;

  List<Widget> itemPages = [
    BurgerCategoryPage(),
    BiriyaniCategoryPage(/*id:3,*/),
    PizzaCategoryPage(),
    HotDogCategoryPage(),
    ChickenCategoryPage(),
  ];
  PageController pageController = PageController();

  void _onPageChange(int index) {
    setState(() {
      return selectIndex = index;
    });
  }

  loadCategoryData() {
    print("All data are");
    final  data = Provider.of<MyitemsProvider>(context, listen: false)
        .fetchCategoryData();
     print(data);
  }

  @override
  void initState() {
    loadCategoryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    categories = Provider.of<MyitemsProvider>(context).category;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: hBackgroundColor,

        body: Container(
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  //height: height*0.35,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        // padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        padding:
                        EdgeInsets.only(left: 15, right: 15, bottom: 10),
                        child: Row(
                          //App Bar items........
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset("assets/menu.svg"),
                            ),
                            Container(
                              height: 60,
                              width: 70,
                              child: Image.asset(
                                'assets/logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            IconButton(icon: SvgPicture.asset("assets/cart.svg"), onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return CartPage();
                              }));
                            }),
                          ],
                        ),
                      ),
                      Container(
                        //Searching container.........
                        width: width * 0.9,
                        padding: const EdgeInsets.only(
                            top: 20, left: 10, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hey Sheehan!',
                              style: TextStyle(
                                  color: hHighlightTextColor, fontSize: 14),
                            ),
                            Text(
                              'What food do you want?',
                              style:
                              TextStyle(color: kwhiteColor, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      gapPadding: 5.0,
                                      borderSide: BorderSide(
                                          color: hHighlightTextColor,
                                          width: 2.5),
                                    ),
                                    hintText: 'Searching...',
                                    hintStyle: TextStyle(fontSize: 14),
                                    suffixIcon: Icon(Icons.search)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        //Category items..........
                        margin: EdgeInsets.only(left: 10, top: 20),
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return tebItems(index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 0.6,
                  child: PageView(
                    controller: pageController,
                    onPageChanged: _onPageChange,
                    children: itemPages,
                  ),
                )
              ],
            ),
          ), //
        ),
      ),
    );
  }

  Widget tebItems(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectIndex = index;
          pageController.jumpToPage(selectIndex);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categories[index].name,
              style: TextStyle(
                fontSize: 16,
                color: selectIndex == index ? hBlackColor : Colors.black45,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 3,
              width: 25,
              color: selectIndex == index
                  ? hHighlightTextColor
                  : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
