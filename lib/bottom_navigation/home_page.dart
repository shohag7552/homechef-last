import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_chef/bottom_navigation/search_page.dart';
import 'package:home_chef/categories_pages/show_items_by_category.dart';
import 'package:home_chef/constant.dart';
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

class HomePage extends StatefulWidget {
  static const String id = 'HomePage';

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

  /*getCartLength() async {
    print("expenditure entries are");
    final data = await Provider.of<CartLengthProvider>(context, listen: false)
        .fetchLength();
    print("aaaaaaaaaaaaaaaa${data}");
  }*/
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
              /* TextButton(
                // color: Colors.black,
                // textColor: Colors.white,
                child: Text('Update Profile'),
                onPressed: () {
                  */ /*Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ProfileUpdate();
                  }));*/ /*
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return ProfileUpdate();
                  }));
                },
              ),*/
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
                  Navigator.of(context).pushReplacement(
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

  @override
  void initState() {
    fetchProfile();
    fetchCategoryData();
    /*setState(() {
      getCartLength();
    });*/
    //timer = Timer.periodic(Duration(seconds: 15), (Timer t) => checkForNewSharedLists());
    if(mounted){
      timer = Timer.periodic(Duration(seconds: 2), (timer) {
        getCartLength();
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    pageController.dispose();
    super.dispose();
  }

  /* @override
   void didChangeDependencies() {
    print("did change call");
    setState(() {
      getCartLength();
    });


    super.didChangeDependencies();

   }*/

  @override
  Widget build(BuildContext context) {
    //categories = Provider.of<MyitemsProvider>(context).category;
    //length = Provider.of<CartLengthProvider>(context).items;
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
                        if (length > 0) {
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
                          cartLength.isEmpty ? "0" : length.toString(),
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
                      /*Padding(
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
                      ),*/
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
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return SearchPage();
                                }));
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
                                /*child: TextFormField(
                                  onTap: (){

                                  },
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
                                ),*/
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
                  child: PageView(physics: BouncingScrollPhysics(),

                    controller: pageController,
                    onPageChanged: _onPageChange,
                    children: <Widget>[
                      for (int i = 0; i < categories.length; i++)
                        InkWell(
                          onTap: () {
                            getCartLength().then((value) => getCartLength());
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
