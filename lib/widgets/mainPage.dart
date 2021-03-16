import 'package:flutter/material.dart';

import 'package:home_chef/constant.dart';
import 'file:///E:/flutter/home_chef/lib/bottom_navigation/favorite_page.dart';
import 'package:home_chef/bottom_navigation/home_page.dart';
import 'package:home_chef/bottom_navigation/search_page.dart';
import 'package:home_chef/bottom_navigation/setting_page.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_chef/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedItem = 0;

  PageController _pageController = PageController();

  List<Widget> _page = [HomePage(), SearchPage(), FavoritePage(),SettingPage()];

  void _onPageChange(int index) {
    setState(() {
      return _selectedItem = index;
    });
  }
  SharedPreferences sharedPreferences;
  void isLogin()async{
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token");
    print(token);
    if(token==null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return LoginPage();
      }));
    }
  }
String token;

  @override
  void initState() {
    isLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,

      body: SafeArea(
        child: PageView(
          controller: _pageController,
          //physics: NeverScrollableScrollPhysics(),
          onPageChanged: _onPageChange,
          children: _page,
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          navigationIcon("assets/home.svg", 'Home', 0),
          navigationIcon("assets/search.svg", 'Search', 1),
          navigationIcon("assets/heart.svg", 'Favourite', 2),
          navigationIcon("assets/setting.svg", 'Setting', 3),
        ],
      ),
    );
  }

  Widget navigationIcon(String icon, String name, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItem = index;
          _pageController.jumpToPage(_selectedItem);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
        ),
        height: 60,
        width: MediaQuery.of(context).size.width / 4,
        child: Column(
          children: [
            SizedBox(
              height: 5.0,
            ),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: index == _selectedItem ? kBlackColor : kPrimaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: SvgPicture.asset(
                  icon,
                  color: index == _selectedItem ? kwhiteColor : kBlackColor,
                  height: 21,
                  width: 21,
                ),
              ),
            ),
            Text(
              name,
              style: TextStyle(
                color: index == _selectedItem ? kBlackColor : kIconColor,
                fontSize: 12.0,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
      ),
    );
  }
}
