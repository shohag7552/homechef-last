import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_chef/bottom_navigation/search_page.dart';
import 'package:home_chef/categories_pages/show_items_by_category.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/model/SearchProduct_model.dart';
import 'package:home_chef/model/cartItems.dart';
import 'package:home_chef/model/category_model.dart';
import 'package:home_chef/model/profile_model.dart';
import 'package:home_chef/provider/CartLength_provider.dart';
import 'package:home_chef/provider/homepage_provider.dart';
import 'package:home_chef/screens/cart_page.dart';
import 'package:home_chef/screens/edit_profile.dart';
import 'package:home_chef/screens/login_page.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  static const String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool onProgress = false;

  //internet connection
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
  Future checkInternetConnection() async{
    check().then((internet){
      if(internet == null && internet== false){
        print(";;;;;;;;;;;;;;;;;;;;;;;;;;;$internet");
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('No internet connection '),
                content: Text('Please connect to the internet'),
                elevation: 6,
                actions: <Widget>[
                  Center(
                    child: TextButton(onPressed: () {
                      Navigator.pop(context);
                    },
                      child: Text('Ok'),
                    ),
                  ),
                ],
              );
            });
      }

    });
  }

  //category data fatching..
  List<CategoryModel> categories = [];
  String token;

  int selectIndex = 0;
  int itemSelect = 0;

  PageController pageController = PageController();

  void _onPageChange(int index) {
    setState(() {
      return selectIndex = index;
    });
  }

  Future<dynamic> fetchCategoryData() async {
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
        categories.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        if (mounted) {
          setState(() {
            categories.add(model);
          });
        }
      }
    }
  }

  //cart page length
  List<CartItem> cartLength = [];
  int length;

  Future<dynamic> getCartLength() async {
    cartLength.clear();
    print('lengthhhhh callll');
    final data = await CustomHttpRequest.getCartItems();
    print("||fetchCategoryDataaaaaaaaaaaaaaaaaaaaaaaaaaaaa $data");

    if(mounted){
      CartItem cartItem;
      for (var item in data) {
        cartItem = CartItem.fromJson(item);

        cartLength.add(cartItem);
      }
      setState(() {
        length = cartLength.length;
        print('Bug.......... $length');
      });
    }
  }

  Future<void> CartDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Your cart is empty '),
            content: Text('Please order some food'),
            elevation: 6,
            actions: <Widget>[
              Center(
                child: TextButton(onPressed: () {
                  Navigator.pop(context);
                },
                  child: Text('Ok'),
                ),
              ),
            ],
          );
        });
  }


  Future<void> displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure want to LogOut ?'),
            actions: <Widget>[

              TextButton(
                // color: Colors.black,
                // textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  SharedPreferences preferences =
                  await SharedPreferences.getInstance();
                  await preferences.remove('token');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }));
                  /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));*/
                },
              ),
            ],
          );
        });
  }

  //for profile info..
  List<Profile> profileData = [];
  Profile profile;
  String name;

  Future<dynamic> fetchProfile() async {
    final data = await CustomHttpRequest.getProfile();

    print("User data are $data");
    if (mounted) {
      profile = Profile.fromJson(data);

      setState(() {
        name = profile.name;
      });
    }

    print(name);
    print(
        '....#####################..................................................................');
    print(profile);
    print(
        '.......#############################..........................................................');
  }

  Timer timer;

  //search item
  List<Search> list = [];

  Future fatchItems() async {
    setState(() {
      onProgress = true;
    });
    final data = await CustomHttpRequest.SearchItems();
    print("value are $data");
    for (var entries in data) {
      Search model = Search(
        id: entries["id"],
        name: entries['name'],
        image: entries['image'],
      );
      try {
        print(" view my entries are  ${entries['name']}");
        list.firstWhere((element) => element.id == entries['id']);
        setState(() {
          onProgress = false;
        });
      } catch (e) {
        if (mounted) {
          setState(() {
            list.add(model);
            onProgress = false;
          });
        }
      }
    }
  }


  @override
  void initState() {
    checkInternetConnection();
    fetchProfile();
    fetchCategoryData();
    fatchItems();
    //getCartLength();
   /* if(mounted){
      timer = Timer.periodic(Duration(seconds: 2), (timer) {
        getCartLength();
      });
    }*/

    final cartLength = Provider.of<CartLengthProvider>(context, listen: false);
    cartLength.fetchLength(context);
    super.initState();
  }


  @override
  void dispose() {
   // timer.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //categories = Provider.of<MyitemsProvider>(context).category;
    //length = Provider.of<CartLengthProvider>(context).items;
    //length = Provider.of<CartLengthProvider>(context).items.length;
    final cartLength = Provider.of<CartLengthProvider>(context);
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: hBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () async{
              SharedPreferences sharedPreferences = await SharedPreferences
                  .getInstance();
              token = sharedPreferences.getString("token");
              print(token);
              if (token != null) {
                displayTextInputDialog(context);
              }else{
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              }

            },
            icon: SvgPicture.asset("assets/menu.svg"),
          ),
          title: Container(
            height: 60,
            width: 70,
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
            ),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                    icon: SvgPicture.asset("assets/cart.svg"),
                    onPressed: () async {
                      SharedPreferences sharedPreferences = await SharedPreferences
                          .getInstance();
                      token = sharedPreferences.getString("token");
                      print(token);
                      if (token == null) {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }));
                      }
                      else {
                        //cartLength.length
                        if ( cartLength.cartList.length> 0) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return CartPage();
                              }));
                        }
                        else {
                          print(
                              'please select any product,your cart is empty!');
                          CartDialog(context);
                        }
                      }
                    }),
                Positioned(
                    top: 15,
                    right: 10,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        color: hHighlightTextColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(
                          cartLength.cartList.isEmpty ? "0" : cartLength.cartList.length.toString(),
                          style: TextStyle(fontSize: 8, color: Colors.black),
                        ),
                      ),
                    ))
              ],
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
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

                      SizedBox(
                        height: 10,
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
                            Row(
                              children: [
                                Text(
                                  'Hey ',
                                  style: TextStyle(
                                      color: hHighlightTextColor, fontSize: 14),
                                ),
                                Text(
                                  "${name ?? 'user'}!",
                                  style: TextStyle(
                                      color: hHighlightTextColor, fontSize: 14),
                                ),
                              ],
                            ),
                            Text(
                              'What food do you want?',
                              style:
                              TextStyle(color: kwhiteColor, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: (){
                                showSearch(context: context, delegate: SearchHere(itemsList: list)).then((value){
                                  cartLength.fetchLength(context);
                                });

                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),

                                ),
                                child: Row(
                                  children: [
                                    Text('Search..',style: TextStyle(color: Colors.black87),),
                                    Spacer(),
                                    Icon(Icons.search,color: Colors.black87,),
                                  ],
                                ),

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
                    physics: BouncingScrollPhysics(),
                    controller: pageController,
                    onPageChanged: _onPageChange,
                    children: <Widget>[
                      for (int i = 0; i < categories.length; i++)
                        InkWell(
                          onTap: () {
                            cartLength.fetchLength(context);
                          },
                          child: ShowItemsByCategory(
                            id: categories[i].id,
                          ),
                        )
                    ],
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
          getCartLength();
          print('length call');
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
