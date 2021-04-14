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
import 'package:provider/single_child_widget.dart';

import 'constant.dart';

void main() {
  runApp(
    MultiProvider(
      providers: providers,
      child: MyApp(),
    ),
  );
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<CartLengthProvider>(create: (_) => CartLengthProvider()),
  ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Chef',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: hHighlightTextColor,
        canvasColor: Colors.white,
      ),
      home: MainPage(),
      routes: {
        HomePage.id: (context) => HomePage(),
      },
    );
  }
}
