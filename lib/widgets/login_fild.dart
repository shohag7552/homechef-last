import 'package:flutter/material.dart';
import 'package:home_chef/constant.dart';

class LoginTextField extends StatelessWidget {
  final String name, hint;
  final dynamic controller;
  final dynamic suffixIcon;
  final Function validator;
  final Function onSave;
  LoginTextField({this.name,this.controller, this.hint, this.suffixIcon,this.validator,this.onSave});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3,bottom: 0),
          child: Text(
            name,
            style: fontStyle(
                size: 12,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            //height: 50,
            child: TextFormField(
              controller: controller,
              validator: validator,
              onSaved: onSave,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  gapPadding: 5.0,
                  borderSide:
                  BorderSide(color: hHighlightTextColor, width: 2.5),
                ),
                hintText: hint,
                hintStyle: TextStyle(fontSize: 14),
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        )
      ],
    );
  }
}
