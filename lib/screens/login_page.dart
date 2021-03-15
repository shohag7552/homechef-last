import 'package:flutter/material.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/screens/registration_page.dart';
import 'package:home_chef/widgets/login_fild.dart';
import 'package:home_chef/widgets/logintextField.dart';
import 'package:home_chef/widgets/registerTextField.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    double width = MediaQuery.of(context).size.width;
    Map<String, dynamic> _data = Map<String, dynamic>();
    TextEditingController email = TextEditingController();

    TextEditingController password = TextEditingController();
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: Container(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Container(

                    color: hHighlightTextColor,
                    width: width,
                    height: 220,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1000&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: width,
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
                          'Welcome!',
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
                        LoginTextField(
                          name: 'Email',
                          hint: 'Enter your Email Address',
                          validator: (value){
                              if (value.isEmpty) {
                                return "*wrong email address";
                                }
                              if (!value.contains('@')) {
                                return "*wrong email address";
                                }
                                if (!value.contains('.')) {
                                return "*wrong email address";
                                }

                          },
                          onSave: (value){
                            email = value;
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

                        SenderTextEdit(
                          keyy: "password",
                          data: _data,
                          controller: password,
                          hintText: "Enter your Password",
                          icon: Icons.lock_sharp,
                          suffixIcon: Icon(
                            Icons.visibility,
                            size: 18,
                          ),
                          function: (value) {
                            if (value.isEmpty) {
                              return "*wrong password";
                            }
                            if (value < 3) {
                              return "*wrong password";
                            } else if (value > 10) {
                              return "*wrong password";
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            color: hBlackColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                              }
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
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
