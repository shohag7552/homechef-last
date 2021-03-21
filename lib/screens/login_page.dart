import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/screens/registration_page.dart';
import 'package:home_chef/server/http_request.dart';
import 'package:home_chef/widgets/login_fild.dart';
import 'package:home_chef/widgets/logintextField.dart';
import 'package:home_chef/widgets/mainPage.dart';
import 'package:home_chef/widgets/registerTextField.dart';
import 'package:home_chef/widgets/spin_kit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Map<String, dynamic> _data = Map<String, dynamic>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email,password;
  SharedPreferences sharedPreferences;
  bool onProgress=false;
  String token;
  bool obser = true;
  Future<String> _submit() async {
    if (mounted) {
      setState(() {
        onProgress = true;
      });
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        if (await getLogin()) {
          emailController.clear();
          passwordController.clear();
          onProgress = false;
         // Navigator.of(context).pushReplacementNamed(MainPage.id);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
            return MainPage();
          }));
          print(":Succcccccccccccccccccccccc");
          return "Logged In";
        } else {
          setState(() {
            onProgress = false;
          });
          return "Incorrect Credentials";
        }
      } else {
        setState(() {
          onProgress = false;
        });
        return "Required email and password";
      }
    }
  }

  Future<bool> getLogin() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      final result = await CustomHttpRequest.login(
          emailController.text.toString(),
          passwordController.text.toString());
      final data = jsonDecode(result);
      print(" the login data are : $data");
      if (data["access_token"] != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
          return MainPage();
        }));

        setState(() {
          sharedPreferences.setString("token", data['access_token']);

        });
        print("save token");
        token = sharedPreferences.getString("token");
        print('token is $token');

        return true;
      } else {
        return false;
      }
    } catch (e) {
      setState(() {
        onProgress = false;
      });
      showInSnackBar("Email or Password  didn't match");
      print("something wrong  $e");
    }
  }

  @override
  void initState() {
    //isLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: ModalProgressHUD(
          inAsyncCall: onProgress,
          opacity: 0.1,
          progressIndicator: Spin(),
          child: Container(
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(

                      color: hHighlightTextColor,
                      width:  MediaQuery.of(context).size.width,
                      height: 220,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1000&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width:  MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.only(top: 30, left: 12, right: 12),
                      child: ListView(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Hay!',
                            style: fontStyle(
                                size: 22,
                                color: hHighlightTextColor,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Get Start with Homechef',
                            style: fontStyle(
                                size: 18,
                                color: hTextColor,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(10),
                          //     ),
                          //     border: Border.
                          //   ),
                          //   child: TextFormField(
                          //     decoration: InputDecoration(),
                          //   ),
                          // )
                          // Text(
                          //   'Email',
                          //   style: fontStyle(
                          //       size: 12,
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.normal),
                          // ),
                          Text(
                            'Email',
                            style: fontStyle(
                                size: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          LoginTextEdit(
                            controller: emailController,
                            hintText: 'Enter your Email Address',
                            icon: Icons.email,
                            function: (value){
                              if (value.isEmpty) {
                                return "*email address required";
                              }
                              if (!value.contains('@')) {
                                return "*wrong email address";
                              }
                              if (!value.contains('.')) {
                                return "*wrong email address";
                              }

                            },

                          ),
                          // SenderTextEdit(
                          //   keyy: "email",
                          //   data: _data,
                          //   controller: email,
                          //   hintText: "Enter your Email Address",
                          //   icon: Icons.email,
                          //   function: (value) {
                          //     if (value.isEmpty) {
                          //       return "*wrong email address";
                          //     }
                          //     if (!value.contains('@')) {
                          //       return "*wrong email address";
                          //     }
                          //     if (!value.contains('.')) {
                          //       return "*wrong email address";
                          //     }
                          //   },
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Password',
                            style: fontStyle(
                                size: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: passwordController,

                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  gapPadding: 5.0,
                                  borderSide:  BorderSide(color: hHighlightTextColor,width: 2.5)),
                              prefixIcon:Icon(Icons.lock_sharp,
                                color: Colors.black54,
                                size: 18,),
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    obser = !obser;
                                  });
                                },
                                child: Icon(
                                  obser?
                                  Icons.visibility:
                                  Icons.visibility_off,color:obser?hHighlightTextColor : Colors.grey,
                                  size: 18,
                                ),
                              ),
                              hintText: 'password',
                            ),
                            obscureText: obser,
                            validator: (value){
                              if(value.isEmpty){
                                return "*please enter password";
                              }
                            },
                          ),
/*
                          LoginTextEdit(
                            keyy: "password",
                            data: _data,
                            controller: passwordController,
                            hintText: "Enter your Password",
                            icon: Icons.lock_sharp,
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  obser = !obser;
                                });
                              },
                              child: Icon(
                                obser?
                                Icons.visibility:
                                Icons.visibility_off,color:obser?hHighlightTextColor : Colors.grey,
                                size: 18,
                              ),
                            ),
                           // obscuretext: obser,
                            *//*function: (value) {
                              if (value.isEmpty) {
                                return "*wrong password";
                              }
                              if (value.length < 3) {
                                return "*wrong password";
                              } else if (value.lengths > 10) {
                                return "*wrong password";
                              }
                            },*//*
                          ),*/

                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            width:  MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                              color: hBlackColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                /*if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                }*/
                                _submit();

                              },
                              child: Center(
                                child: Text(
                                  'Log In',
                                  style: fontStyle(
                                      color: hHighlightTextColor, size: 16),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              'Forgot your Password?',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.black54,
                            endIndent: 98,
                            indent: 98,
                            height: 2,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Text(
                                "Don't have an account?",
                                style: fontStyle(color: Colors.black, size: 16),
                              ),
                              Spacer(),
                              Container(
                                height: 35,
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: hHighlightTextColor, width: 2.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return RegistrationPage();
                                        }));
                                  },
                                  child: Center(
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      )),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void showInSnackBar(String value) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,
    ));
  }
}
