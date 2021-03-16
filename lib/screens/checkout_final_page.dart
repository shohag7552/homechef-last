import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_chef/bottom_navigation/home_page.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/model/All_items_model.dart';
import 'package:home_chef/model/Sumarry_model.dart';
import 'package:home_chef/model/profile_model.dart';
import 'package:home_chef/server/http_request.dart';

class FinalCheckoutPage extends StatefulWidget {
   final int order_id;
  FinalCheckoutPage({this.order_id});
  @override
  _FinalCheckoutPageState createState() => _FinalCheckoutPageState();
}

class _FinalCheckoutPageState extends State<FinalCheckoutPage> {

  List<Sumary> item = [];

  Sumary allItems;

  Future<dynamic> fetchSubCategories(int id) async {
    final data = await CustomHttpRequest.getSummaryItems(id);

    //items = cast<Items>(data);
    print(id);
    print("User data are $data");
    allItems = Sumary.fromJson(data);
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
  }

  List<Profile> profileData=[];
  Profile profile;

  Future<dynamic> fetchProfile() async {
    final data = await CustomHttpRequest.getProfile();

    print("User data are $data");
    profile = Profile.fromJson(data);
    print(
        '....#####################..................................................................');
    print(profile);
    print(
        '.......#############################..........................................................');
/*
    try {
      profileData.firstWhere((element) => element.name == profile.name);
    } catch (e) {
      if (mounted) {
        setState(() {
          item.add(allItems);
        });
      }
    }*/
  }




  @override
  void initState() {
    fetchSubCategories(widget.order_id);
    fetchProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
        body: widget.order_id == null ? Container(child: Center(child: CircularProgressIndicator(),),) :Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/Star.png"),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset('assets/victory.png'),
                            SizedBox(
                              width: 5,
                            ),
                            Image.asset("assets/Star.png"),
                          ],
                        ),
                        Text(
                          'Thank you for',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'your order!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Details',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: hBlackColor),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            child:allItems.orderFoodItems.length == null? CircularProgressIndicator() :ListView.builder(
                              itemCount: allItems.orderFoodItems.length,
                              itemBuilder: (context, index) {
                                int quantity = int.parse(allItems.orderFoodItems[index].pivot.quantity);
                                print(quantity.toString());
                                double price = double.parse(allItems.orderFoodItems[index].price[0].originalPrice);


                                return Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      //child: Image.asset('assets/pizza.jpg'),
                                      backgroundImage:
                                      NetworkImage("https://homechef.masudlearn.com/images/${allItems.orderFoodItems[index].image}"),
                                      radius: 30,
                                    ),
                                    title: Text(
                                      allItems.orderFoodItems[index].name,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text('x ${allItems.orderFoodItems[index].pivot.quantity}'),
                                    trailing: Text(
                                      '${price * quantity}',
                                      style: TextStyle(
                                          color: cTextColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                );
                              },
                            ) ,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shipping Details',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Delivery to :',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black38),
                                    ),
                                    Text(
                                      profile.name,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Contact :',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black38),
                                    ),
                                    Text(
                                      profile.contact,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Address :',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black38),
                                    ),
                                    Text(
                                      ' 625 St Markets Ave',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  //width: double.infinity,
                  decoration: BoxDecoration(
                    color: hBlackColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        'Finish',
                        style: fontStyle(color: hHighlightTextColor, size: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
