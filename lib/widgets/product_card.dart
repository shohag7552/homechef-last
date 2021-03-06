import 'package:flutter/material.dart';
import 'package:home_chef/model/All_items_model.dart';
import 'package:home_chef/provider/CartLength_provider.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final String price, image, name;
  final String disprice;

  ProductCard({this.price, this.disprice, this.image, this.name});

  // final List<Products> products;
  // ProductCard({this.products});
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Items it;

  @override
  void initState() {
    final cartLength = Provider.of<CartLengthProvider>(context, listen: false);
    cartLength.fetchLength(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(
        child: Stack(
          children: [
            /*Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),*/
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),topRight: Radius.circular(5.0)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(this.widget.image ?? ""),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    this.widget.name ?? "",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: Row(
                    children: [
                      Spacer(),
                      Text(
                        '\??? ${this.widget.price ?? ""}',
                        style: TextStyle(color: Colors.black26, fontSize: 10,
                        decoration: TextDecoration.lineThrough),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '\???${this.widget.disprice ?? ""}',
                        style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
