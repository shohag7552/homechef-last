import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/model/profile_model.dart';
import 'package:home_chef/screens/checkout_final_page.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:home_chef/widgets/check_textField.dart';
import 'package:home_chef/widgets/registerTextField.dart';
import 'package:home_chef/widgets/spin_kit.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CheckoutPage extends StatefulWidget {
  double totalPrice;
  CheckoutPage({this.totalPrice});
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  var orderId;

  bool isSameBillingAddress = false;
  bool isCashPay = true;
  bool isCardPay = false;
  bool isBkashPay = false;
  String cityType;
  String sheetCity;
  int payment_id = 2;
  bool onProgress = false;
  String districtType;
  String sheetDistrict;
  List<String> _getStorageHub = ['Dhaka', 'Chittagong'];
  List<String> _getDistrict = ['Cumilla', 'Feni', 'narayngang','Dhanmondi'];

  //black card items...
  String home, house, road, area, district;


  TextEditingController houseSheetController = TextEditingController();
  TextEditingController roadSheetController = TextEditingController();
  TextEditingController areaSheetController = TextEditingController();
  TextEditingController nameSheetController = TextEditingController();
  TextEditingController appartmentSheetController = TextEditingController();
  TextEditingController zipSheetController = TextEditingController();
  TextEditingController emailSheetController = TextEditingController();
  TextEditingController contactSheetController = TextEditingController();

  TextEditingController contactController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController roadController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController districController = TextEditingController();
  TextEditingController appertmentController = TextEditingController();
  TextEditingController zipController = TextEditingController();




  bool isCheck = false;

  bool isBilling = false;
  bool isShipping = false;
  Future billingAdded() async {
    // if (isShipping == true) {
    final uri =
    Uri.parse("https://apihomechef.masudlearn.com/api/update/profile");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequest.getHeaderWithToken());

    request.fields['name'] = nameSheetController.text.toString();
    request.fields['contact'] = contactSheetController.text.toString();
    request.fields['email'] = emailSheetController.text.toString();
    request.fields['appartment'] = appartmentSheetController.text.toString();
    request.fields['zip_code'] = zipSheetController.text.toString();
    request.fields['house'] = houseSheetController.text.toString();
    request.fields['road'] = roadSheetController.text.toString();
    request.fields['area'] = areaSheetController.text.toString();
    request.fields['area'] = areaSheetController.text.toString();
    request.fields['city'] = sheetCity.toString();
    request.fields['district'] = sheetDistrict.toString();

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    setState(() {
      Navigator.pop(context);
      showInToast(responseString);
    });
    print("responseBody " + responseString);

    if (response.statusCode == 201) {
      print("responseBody1 " + responseString);
      var data = jsonDecode(responseString);
      print('oooooooooooooooooooo');
      print(data);


      setState(() {
        onProgress = false;
      });
    } else {
      setState(() {
        onProgress = false;
      });

      var errorr = jsonDecode(responseString.trim().toString());
      // showInSnackBar("Registered Failed, ${errorr}");
      print("profile update failed " + errorr);
    }
  }

  Future postShipingAddress() async {
      final uri = Uri.parse("https://apihomechef.masudlearn.com/api/place/order");
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(await CustomHttpRequest.getHeaderWithToken());

      request.fields['payment_type_id'] = payment_id.toString();


      if(isSameBillingAddress){
        request.fields['shipping_address'] = 'same';
        request.fields['area'] = profile.billingAddress.area ?? "area";
        request.fields['contact'] = profile.billingAddress.contact ?? "area";
        request.fields['appartment'] = profile.billingAddress.appartment ?? "appartment";
        request.fields['house'] = profile.billingAddress.house ?? "house";
        request.fields['road'] = profile.billingAddress.road ?? "road";
        request.fields['city'] = profile.billingAddress.city ?? "city";
        request.fields['district'] = profile.billingAddress.district ?? "district";
        request.fields['zip_code'] = profile.billingAddress.zipCode ?? "zip_code";
      }
      else {
        request.fields['shipping_area'] = areaController.text.toString();
        request.fields['shipping_contact'] = contactController.text.toString();
        request.fields['shipping_appartment'] = appertmentController.text.toString();
        request.fields['shipping_zip_code'] = zipController.text.toString();
        request.fields['shipping_house'] = houseController.text.toString();
        request.fields['shipping_road'] = roadController.text.toString();
        request.fields['shipping_city'] = cityType.toString();
        // print('shipping city added to city :${cityType.toString()} ');
        request.fields['shipping_district'] = districtType.toString();

      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print("responseBody " + responseString);
      if (response.statusCode == 201) {
        print("responseBody1 " + responseString);
        var data = jsonDecode(responseString);
        print('oooooooooooooooooooo');
        print(data);
        showInToast(responseString);

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
          showInToast('please fill the shipping address');
        }

        setState(() {
          onProgress = false;
        });
      } else {
        setState(() {
          onProgress = false;
        });

        var errorr = jsonDecode(responseString.trim().toString());
        print("Registered failed " + errorr);
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
  Profile profile ;
  String proHouseNumber;
  String proRoadNumber;
  String proName;
  String proEmail;
  String proContact;
  String proArea;
  String proAppertment;
  String proZip;

  Future<dynamic> fetchProfile() async {
    final data = await CustomHttpRequest.getProfile();

    print("User data are $data");
    profile = Profile.fromJson(data);
    if(mounted){
      setState(() {
        proHouseNumber = profile.billingAddress.house.toString();
        proRoadNumber = profile.billingAddress.road.toString();
        proName = profile.name.toString();
        proEmail = profile.email.toString();
        proContact =profile.contact.toString();
        proArea =profile.billingAddress.area.toString();
        proAppertment =profile.billingAddress.appartment.toString();
        proZip =profile.billingAddress.zipCode.toString();
      });
    }
    nameSheetController.text = proName;
    houseSheetController.text =proHouseNumber;
    roadSheetController.text =proRoadNumber;
    emailSheetController.text =proEmail;
    contactSheetController.text =proContact;
    areaSheetController.text = proArea;
    appartmentSheetController.text = proAppertment;
    zipSheetController.text = proZip;
    sheetDistrict = profile.billingAddress.district.toString();

  }

  @override
  void initState() {
    fetchProfile();

    super.initState();
  }
  @override
  void dispose() {
    houseSheetController.dispose();
    roadSheetController.dispose();
    areaSheetController.dispose();
    nameSheetController.dispose();
    appartmentSheetController.dispose();
    zipSheetController.dispose();
    emailSheetController.dispose();
    contactSheetController.dispose();

    contactController.dispose();
    houseController.dispose();
    roadController.dispose();
    areaController.dispose();
    cityController.dispose();
    districController.dispose();
    appertmentController.dispose();
    zipController.dispose();


    super.dispose();
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
        body: ModalProgressHUD(
          inAsyncCall: onProgress,
          opacity: 0.1,
          progressIndicator: Spin(),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
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
                                        'House',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(0.5)),
                                      ),
                                      SizedBox(height: 3,),
                                      Visibility(
                                        visible: profile != null && profile.billingAddress.house != null,
                                        child: Row(
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
                                              '$sheetDistrict',
                                              style: TextStyle(
                                                  color: cBackgroundColor,
                                                  fontSize: 16),
                                            )
                                          ],
                                        ),
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
                            // isCheck = !isCheck;
                            // isShipping = !isCheck;
                            // isBilling = isCheck;
                            isSameBillingAddress = !isSameBillingAddress;
                          });
                          if(isSameBillingAddress && profile.billingAddress.house == null){

                            Future<void> future = showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return bottomSheet(context);
                                });
                            future.then((void value){
                              if(isSameBillingAddress && profile.billingAddress.house == null){
                                setState(() {
                                  isSameBillingAddress = false;
                                  fetchProfile();
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: isSameBillingAddress ? kBlackColor : kwhiteColor,
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
                                  color: isSameBillingAddress ? kBlackColor : Colors.black45,
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
                        visible: !isSameBillingAddress,
                        child: Container(
                          color: kPrimaryColor,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          child: Column(
                            children: [
                              RegiTextField(
                                name: 'Contact Number',
                                hint: '018..',
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
                                    "\৳ ${widget.totalPrice}",
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
            ],
          ),
        ),
      ),
    );
  }

  Container bottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: kPrimaryColor,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Create Billing Address',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
            SizedBox(
              height: 10,
            ),
            RegiTextField(
              name: 'contact',
              hint: 'contact number',
              controller: contactSheetController,

            ),
            Row(
              children: [
                Expanded(
                  child: RegiTextField(
                    name: 'name',
                    hint: 'your name',
                    controller: nameSheetController,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: RegiTextField(
                      name: 'Email',
                      hint: 'your email',
                      controller: emailSheetController,
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
                      name: 'Appartment',
                      hint: 'your appartment',
                      controller: appartmentSheetController,
                    )),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: RegiTextField(
                      name: 'Zip-code',
                      hint: '125-10',
                      controller: zipSheetController,
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
                              value: sheetCity,
                              hint: Text(
                                'Select City',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400),
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  sheetCity = newValue;
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
                              value: sheetDistrict,
                              hint: Text(
                                'Select District',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400),
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  sheetDistrict = newValue;
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

                  billingAdded();
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
