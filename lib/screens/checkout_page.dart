import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/model/profile_model.dart';
import 'package:home_chef/screens/checkout_final_page.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:home_chef/widgets/check_textField.dart';
import 'package:home_chef/widgets/registerTextField.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  var orderId;

  bool isCashPay = true;
  bool isCardPay = false;
  bool isBkashPay = false;
  String cityType;
  int payment_id = 2;
  bool onProgress = false;
  String districtType;
  List<String> _getStorageHub = ['Dhaka', 'Chittagong'];
  List<String> _getDistrict = ['Cumilla', 'Feni', 'narayngang'];

  //black card items...
  String home, house, road, area, district;

  //bottomsheet....
/*  String cityType;
  String districtType;
  List<String> _getStorageHub = ['Dhaka', 'Chittagong'];
  List<String> _getDistrict = ['Cumilla', 'Feni', 'narayngang'];*/

  TextEditingController houseSheetController = TextEditingController();
  TextEditingController roadSheetController = TextEditingController();
  TextEditingController areaSheetController = TextEditingController();

  TextEditingController contactController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController roadController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController districController = TextEditingController();
  TextEditingController appertmentController = TextEditingController();
  TextEditingController zipController = TextEditingController();


  bool isCheck = false;
 // bool showBill = true;

  bool isBilling = false;
  bool isShipping = false;
  justTry(){
    if(isShipping== true){
      print('shipping address added');
    }
    else{
      print('Billing address added');
    }
  }

  Future postShipingAddress() async {
    // if (isShipping == true) {
      final uri =
          Uri.parse("https://apihomechef.masudlearn.com/api/place/order");
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(await CustomHttpRequest.getHeaderWithToken());
      request.fields['shipping_contact'] = contactController.text.toString();
      /*request.fields['shipping_appartment'] =
          appertmentController.text.toString();
      request.fields['shipping_zip_code'] = zipController.text.toString();*/
      request.fields['shipping_house'] = houseController.text.toString();
      request.fields['shipping_road'] = roadController.text.toString();
      request.fields['shipping_area'] = areaController.text.toString();
      request.fields['shipping_city'] = cityType.toString();
      request.fields['shipping_district'] = districtType.toString();
      request.fields['payment_type_id'] = payment_id.toString();

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print("responseBody " + responseString);
      if (response.statusCode == 201) {
        print("responseBody1 " + responseString);
        var data = jsonDecode(responseString);
        print('oooooooooooooooooooo');
        print(data);

        orderId = data["order_id"];
        print(orderId);
        if (orderId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return FinalCheckoutPage(
                order_id: orderId,
              );
            }),
          );
        } else {
          showInSnackBar(
              value: 'please fill the shipping address', color: Colors.red);
        }

        setState(() {
          onProgress = false;
        });
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
      } else {
        setState(() {
          onProgress = false;
        });

        var errorr = jsonDecode(responseString.trim().toString());
        // showInSnackBar("Registered Failed, ${errorr}");
        print("Registered failed " + responseString);
      }
    // } else {}
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void showInSnackBar({String value, Color color}) {
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

  List<Profile> profileData=[];
  Profile profile;
  String proHouseNumber;
  String proRoadNumber;

  Future<dynamic> fetchProfile() async {
    final data = await CustomHttpRequest.getProfile();

    print("User data are $data");
    profile = Profile.fromJson(data);
    print(
        '....#####################..................................................................');
    print("house number ${profile.billingAddress.house}");
    setState(() {
      proHouseNumber = profile.billingAddress.house.toString();
      proRoadNumber = profile.billingAddress.road;
    });
    print("road number ${profile.billingAddress.road}");

    print(
        '.......#############################..........................................................');

  }

  @override
  void initState() {
    fetchProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: kwhiteColor,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          title: Text(
            'Checkout',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w500, color: hBlackColor),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: hBlackColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              //padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Address ...
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cBlackColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  color: hHighlightTextColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Home',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.5)),
                                    ),
                                    SizedBox(height: 3,),
                                    Row(
                                      children: [
                                        Text(
                                          '$proHouseNumber , ',
                                          style: TextStyle(
                                              color: cBackgroundColor,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          '$proRoadNumber St, ',
                                          style: TextStyle(
                                              color: cBackgroundColor,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          'Dhaka',
                                          style: TextStyle(
                                              color: cBackgroundColor,
                                              fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: (){
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return bottomSheet(context);
                                      });
                                },
                                icon: Text(
                                  'Edit',
                                  style: TextStyle(
                                      color: hHighlightTextColor, fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Billing Address Radio button..
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCheck = !isCheck;
                          isShipping = !isCheck;
                          isBilling = isCheck;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: isCheck == true ? kBlackColor : kwhiteColor,
                                border: Border.all(color: cBlackColor),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.check,
                                size: 15,
                                color: kwhiteColor,
                              )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Same as billing address',
                              style: TextStyle(
                                color: isCheck == true ? kBlackColor : Colors.black45,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    //Billing Contact info...
                    Visibility(
                      visible: isCheck == false,
                      child: Container(
                        color: kPrimaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Column(
                          children: [
                            RegiTextField(
                              name: 'Contact Number',
                              hint: 'your number..',
                              controller: contactController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: RegiTextField(
                                  name: 'Appartment',
                                  hint: 'your appartment',
                                  controller: appertmentController,
                                )),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: RegiTextField(
                                  name: 'Zip-code',
                                  hint: '125-10',
                                  controller: zipController,
                                )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: RegiTextField(
                                  name: 'House',
                                  hint: '53/A',
                                  controller: houseController,
                                )),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: RegiTextField(
                                  name: 'Road',
                                  hint: '15',
                                  controller: roadController,
                                )),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: RegiTextField(
                                  name: 'Area',
                                  hint: 'Sector-5',
                                  controller: areaController,
                                )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3, bottom: 5),
                                          child: Text(
                                            'City',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 20),
                                          // margin: EdgeInsets.symmetric(
                                          //     horizontal: 20, vertical: 20),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          //margin: EdgeInsets.only(top: 20),
                                          height: 60,
                                          child: Center(
                                            child:
                                                DropdownButtonFormField<String>(
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 25,
                                              ),
                                              decoration:
                                                  InputDecoration.collapsed(
                                                      hintText: ''),
                                              value: cityType,
                                              hint: Text(
                                                'Select City',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black45,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  cityType = newValue;
                                                });
                                              },
                                              validator: (value) =>
                                                  value == null
                                                      ? 'field required'
                                                      : null,
                                              items: _getStorageHub
                                                  .map((String storageValue) {
                                                return DropdownMenuItem(
                                                  value: storageValue,
                                                  child: Text(
                                                    "$storageValue ",
                                                    style: TextStyle(
                                                        color: kBlackColor,
                                                        fontSize: 14),
                                                  ),
                                                  onTap: () {
                                                    // if (storageValue == "BANK") {
                                                    //   setState(() {
                                                    //     // id = 5;
                                                    //     isBank = true;
                                                    //     isMfs = false;
                                                    //     getBankDetails();
                                                    //   });
                                                    // } else {
                                                    //   id = 6;
                                                    //   isBank = false;
                                                    //   isMfs = true;
                                                    //   getMfsDetails();
                                                    // }

                                                    // print(id);
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3, bottom: 5),
                                          child: Text(
                                            'District',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 20),

                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          //margin: EdgeInsets.only(top: 20),
                                          height: 60,
                                          child: Center(
                                            child:
                                                DropdownButtonFormField<String>(
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 25,
                                              ),
                                              decoration:
                                                  InputDecoration.collapsed(
                                                      hintText: ''),
                                              value: districtType,
                                              hint: Text(
                                                'Select District',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black45,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  districtType = newValue;
                                                });
                                              },
                                              validator: (value) =>
                                                  value == null
                                                      ? 'field required'
                                                      : null,
                                              items: _getDistrict
                                                  .map((String storageValue) {
                                                return DropdownMenuItem(
                                                  value: storageValue,
                                                  child: Text(
                                                    "$storageValue ",
                                                    style: TextStyle(
                                                        color: kBlackColor,
                                                        fontSize: 14),
                                                  ),
                                                  onTap: () {
                                                    // if (storageValue == "BANK") {
                                                    //   setState(() {
                                                    //     // id = 5;
                                                    //     isBank = true;
                                                    //     isMfs = false;
                                                    //     getBankDetails();
                                                    //   });
                                                    // } else {
                                                    //   id = 6;
                                                    //   isBank = false;
                                                    //   isMfs = true;
                                                    //   getMfsDetails();
                                                    // }

                                                    // print(id);
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                    //PayMent Catagories...
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isCashPay = !isCashPay;
                                      isCardPay = false;
                                      isBkashPay = false;
                                    });
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 15,
                                          width: 15,
                                          decoration: BoxDecoration(
                                            color: isCashPay
                                                ? kBlackColor
                                                : kwhiteColor,
                                            border:
                                                Border.all(color: cBlackColor),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Center(
                                              child: Icon(
                                            Icons.check,
                                            size: 10,
                                            color: kwhiteColor,
                                          )),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Cash on delivery',
                                          style: TextStyle(
                                            color: isCashPay
                                                ? kBlackColor
                                                : Colors.black45,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isCardPay = !isCardPay;
                                      isCashPay = false;
                                      isBkashPay = false;
                                    });
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 15,
                                          width: 15,
                                          decoration: BoxDecoration(
                                            color: isCardPay
                                                ? kBlackColor
                                                : kwhiteColor,
                                            border:
                                                Border.all(color: cBlackColor),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Center(
                                              child: Icon(
                                            Icons.check,
                                            size: 10,
                                            color: kwhiteColor,
                                          )),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Credit/Debit Card',
                                          style: TextStyle(
                                            color: isCardPay
                                                ? kBlackColor
                                                : Colors.black45,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isBkashPay = !isBkashPay;
                                      isCashPay = false;
                                      isCardPay = false;
                                    });
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 15,
                                          width: 15,
                                          decoration: BoxDecoration(
                                            color: isBkashPay
                                                ? kBlackColor
                                                : kwhiteColor,
                                            border:
                                                Border.all(color: cBlackColor),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Center(
                                              child: Icon(
                                            Icons.check,
                                            size: 10,
                                            color: kwhiteColor,
                                          )),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'bKash',
                                          style: TextStyle(
                                            color: isBkashPay
                                                ? kBlackColor
                                                : Colors.black45,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            //Card Details Section..
                            Visibility(
                              visible: isCardPay,
                              child: Container(
                                child: Column(
                                  children: [
                                    CheckTextField(
                                      hint: 'Card Number',
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: CheckTextField(
                                          hint: "MM/YY",
                                        )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            child: CheckTextField(
                                          hint: "CVC",
                                        )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    //details//
                    Container(
                      color: kPrimaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Delivery Instructions',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AnimatedPadding(
                              padding: EdgeInsets.all(0),
                              duration: Duration(milliseconds: 100),
                              child: TextFormField(
                                maxLines: 5,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // gapPadding: 5.0,
                                    borderSide: BorderSide(
                                        color: hHighlightTextColor, width: 2.5),
                                  ),
                                  hintText: 'Write here',
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'By completing this order, I agree to all ',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'terms & conditions.',
                                  style: TextStyle(
                                    color: hHighlightTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Divider(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Price',
                                  style: TextStyle(
                                      color: hTextColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  '456.00',
                                  style: TextStyle(
                                      color: hTextColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 0),
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
                                  postShipingAddress();
                                  print('place order');
                                  // justTry();
                                  setState(() {
                                    onProgress = true;
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    'Place Order >',
                                    style: fontStyle(
                                        color: hHighlightTextColor, size: 16),
                                  ),
                                ),
                              ),
                            ),
                            // Spacer(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //checkout button....
            // Positioned(
            //   bottom: 5,
            //   left: 2,
            //   right: 2,
            //   child: Container(
            //     margin: EdgeInsets.symmetric(horizontal: 10),
            //     height: 50,
            //     width: MediaQuery.of(context).size.width,
            //     //width: double.infinity,
            //     decoration: BoxDecoration(
            //       color: hBlackColor,
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(10),
            //       ),
            //     ),
            //     child: FlatButton(
            //       onPressed: () {},
            //       child: Center(
            //         child: Text(
            //           'Place Order >',
            //           style: fontStyle(color: hHighlightTextColor, size: 16),
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Container bottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: kPrimaryColor,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            RegiTextField(
              name: 'Contact',
              hint: 'Contact info',
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: RegiTextField(
                  name: 'House',
                  hint: '53/A',
                  controller: houseSheetController,
                )),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: RegiTextField(
                  name: 'Road',
                  hint: '15',
                  controller: roadSheetController,
                )),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: RegiTextField(
                  name: 'Area',
                  hint: 'Sector-5',
                  controller: areaSheetController,
                )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 5),
                          child: Text(
                            'City',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          // margin: EdgeInsets.symmetric(
                          //     horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10.0)),
                          //margin: EdgeInsets.only(top: 20),
                          height: 60,
                          child: Center(
                            child: DropdownButtonFormField<String>(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 25,
                              ),
                              decoration:
                                  InputDecoration.collapsed(hintText: ''),
                              value: cityType,
                              hint: Text(
                                'Select City',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400),
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  cityType = newValue;
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'field required' : null,
                              items: _getStorageHub.map((String storageValue) {
                                return DropdownMenuItem(
                                  value: storageValue,
                                  child: Text(
                                    "$storageValue ",
                                    style: TextStyle(
                                        color: kBlackColor, fontSize: 14),
                                  ),
                                  onTap: () {},
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 5),
                          child: Text(
                            'District',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),

                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10.0)),
                          //margin: EdgeInsets.only(top: 20),
                          height: 60,
                          child: Center(
                            child: DropdownButtonFormField<String>(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 25,
                              ),
                              decoration:
                                  InputDecoration.collapsed(hintText: ''),
                              value: districtType,
                              hint: Text(
                                'Select District',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400),
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  districtType = newValue;
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'field required' : null,
                              items: _getDistrict.map((String storageValue) {
                                return DropdownMenuItem(
                                  value: storageValue,
                                  child: Text(
                                    "$storageValue ",
                                    style: TextStyle(
                                        color: kBlackColor, fontSize: 14),
                                  ),
                                  onTap: () {},
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 0),
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
                },
                child: Center(
                  child: Text(
                    'Confirm',
                    style: fontStyle(color: hHighlightTextColor, size: 16),
                  ),
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
class BottomSheet extends StatefulWidget {
  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  String cityType;
  String districtType;
  List<String> _getStorageHub = ['Dhaka', 'Chittagong'];
  List<String> _getDistrict = ['Cumilla', 'Feni', 'narayngang'];

  TextEditingController houseSheetController = TextEditingController();
  TextEditingController roadSheetController = TextEditingController();
  TextEditingController areaSheetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: kPrimaryColor,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            RegiTextField(
              name: 'Contact',
              hint: 'Contact info',
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: RegiTextField(name: 'House', hint: '53/A',controller: houseSheetController,)),
                SizedBox(
                  width: 5,
                ),
                Expanded(child: RegiTextField(name: 'Road', hint: '15',controller: roadSheetController,)),
                SizedBox(
                  width: 5,
                ),
                Expanded(child: RegiTextField(name: 'Area', hint: 'Sector-5',controller: areaSheetController,)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 5),
                          child: Text(
                            'City',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          // margin: EdgeInsets.symmetric(
                          //     horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10.0)),
                          //margin: EdgeInsets.only(top: 20),
                          height: 60,
                          child: Center(
                            child: DropdownButtonFormField<String>(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 25,
                              ),
                              decoration:
                                  InputDecoration.collapsed(hintText: ''),
                              value: cityType,
                              hint: Text(
                                'Select City',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400),
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  cityType = newValue;
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'field required' : null,
                              items: _getStorageHub.map((String storageValue) {
                                return DropdownMenuItem(
                                  value: storageValue,
                                  child: Text(
                                    "$storageValue ",
                                    style: TextStyle(
                                        color: kBlackColor, fontSize: 14),
                                  ),
                                  onTap: () {},
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 5),
                          child: Text(
                            'District',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),

                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10.0)),
                          //margin: EdgeInsets.only(top: 20),
                          height: 60,
                          child: Center(
                            child: DropdownButtonFormField<String>(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 25,
                              ),
                              decoration:
                                  InputDecoration.collapsed(hintText: ''),
                              value: districtType,
                              hint: Text(
                                'Select District',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400),
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  districtType = newValue;
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'field required' : null,
                              items: _getDistrict.map((String storageValue) {
                                return DropdownMenuItem(
                                  value: storageValue,
                                  child: Text(
                                    "$storageValue ",
                                    style: TextStyle(
                                        color: kBlackColor, fontSize: 14),
                                  ),
                                  onTap: () {},
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 0),
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
                },
                child: Center(
                  child: Text(
                    'Confirm',
                    style: fontStyle(color: hHighlightTextColor, size: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
