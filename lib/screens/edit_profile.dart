import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:home_chef/widgets/mainPage.dart';
import 'package:home_chef/widgets/registerTextField.dart';
import 'package:home_chef/widgets/spin_kit.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
class ProfileUpdate extends StatefulWidget {
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {


  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController roadController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  String name,email,contact,house,road,area,city,district;


  bool onProgress = false;
  Future profileUpdate() async {
    // if (isShipping == true) {
    final uri =
    Uri.parse("https://apihomechef.masudlearn.com/api/update/profile");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequest.getHeaderWithToken());
    request.fields['name'] = nameController.text.toString();
    request.fields['email'] = emailController.text.toString();
    request.fields['contact'] = contactController.text.toString();
    request.fields['house'] = houseController.text.toString();
    request.fields['road'] = roadController.text.toString();
    request.fields['area'] = area.toString();
    request.fields['city'] = cityController.text.toString();
    request.fields['district'] = districtController.text.toString();

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responseBody " + responseString);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return MainPage();
    }));
    if (response.statusCode == 201) {
      print("responseBody1 " + responseString);
      var data = jsonDecode(responseString);
      print('oooooooooooooooooooo');
      print(data);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return MainPage();
      }));

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
      print("profile update failed " + errorr);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(

          child: ModalProgressHUD(
            inAsyncCall: onProgress,
            opacity: 0.1,
            progressIndicator: Spin(),
            child: Column(
              children: [
                Text("Profile Update",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                SizedBox(height: 20,),
                RegiTextField(
                  name: "Your Name",
                  hint: 'name..',
                  controller: nameController,
                  onSave: (String value){
                    name = value;
                  },
                ),
                SizedBox(height: 10,),
                RegiTextField(
                  name: "Your Email",
                  hint: 'email..',
                  controller: emailController,
                  onSave: (String value){
                    email = value;
                  },
                ),
                SizedBox(height: 10,),
                RegiTextField(
                  name: "Your Contact Number",
                  hint: 'number..',
                  controller: contactController,
                  onSave: (String value){
                    contact = value;
                  },
                  validator: ( value) {
                    if (value.isEmpty) {
                      return "*user contact required";
                    }
                    if (value.length < 3) {
                      return "*please write more then 3 word";
                    } else if (value.length > 11) {
                      return "*please write valid contact";
                    }
                  },
                ),
                SizedBox(height: 10,),
                RegiTextField(
                  name: "House",
                  hint: 'House number..',
                  controller: houseController,
                  onSave: (String value){
                    house = value;
                  },
                ),
                SizedBox(height: 10,),
                RegiTextField(
                  name: "Road",
                  hint: 'Road number..',
                  controller: roadController,
                  onSave: (String value){
                    road = value;
                  },
                ),
                SizedBox(height: 10,),
                RegiTextField(
                  name: "Area",
                  hint: 'Area..',
                  controller: areaController,
                  onSave: (String value){
                    area = value;
                  },
                ),
                SizedBox(height: 10,),
                RegiTextField(
                  name: "Your City",
                  hint: 'City..',
                  controller: cityController,
                  onSave: (String value){
                    city = value;
                  },
                ),
                SizedBox(height: 10,),
                RegiTextField(
                  name: "Your District",
                  hint: 'District..',
                  controller: districtController,
                  onSave: (String value){
                    district = value;
                  },
                ),
                SizedBox(height: 20,),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: hBlackColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // if (_formKey.currentState.validate()) {
                      //   _formKey.currentState.save();
                      //   getRegister(context);
                      // }
                      profileUpdate();

                      print('clicked');
                    },
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: fontStyle(color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));

  }
}
