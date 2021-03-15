import 'package:flutter/material.dart';
import 'package:home_chef/constant.dart';
import 'package:home_chef/widgets/registerTextField.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  String username, useremail, userpassword, userconfirmpass;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Create your account',
                    style: fontStyle(
                        size: 22,
                        color: hBlackColor,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                                color: hHighlightTextColor, width: 2.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: hBlackColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Add your profile photo',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 10),
                  //   child: Container(
                  //     child: TextFormField(
                  //       controller: name,
                  //       validator: (name) {
                  //         Pattern pattern =
                  //             r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                  //         RegExp regex = new RegExp(pattern);
                  //         if (!regex.hasMatch(name))
                  //           return 'Invalid username';
                  //         else
                  //           return null;
                  //       },
                  //       onSaved: (name) => _username = name,
                  //       textInputAction: TextInputAction.next,
                  //       decoration: InputDecoration(
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(10.0),
                  //           gapPadding: 5.0,
                  //           borderSide: BorderSide(
                  //               color: hHighlightTextColor, width: 2.5),
                  //         ),
                  //         hintText: 'Enter name',
                  //         hintStyle: TextStyle(fontSize: 14),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  RegiTextField(
                    name: 'Your name',
                    hint: 'Enter your name',
                    validator: (value) {
                      if (value.isEmpty) {
                        return "*username already taken";
                      }
                      if (value<3) {
                        return "*username already taken";
                      } else if (value>10) {
                        return "*username already taken";
                      }
                    },
                    onSave: (name) {
                      username = name;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RegiTextField(
                    name: 'Your email',
                    hint: 'Enter your email address',
                    validator: (value) {
                      if (value.isEmpty) {
                        return "*wrong email address";
                      }
                      if (!value.contains('@')) {
                        return "*wrong email address";
                      } else if (!value.contains('.')) {
                        return "*wrong email address";
                      }
                    },
                    onSave: (email) {
                      useremail = email;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RegiTextField(
                    name: 'Your password',
                    hint: 'Enter your password',
                    suffixIcon: Icon(
                      Icons.visibility,
                      size: 18,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "*wrong password";
                      }
                      if (value<3) {
                        return "*wrong password";
                      } else if (value>10) {
                        return "*wrong password";
                      }
                    },
                    onSave: (pass) {
                      userpassword = pass;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RegiTextField(
                    name: 'Confirm your password',
                    hint: 'Enter your password',
                    suffixIcon: Icon(
                      Icons.visibility,
                      size: 18,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "*password doesn't match";
                      }
                      if (value<3) {
                        return "*password doesn't match";
                      } else if (value>10) {
                        return "*password doesn't match";
                      }
                    },
                    onSave: (pass) {
                      userconfirmpass = pass;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                        }
                      },
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: fontStyle(color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Text(
                        "Already have an account?",
                        style: fontStyle(color: Colors.black, size: 16),
                      ),
                      Spacer(),
                      Container(
                        height: 35,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: hHighlightTextColor, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: TextButton(
                          onPressed: () {

                          },
                          child: Center(child: Text('Log In',style: TextStyle(color: hBlackColor),)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
