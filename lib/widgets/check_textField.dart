import 'package:flutter/material.dart';
import 'package:home_chef/constant.dart';

class CheckTextField extends StatelessWidget {
  final String hint;
  CheckTextField({this.hint});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            gapPadding: 5.0,
            borderSide: BorderSide(color: hHighlightTextColor, width: 2.5),
          ),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14)),
    );
  }
}
