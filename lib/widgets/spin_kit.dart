import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_chef/constant.dart';


class Spin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
      itemBuilder:
          (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven
                ? hHighlightTextColor
                : hHighlightTextColor2,
          ),
        );
      },
    );
  }
}