import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/model/profile_model.dart';
import 'package:home_chef/provider/Profile_provider.dart';
import 'package:home_chef/screens/edit_profile.dart';
import 'package:home_chef/screens/login_page.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:home_chef/widgets/registerTextField.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Profile profile;

  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confPassController = TextEditingController();

  Future changePassword(BuildContext context) async{

    final uri = Uri.parse("https://apihomechef.masudlearn.com/api/update/password");
    var request = http.MultipartRequest("POST",uri);
    request.headers.addAll(await CustomHttpRequest.getHeaderWithToken());
    //old_password,password,  password_confirmation
    request.fields['old_password'] = oldPassController.text.toString();
    request.fields['password'] = newPassController.text.toString();
    request.fields['password_confirmation'] = confPassController.text.toString();

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    print("responseBody " + responseString);
    SharedPreferences preferences =
    await SharedPreferences.getInstance();
    await preferences.remove('token');

    print(response.statusCode);
    if (response.statusCode == 200) {
      print("responseBody1 " + responseString);
      print('successfully changed password...');
      var data = jsonDecode(responseString);
      //showInSnackBar("$responseString");
      showInToast(data['message']);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
    }
    else{
     /* setState(() {
        onProgress = false;
      });*/
      showInToast('Something wrong');
      var errorr = jsonDecode(responseString.trim().toString());
      print('Did not changed password...');
     // showInSnackBar("Registered Failed, ${errorr}");
      print("Registered failed " + responseString);

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
  /*final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,
    ));
  }*/
  canStay() async{
    SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    String token = sharedPreferences.getString("token");
    print(token);
    if (token == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    }
  }

  @override
  void initState() {
    canStay();
    loadProfileData();
    super.initState();
  }

  loadProfileData() async {
    print("expenditure entries are");
    final data = await Provider.of<ProfileProvider>(context, listen: false)
        .fetchProfile(context);
    print("aaaaaaaaaaaaaaaa${data}");
  }

  createAlertDialogue(BuildContext context){
    return showDialog(context: context, builder: (context){
      return Dialog(
        child: Container(
          height: 200,
          width: 300,
          color: Colors.green,
          child: Text('hello'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    profile = Provider.of<ProfileProvider>(context).profile;
    // print(profile.email.toString());
    final _formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          title: Text('Your Profile'),
          actions: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileUpdate();
                  }));
                })
          ],
        ),
        body: Container(
          child: Center(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: hHighlightTextColor, width: 2.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: hBlackColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://homechef.masudlearn.com/avatar/${profile != null ? profile.image.toString() : ''}",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Name : ${profile != null ? profile.name : ''}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Email : ${profile != null ? profile.email : ""}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Contact : ${profile != null ? profile.contact : ''}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),

                TextButton(onPressed: (){
                  showDialog(context: context, builder: (context){
                    return Dialog(
                      child: Form(
                        key: _formKey,
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.5,
                          width: MediaQuery.of(context).size.width*0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Text('Change Password',style: TextStyle(
                                  fontSize: 16,
                                  color: hHighlightTextColor,
                                  fontWeight: FontWeight.w600
                                ),),
                                SizedBox(height: 10,),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'old password..',
                                      //labelText: 'old password'
                                    ),
                                    controller: oldPassController,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return '*please write old password';
                                      }
                                    },
                                  ),
                                  /*child: RegiTextField(
                                    name: 'Old password',
                                    hint: 'write old password',
                                    controller: oldPassController,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return '*please enter old password';
                                      }
                                    },
                                  ),*/
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'new password..',
                                      //labelText: 'new password'
                                    ),
                                    controller: newPassController,
                                    validator: (value){
                                      if (value.isEmpty) {
                                        return "*Password is empty";
                                      }
                                      if (value.length < 3) {
                                        return "*Password is too short";
                                      }
                                      if (value.length > 15) {
                                        return "*Password not contains more then 15 carecters";
                                      }
                                    },
                                  ),
                                 /* child: RegiTextField(
                                    name: 'New password',
                                    hint: 'write new password',
                                    controller: newPassController,
                                    validator: (value){
                                      if (value.isEmpty) {
                                        return "*Password is empty";
                                      }
                                      if (value.length < 3) {
                                        return "*Password is too short";
                                      }
                                      if (value.length > 15) {
                                        return "*Password not contains more then 10 carecters";
                                      }
                                    },
                                  ),*/
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'confirm password..',
                                     // labelText: 'confirm password..'
                                    ),
                                    controller: confPassController,
                                    validator: (value){
                                      if (value.isEmpty) {
                                        return "Confirm Password required ";
                                      }
                                      if (value.length < 6) {
                                        return "Password Too Short";
                                      }
                                      if (value.length > 15) {
                                        return "Password Too long ( 6 - 15 character )";
                                      }
                                      if (newPassController.text !=
                                          confPassController.text) {
                                        return "Password do not match";
                                      }
                                    },
                                  ),
                                  /*child: RegiTextField(
                                    name: 'Confirm password',
                                    hint: 'write confirm password',
                                    controller: confPassController,
                                    validator: (value){
                                      if (value.isEmpty) {
                                        return "Confirm Password required ";
                                      }
                                      if (value.length < 6) {
                                        return "Password Too Short";
                                      }
                                      if (value.length > 15) {
                                        return "Password Too long ( 6 - 15 character )";
                                      }
                                      if (newPassController.text !=
                                          confPassController.text) {
                                        return "Password do not match";
                                      }
                                    },
                                  ),*/
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  height: 50,
                                  width:  MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    color: hBlackColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: TextButton(onPressed: (){
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                     // getRegister(context);
                                      changePassword(context);
                                    }
                                  },
                                      child: Center(
                                    child: Text('Confirm',style: fontStyle(
                                        color: hHighlightTextColor, size: 16),
                                    ),
                                  )),
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });

                }, child: Container(
                  child: Text('Change account password'),
                )

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
