import 'package:flutter/material.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/screens/checkout_final_page.dart';
import 'package:home_chef/widgets/check_textField.dart';
import 'package:home_chef/widgets/registerTextField.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isCheck = false;
  bool showBill = true;
  bool isCashPay = true;
  bool isCardPay = false;
  bool isBkashPay = false;
  String cityType;
  String districtType;
  List<String> _getStorageHub = ['Dhaka', 'Chittagong'];
  List<String> _getDistrict = ['Cumilla', 'Feni', 'narayngang'];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            onPressed: () {},
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
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.5)),
                                    ),
                                    Text(
                                      '625 St Marks Ave',
                                      style: TextStyle(
                                          color: cBackgroundColor,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return BottomSheet();
                                      });
                                },
                                child: Text(
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
                          showBill = !isCheck;
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
                                color: isCheck ? kBlackColor : kwhiteColor,
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
                                color: isCheck ? kBlackColor : Colors.black45,
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
                      visible: showBill,
                      child: Container(
                        color: kPrimaryColor,
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Column(
                          children: [
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
                                        name: 'House', hint: '53/A')),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: RegiTextField(
                                        name: 'Road', hint: '15')),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: RegiTextField(
                                        name: 'Area', hint: 'Sector-5')),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return FinalCheckoutPage();
                                    }),
                                  );
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
}

class BottomSheet extends StatefulWidget {
  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  String cityType;
  String districtType;
  List<String> _getStorageHub = ['Dhaka', 'Chittagong'];
  List<String> _getDistrict = ['Cumilla', 'Feni', 'narayngang'];
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
                Expanded(child: RegiTextField(name: 'House', hint: '53/A')),
                SizedBox(
                  width: 5,
                ),
                Expanded(child: RegiTextField(name: 'Road', hint: '15')),
                SizedBox(
                  width: 5,
                ),
                Expanded(child: RegiTextField(name: 'Area', hint: 'Sector-5')),
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
