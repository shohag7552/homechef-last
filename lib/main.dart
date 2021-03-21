import 'package:flutter/material.dart';
import 'package:home_chef/bottom_navigation/home_page.dart';
import 'package:home_chef/provider/Burger_category_provider.dart';
import 'package:home_chef/provider/CartLength_provider.dart';
import 'package:home_chef/provider/Profile_provider.dart';
import 'package:home_chef/provider/homepage_provider.dart';
import 'package:home_chef/screens/cart_page.dart';
import 'package:home_chef/screens/login_page.dart';
import 'package:home_chef/screens/registration_page.dart';
import 'package:home_chef/widgets/mainPage.dart';
import 'package:provider/provider.dart';

import 'constant.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MyitemsProvider()),
        ChangeNotifierProvider.value(value: BurgerCategoryProvider()),
        ChangeNotifierProvider.value(value: ProfileProvider()),
        ChangeNotifierProvider.value(value: CartLengthProvider()),
      ],
      child: MaterialApp(
        title: 'Home Chef',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: hHighlightTextColor,
          canvasColor: Colors.white,
        ),
        home:
        MainPage(),
        routes: {
          HomePage.id:(context)=>HomePage(),

        },
      ),
    );
  }
}
