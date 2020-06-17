// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/helper/helperfunctionsforsharedpreference.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/LoginPage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  AuthService authService = new AuthService();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn(){
    if (formKey.currentState.validate()) {
      HelperFunction.saveUserEmailSharedPreference(emailEditingController.text);
      dataBaseMethods.getUserByUserEmail(emailEditingController.text)
          .then((val){
        snapshotUserInfo = val;
        HelperFunction
            .saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
        print("${snapshotUserInfo.documents[0].data["name"]} sdfgsdfgdsfggsdhgfdghgfhsdfgsdhdghdghdfghdfghdfh");
      });

      setState(() {
        isLoading = true;
      });

      authService.signInWithEmailAndPassword(emailEditingController.text, passwordEditingController.text).then((val){
        if(val != null) {
          HelperFunction.saveUserLoggedInSharedPreference(true);
          Navigator.pushNamed(context, "/ChatRoom");
        }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
        extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/bg5.jpeg',
              ),
              fit: BoxFit.cover,
            )
        ),
        child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.15,
              0.0,
              screenWidth * 0.15,
              screenHeight * 0.1,
            ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, screenHeight * 0.2, 0.0, 0.0),
                  child: AutoSizeText(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      letterSpacing: 3.0,
                    ),
                    maxLines: 1,
                    maxFontSize: 60.0,
                  ),
                ),
                SizedBox(height: 100.0,),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50.0,
                        width: screenWidth ,
                        child: TextFormField(
                          validator: (val) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Enter a valid email",
                          onChanged: (val) {
                            String email;
                            setState(() => email = val);
                          },
                          controller: emailEditingController,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.person_outline, color: Colors.white,),
                              labelText: 'Email Id',
                              labelStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              )
                          ),
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'Raleway',
                          ),
                          inputFormatters: [BlacklistingTextInputFormatter(
                              new RegExp(r"\s\b|\b\s")
                          )],
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      SizedBox(
                        height: 50.0,
                        width: screenWidth ,
                        child: TextFormField(
                          validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                          onChanged: (val) {
                            String password;
                            setState(() => password = val);
                          },
                          controller: passwordEditingController,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.lock_outline, color: Colors.white,),
                              labelText: 'Password',
                              labelStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              )
                          ),
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'Raleway',
                          ),
                          obscureText: true,
                          inputFormatters: [BlacklistingTextInputFormatter(
                              new RegExp(r"\s\b|\b\s")
                          )],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100.0,),
                SizedBox(
                  height: 60.0,
                  width: screenWidth ,
                  child: Material(
                    borderRadius: BorderRadius.circular(24.0),
                    color: Colors.black,
                    shadowColor: Colors.black,
                    elevation: 7.0,
                    child: RaisedButton(
                      color: Colors.black45 ,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        side: BorderSide(color: Colors.red),
                      ),
                      elevation: 7.0,
                      onPressed: (){
                        //Navigator.pushNamed(context, '/LoginPage');
                        signIn();
                      },
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Raleway',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 25.0, left: 70.0),
                      child: Text(
                        'New here ?',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Raleway',
                            color: Colors.lightGreen
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 25.0, left: 10.0),
                      child: InkWell(
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                              color: Colors.white
                          ),
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/SignUpPage');
                        },
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      )
    );
  }
}
