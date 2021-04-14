import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_chef/bottom_navigation/home_page.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/model/All_items_model.dart';
import 'package:home_chef/model/Shipping_model.dart';
import 'package:home_chef/model/Sumarry_model.dart';
import 'package:home_chef/model/profile_model.dart';
import 'package:home_chef/provider/CartLength_provider.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:home_chef/widgets/spin_kit.dart';
import 'package:provider/provider.dart';

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

  List<Profile> profileData = [];
  Profile profile;

  Future<dynamic> fetchProfile() async {
    final data = await CustomHttpRequest.getProfile();

    print("User data are $data");
    setState(() {
      profile = Profile.fromJson(data);
    });
    print(
        '....#####################..................................................................');
    print(profile);
    print(
        '.......#############################..........................................................');
  }List<Shipping> shippingData = [];
  Shipping shipping;

  Future<dynamic> fetchShipping(int id) async {
    final data = await CustomHttpRequest.getShippingAddress(id);

    print("User data are $data");
    setState(() {
      shipping = Shipping.fromJson(data);
    });
    print(
        '....#####################..................................................................');
    print(shipping);
    print('haaaaaaaaaaaaa${shipping.data.shippingAddress.house}');
    print(
        '.......#############################..........................................................');
  }
  String name ,contact,address,road ,district;

 /* Future showInformation()async{
    if(shipping.data.shippingAddress == null){
      name =  profile != null ? profile.name : '';
      contact = profile != null ? profile.contact : '';
      address = profile != null ? profile.billingAddress.house : '';
      road = profile != null ? profile.billingAddress.road : '';
      district = profile != null ? profile.billingAddress.district : '';
    }else{
      name =profile != null ? profile.name : '';
      contact = shipping.data.shippingAddress!=null? shipping.data.shippingAddress.contact:'';
      address = shipping.data.shippingAddress!=null? shipping.data.shippingAddress.house:'';
      road = shipping.data.shippingAddress!=null? shipping.data.shippingAddress.road:'';
      district = shipping.data.shippingAddress!=null? shipping.data.shippingAddress.district:'';

    }
  }*/

  @override
  void initState() {
    fetchSubCategories(widget.order_id);
    fetchProfile();
    fetchShipping(widget.order_id);
    //showInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartLength = Provider.of<CartLengthProvider>(context);
    name =  profile != null ? profile.name : '';
    contact = profile != null ? profile.contact : '';
    address = profile != null ? profile.billingAddress.house : '';
    road = profile != null ? profile.billingAddress.road : '';
    district = profile != null ? profile.billingAddress.district : '';
    return Scaffold(
      body: widget.order_id == null
          ? Container(
              child: Center(
                child: Spin(),
              ),
            )
          : SafeArea(
            child: Center(
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
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
                                  child: (allItems != null &&
                                          allItems.orderFoodItems.length ==
                                              null)
                                      ? Spin()
                                      : ListView.builder(
                                          itemCount: allItems != null
                                              ? allItems.orderFoodItems.length
                                              : 0,
                                          itemBuilder: (context, index) {
                                            int quantity = int.parse(allItems
                                                .orderFoodItems[index]
                                                .pivot
                                                .quantity);
                                            print(quantity.toString());
                                            double price = double.parse(allItems
                                                .orderFoodItems[index]
                                                .price[0]
                                                .discountedPrice);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  //child: Image.asset('assets/pizza.jpg'),
                                                  backgroundImage: NetworkImage(
                                                      "https://homechef.masudlearn.com/images/${allItems.orderFoodItems[index].image}"),
                                                  radius: 30,
                                                ),
                                                title: Text(
                                                  allItems != null
                                                      ? allItems
                                                          .orderFoodItems[index]
                                                          .name
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                subtitle: Text(
                                                    'x ${allItems != null ? allItems.orderFoodItems[index].pivot.quantity : ''}'),
                                                trailing: Text(
                                                  '${price * quantity}',
                                                  style: TextStyle(
                                                      color: cTextColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                fontSize: 12,
                                                color: Colors.black38),
                                          ),
                                          Text(
                                            "${shipping != null? name : name}",
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
                                                fontSize: 12,
                                                color: Colors.black38),
                                          ),
                                          Text(
                                            "${shipping != null?shipping.data.shippingAddress.contact : contact}",
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
                                                fontSize: 12,
                                                color: Colors.black38),
                                          ),
                                          Text(
                                            "${shipping != null?shipping.data.shippingAddress.house : address}",

                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            " house, ",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "${shipping != null?shipping.data.shippingAddress.road : road}",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            " st, ",
                                           style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "${shipping != null?shipping.data.shippingAddress.district: district}",
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
                            cartLength.fetchLength(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Text(
                              'Finish',
                              style: fontStyle(
                                  color: hHighlightTextColor, size: 16),
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
