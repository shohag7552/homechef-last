import 'package:flutter/material.dart';
import 'package:home_chef/constant.dart';


class LoginTextEdit extends StatelessWidget {
  LoginTextEdit(
      {this.icon,
        this.keytype,
        this.lebelText,
        this.keyy,
        this.maxNumber,
        this.controller,
        this.function,
        this.data,
        this.hintText,
        this.initialText,
        this.suffixIcon,
        this.formatter,
        //this.obscuretext,
      });

  final TextEditingController controller;
  final dynamic data;
  final IconData icon;
  final dynamic suffixIcon;
  final String initialText;
  final Function function;
  final String hintText;
  final int maxNumber;
  final String lebelText;
  final dynamic formatter;
  final dynamic keytype;
  //final bool obscuretext;
  final String keyy;

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: EdgeInsets.symmetric( vertical: 10),
      child: TextFormField(
        //showCursor: true,
        minLines: 1,
        maxLines: maxNumber ?? 1 ,
        initialValue: initialText,
        keyboardType: keytype,
        controller: controller,
        inputFormatters: formatter,
        //obscureText: obscuretext,
        validator: function,
        //onSaved: (String value) => data[keyy] = value,
        onChanged: (initialText)=>{

        },
        autofocus: false,
        style: TextStyle(fontSize: 14.0, color: Colors.black54),
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              gapPadding: 5.0,
              borderSide:  BorderSide(color: hHighlightTextColor,width: 2.5)),
          labelText: lebelText,
          suffixIcon: suffixIcon,

          prefixIcon: Icon(
            icon,
            color: Colors.black54,
            size: 18,
          ),
          labelStyle: fontStyle(color: Colors.black54,size: 16),
          hintText: hintText,
        ),
      ),
    );
  }
}