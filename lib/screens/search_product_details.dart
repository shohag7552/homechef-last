import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/model/Search_details_model.dart';
import 'package:home_chef/screens/cart_page.dart';
import 'package:home_chef/screens/login_page.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:home_chef/widgets/mainPage.dart';
import 'package:home_chef/widgets/spin_kit.dart';
import 'package:http/http.dart' as http;
import 'package:home_chef/model/All_items_model.dart';
import 'package:home_chef/model/details.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchDetailsPage extends StatefulWidget {
  //final Details products;
  // final Items items;
  // SearchDetailsPage({this.items});
  int id;

  SearchDetailsPage({
    this.id
  });

  @override
  _SearchDetailsPageState createState() => _SearchDetailsPageState();
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {

  PageController pageController = PageController();
  String token;

  bool onProgress = false;
  int count = 1;

  int selectIndex = 0;

  void _onPageChange(int index) {
    setState(() {
      return selectIndex = index;
    });
  }


  // SharedPreferences sharedPreferences;
  // String token;
  Future AddToCard(BuildContext context, int id, int quentity) async {

    final uri = Uri.parse("https://apihomechef.antapp.space/api/add/cart");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequest.getHeaderWithToken());
    request.fields['food_item_id'] = id.toString();
    request.fields['quantity'] = quentity.toString();
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(response.statusCode);
    print("responseBody " + responseString);
    //showInSnackBar("${responseString}");
    if (response.statusCode == 201) {
      print("responseBody1 " + responseString);
      var data = jsonDecode(responseString);
      var a = data["message"];
      var b = data["error"];
      //showInSnackBar(responseString);
      if(a != null){
        showInSnackBar(value: a,color: Colors.green);
        setState(() {
          count = 1;
          onProgress = false;
        });


      }
      else{
        showInSnackBar(value: b,color: Colors.red);
        //_showSnackMessage(message: responseString);
        setState(() {
          onProgress = false;
        });
      }
    }

    if (response.statusCode == 200) {
      print("responseBody1 " + responseString);
      var data = jsonDecode(responseString);
      var a = data["message"];
      var b = data["error"];
      //showInSnackBar(responseString);
      if(a != null){
          showInSnackBar(value: a,color: Colors.green);
          setState(() {
            count = 1;
            onProgress = false;
          });


      }
      else{
        showInSnackBar(value: b,color: Colors.red);
        //_showSnackMessage(message: responseString);
        setState(() {
          onProgress = false;
        });
      }
    }
  }
  showInToast(String value){
    Fluttertoast.showToast(
        msg: "$value",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: hHighlightTextColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  List<SearchDetails> item = [];

  SearchDetails fullItems;

  Future<dynamic> fetchSubCategories(int id) async {
    //print(" item id issss: ${widget.id}");
    setState(() {
      onProgress = true;
    });
    final data = await CustomHttpRequest.searchItenDetails(id);

    //items = cast<Items>(data);
    //print(widget.id);
    print("User data are $data");
    fullItems = SearchDetails.fromJson(data);
    print(
        '....#####################..................................................................');
    print(fullItems != null ? fullItems.price[0].originalPrice : "");
    print(
        '.......#############################..........................................................');

    try {
      item.firstWhere((element) => element.id == fullItems.id);
      setState(() {
        onProgress = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          item.add(fullItems);
          onProgress = false;
          print(" search cat.............$item");
        });
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void showInSnackBar({String value , Color color}) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
    ));
  }

  @override
  void initState() {
    fetchSubCategories(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double discountPrice = fullItems != null ? double.parse(fullItems.price[0].discountedPrice.toString()) : null;
    double orginalPrice = fullItems != null ? double.parse(fullItems.price[0].originalPrice.toString()) : null;

    int item_id = widget.id;

    List<Widget> images = [
      Image.network(
        'https://homechef.antapp.space/images/${fullItems != null ? fullItems.image: ""}',
        fit: BoxFit.cover,
      ),
      Image.network(
        'https://homechef.antapp.space/images/${fullItems != null ? fullItems.image:""}',
        fit: BoxFit.cover,
      ),
    ];
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kwhiteColor,
      body: fullItems != null ? SafeArea(

        child: ModalProgressHUD(
          inAsyncCall: onProgress,
          opacity: 0.1,
          progressIndicator: Spin(),
          child: Stack(children: [
            Column(
              children: [
                Stack(
                  children: [
                    // Items picture....
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 350,
                        width: MediaQuery.of(context).size.width,
                        child: PageView(
                          controller: pageController,
                          onPageChanged: _onPageChange,
                          children: images,

                        ),
                      ),
                    ),
                    //TabBar....
                    Row(
                      children: [
                        IconButton(
                          icon: SvgPicture.asset("assets/arrow-left.svg"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Text(
                          'Product Details',
                          style: TextStyle(color: kwhiteColor, fontSize: 18),
                        ),
                        Spacer(),
                        IconButton(
                          icon: SvgPicture.asset("assets/more-v.svg"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    // Container.......
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(top: 300),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kwhiteColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          //PageView indecator..
                          Container(
                            margin: EdgeInsets.only(left: 160),
                            height: 10,
                            child: ListView.builder(
                              itemCount: images.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return indecator(index);
                              },
                            ),
                          ),

                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            fullItems != null ? fullItems.name : "",
                            style: TextStyle(
                              color: hTextColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          // Raiting .....
                          Container(
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/star.svg",
                                    color: hHighlightTextColor),
                                SizedBox(width: 5),
                                SvgPicture.asset("assets/star.svg",
                                    color: hHighlightTextColor),
                                SizedBox(width: 5),
                                SvgPicture.asset("assets/star.svg",
                                    color: hHighlightTextColor),
                                SizedBox(width: 5),
                                SvgPicture.asset("assets/star.svg",
                                    color: hHighlightTextColor),
                                SizedBox(width: 5),
                                SvgPicture.asset("assets/star.svg",
                                    color: hBackgroundColor)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          // Details.....

                          Container(
                            height: 100,
                            //child: Expanded(
                            /*  child: Text(
                                'This cake is moist and has the perfect crumb.'
                                ' I cannot imagine making a chocolate cake using any other recipe.'
                                ,
                                maxLines: 5,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: hTextColor.withOpacity(0.4),
                                ),
                              ),*/
                           // ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                        ],
                      ),
                    ),
                    //Under Side....
                  ],
                )
              ],
            ),
            Positioned(
              bottom: 10,
              right: 10,
              left: 10,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 113,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFF1A1A1A).withOpacity(0.1),
                                width: 1.23),
                            borderRadius: BorderRadius.all(Radius.circular(37)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (count >= 2) {
                                      count--;
                                    }

                                  });
                                },
                                icon: SvgPicture.asset('assets/-.svg'),
                              ),
                              Text(
                                '$count',
                                style: TextStyle(fontSize: 24),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (count >= 1 && count < 9) {
                                      count++;
                                    }
                                  });
                                },
                                icon: SvgPicture.asset('assets/+.svg'),
                              )
                            ],
                          ),
                        ),
                        Spacer(),

                        Text(
                          '\৳${fullItems != null ? orginalPrice * count :''}',
                          style: TextStyle(
                            color: hTextColor.withOpacity(0.4),
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '\৳ ${fullItems != null ? discountPrice * count : ''}',
                          //"${widget.products.price * count}",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //buttons....
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: hHighlightTextColor, width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Center(
                            child: SvgPicture.asset('assets/heart.svg'),
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.78,
                          decoration: BoxDecoration(
                            color: hHighlightTextColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              print('add to card clllllllick');
                              SharedPreferences sharedPreferences;

                              sharedPreferences = await SharedPreferences.getInstance();
                              token = sharedPreferences.getString("token");
                              print(token);


                              if(token == null){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return LoginPage();
                                }));
                              }else{

                                AddToCard(context,item_id,count);
                                setState(() {
                                  onProgress = true;
                                });
                              }

                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/shopping-cart.svg',color: Colors.black,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add to cart',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w500,color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ) : Container(child:  Center(child: Spin()),),
    );
  }

  Widget indecator(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectIndex = index;
          pageController.jumpToPage(selectIndex);
        });
      },
      child: Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: selectIndex == index ? kBlackColor : Colors.black26,
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

/* _showSnackMessage({String message}) {
    var snackBar = SnackBar(
      content: Text('added'),
      duration: Duration(seconds: 2),
    );
   // ScaffoldMessenger.of(context).showSnackBar(snackBar);
     _scaffoldKey.currentState.showSnackBar(snackBar);
  }*/
}