import 'dart:async';

import 'package:chatapp/main.dart';
import 'package:chatapp/screens/landing_page_ui.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTime() async{
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
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
//        child: new Image.asset('assets/images/bg5.jpeg'),
      ),
    );
  }
}
