import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:home_chef/constant.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_chef/model/cartItems.dart';
import 'package:home_chef/screens/checkout_page.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:home_chef/widgets/mainPage.dart';
import 'package:home_chef/widgets/spin_kit.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> items = [];

  double totalPrice = 0.0 ;
  int count =0;
  bool onProgress = false;


  handleUpdateCart(){
    items.forEach((item) {
      updateCart(item);
    });
  }

  Future updateCart(CartItem item) async {

    final uri = Uri.parse("https://apihomechef.masudlearn.com/api/cart/${item.id.toString()}/update");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequest.getHeaderWithToken());
    request.fields['food_item_id'] = item.foodItem.id.toString();
    print('|food item id: | ${item.foodItem.id}');
    request.fields['quantity'] = item.quantity;
    print("quantity ${item.quantity}");
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("|||responseBody " + responseString);
    if (response.statusCode == 201) {
      print("responseBody1 " + responseString);
      var data = jsonDecode(responseString);
      if (data["error"] == "This item is out of stock" ){
        print('hendel');
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return CheckoutPage();
        }));
      }
     /* if(responseString != 'This item is out of stock'){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return CheckoutPage();
        }));
      }*/

    }
  }

  Future<dynamic> fetchCategoryData() async {

    final data = await CustomHttpRequest.getCartItems();
    print("||fetchCategoryData $data");
    CartItem cartItem;
    for (var item in data) {
      try {
        cartItem = CartItem.fromJson(item);
        items.firstWhere((element) => element.id == cartItem.id);
      } catch (e) {
        if (mounted) {
          setState(() {
            items.add(cartItem);
          });
        }
      }
    }
    if(items.length == 0){
      print('empty');
      showInSnackBar(value: 'Empty cart',color: Colors.yellow);
    }
    calcTotalPrice();

  }

  calcTotalPrice(){
    double total = 0.0;
    items.forEach((item) {
        total += double.parse(item.totalPrice);
    });
    setState(() {
      totalPrice = total;
    });
  }

  changeQuantity(int index, String type){
    int quantity = int.parse(items[index].quantity);

    if(type == 'DEC' && quantity == 1) return 0;
    quantity = type == 'INC'
        ? quantity + 1
        : quantity - 1;
    setState(() {
      items[index].quantity = quantity.toString();
      items[index].totalPrice = (double.parse(items[index].price) * quantity).toString();
    });
    calcTotalPrice();
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainPage()));
                },
                  child: Text('Ok'),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {

    fetchCategoryData();
   /* _getTotal();
    setState(() {
     // totalPriceCount();
    });*/
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cBackgroundColor,
        title: Text(
          'Order Details',
          style: TextStyle(
              color: hTextColor, fontWeight: FontWeight.w500, fontSize: 17),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: hTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            // Expanded(
            //   flex: 2,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 10),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: cBlackColor,
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(8),
            //         ),
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 20),
            //         child: Row(
            //           children: [
            //             Container(
            //               height: 36,
            //               width: 36,
            //               decoration: BoxDecoration(
            //                 color: Colors.white.withOpacity(0.15),
            //                 borderRadius: BorderRadius.all(
            //                   Radius.circular(8),
            //                 ),
            //               ),
            //               child: Icon(
            //                 Icons.location_on,
            //                 color: hHighlightTextColor,
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(left: 10),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     'Home',
            //                     style: TextStyle(
            //                         fontSize: 12,
            //                         color: Colors.white.withOpacity(0.5)),
            //                   ),
            //                   Text(
            //                     '625 St Marks Ave',
            //                     style: TextStyle(
            //                         color: cBackgroundColor, fontSize: 16),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             Spacer(),
            //             Text(
            //               'Edit',
            //               style: TextStyle(
            //                   color: hHighlightTextColor, fontSize: 12),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              flex: 10,
              child: ModalProgressHUD(
                inAsyncCall: onProgress,
                opacity: 0.2,
                // progressIndicator: Spin(),
                child: Container(
                  child: items.isNotEmpty ? ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      /* return ListTile(
                        subtitle:Text(items[index].foodItem.price[0].originalPrice),
                        title: Text(items[index].foodItem.name),
                        leading: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("https://homechef.masudlearn.com/images/${items[index].foodItem.image}")
                            )
                          ),
                        ),
                      );*/


                      // // totalPrice = 0;
                      // int price = int.parse(items[index].totalPrice);
                      // for(int i = 0; i<items.length; i++){
                      //
                      //   totalPrice+= price;
                      // }
                      // print(";;;;;;;;;;;;;;;;;;;;;;;;;");
                      // print(totalPrice);
                     /* return ProductsCard(
                        index: index,
                        image: items[index].foodItem.image,
                        name: items[index].foodItem.name,
                        totalPrice: items[index].totalPrice,
                        quentity: items[index].quantity,
                      );*/
                      var quentity = int.parse(items[index].quantity);
                      return  Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              border: Border.all(color: cBlackColor, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://homechef.masudlearn.com/images/${items[index].foodItem.image}"),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        items[index].foodItem.name.toString(),
                                        style:
                                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFF1A1A1A).withOpacity(0.1),
                                              width: 1.23),
                                          borderRadius: BorderRadius.all(Radius.circular(37)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child:IconButton(
                                                  onPressed: () {
                                                    changeQuantity(index, "DEC");
                                                  },
                                                  icon: SvgPicture.asset('assets/-.svg'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  '${items[index].quantity}',
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                  onPressed: () {
                                                    changeQuantity(index, "INC");
                                                  },
                                                  icon: SvgPicture.asset('assets/+.svg'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        print("tap");
                                        CustomHttpRequest.deleteItem(items[index].id)
                                            .then((value) => value);
                                        setState(() {
                                          items.removeAt(index);

                                        });
                                        calcTotalPrice();
                                        if(items.length==0){
                                          CartDialog(context);
                                        }
                                        //showInSnackBar("1 Item Delete",);
                                        //showInSnackBar(value: 'Delete Successfully',color: Colors.red);
                                        print("item delete.................");

                                        //Navigator.pop(context);
                                      },
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "\৳ ${items[index].totalPrice}",
                                        style: TextStyle(
                                            color: cTextColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ): Center(
                    child: Spin(),
                  ),
                ),
              ),
            ),
            Expanded(
              //flex: 6,
              flex: 2,
              child: Container(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /*Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              'Discount',
                              style: TextStyle(
                                  color: cBlackColor.withOpacity(0.5),
                                  fontSize: 14),
                            ),
                            Spacer(),
                            Text(
                              '-0.00',
                              style:
                                  TextStyle(color: cBlackColor, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    */
                    /*Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              'Delivery charge',
                              style: TextStyle(
                                  color: cBlackColor.withOpacity(0.5),
                                  fontSize: 14),
                            ),
                            Spacer(),
                            Text(
                              '0.00',
                              style:
                                  TextStyle(color: cBlackColor, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),*/
                    //coupon....
                    /*Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: hHighlightTextColor, width: 2.0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset("assets/voucher.svg"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Apply a voucher')
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),*/
                    //Divider(),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              'Total Price',
                              style:
                                  TextStyle(color: cBlackColor, fontSize: 14),
                            ),
                            Spacer(),
                            Text(
                              "\৳ $totalPrice",
                              style: TextStyle(
                                  color: cBlackColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: cBlackColor),
                        child: TextButton(
                          onPressed: () {
                            handleUpdateCart();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CheckoutPage(totalPrice: totalPrice);
                            }));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Checkout',
                                style: TextStyle(
                                    color: hHighlightTextColor, fontSize: 15),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: hHighlightTextColor,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*

class ProductsCard extends StatelessWidget {
  final int index;
  final String name, image, totalPrice, quentity;

  ProductsCard({this.index, this.quentity, this.name, this.totalPrice, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            border: Border.all(color: cBlackColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://homechef.masudlearn.com/images/$image"),
                      fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xFF1A1A1A).withOpacity(0.1),
                            width: 1.23),
                        borderRadius: BorderRadius.all(Radius.circular(37)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {},
                                child: SvgPicture.asset('assets/-.svg'),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                quentity.toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {},
                                child: SvgPicture.asset('assets/+.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 16,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    totalPrice.toString(),
                    style: TextStyle(
                        color: cTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/