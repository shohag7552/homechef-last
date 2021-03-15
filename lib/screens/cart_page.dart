import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:home_chef/constant.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_chef/screens/checkout_page.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
              child: Container(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return ProductsCard(index: index,);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex:1,
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
                              '-50.00',
                              style: TextStyle(
                                  color: cBlackColor, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
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
                              '15.00',
                              style: TextStyle(
                                  color: cBlackColor, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: hHighlightTextColor, width: 2.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10),),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SvgPicture.asset("assets/voucher.svg"),
                                SizedBox(width: 5,),
                                Text('Apply a voucher')
                              ],
                            ),
                          ),
                        ],
                      ),),
                    ),
                    Divider(),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              'Total Price',
                              style: TextStyle(
                                  color: cBlackColor, fontSize: 14),
                            ),
                            Spacer(),
                            Text(
                              '415.00',
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
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return CheckoutPage();
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

class ProductsCard extends StatelessWidget {
  final int index;
  ProductsCard({this.index});
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
                      image: AssetImage('assets/pizza2.jpg'),
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
                      'Beef Burger',
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
                                onTap: (){},
                                child: SvgPicture.asset('assets/-.svg'),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '2',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: (){},
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
                    '350.00',
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
