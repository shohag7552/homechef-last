import 'package:flutter/material.dart';
import 'package:home_chef/constant.dart';

class FinalCheckoutPage extends StatefulWidget {
  @override
  _FinalCheckoutPageState createState() => _FinalCheckoutPageState();
}

class _FinalCheckoutPageState extends State<FinalCheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
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
                            child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      //child: Image.asset('assets/pizza.jpg'),
                                      backgroundImage:
                                      AssetImage('assets/pizza.jpg'),
                                      radius: 30,
                                    ),
                                    title: Text(
                                      'Beep Burger',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text('x2'),
                                    trailing: Text(
                                      '150.00',
                                      style: TextStyle(
                                          color: cTextColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
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
                                      ' Nahid Hasan Limon',
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
                                      ' 01648486521',
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
                    onPressed: () {},
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
