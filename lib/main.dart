import 'package:chatapp/helper/helperfunctionsforsharedpreference.dart';
import 'package:chatapp/screens/conversation_screen_ui.dart';
import 'package:chatapp/screens/landing_page_ui.dart';
import 'package:chatapp/screens/login_page_ui.dart';
import 'package:chatapp/screens/signup_page_ui.dart';
import 'package:chatapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/screens/chatroom.dart';
import 'package:chatapp/screens/search.dart';
import 'package:chatapp/screens/user_profile_signup_ui.dart';
import 'package:provider/provider.dart';

import 'models/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunction.getUserLoggedInSharedPreference().then((val){
      isUserLoggedIn = val;
    });
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => ThemeChanger(ThemeData.dark()),
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home:
        AuthService().handleAuth(),
//      isUserLoggedIn ?
//      Scaffold(body: ChatRoom(),)
//          :Scaffold(body: (LandingPage())),
        routes: {
          LoginPage.routeName: (ctx) => LoginPage(),
          SignUpPage.routeName: (ctx) => SignUpPage(),
          ChatRoom.routeName: (ctx) => ChatRoom(),
          SearchPage.routeName: (ctx) => SearchPage(),
          ProfilePageSignUp.routeName: (ctx) => ProfilePageSignUp(),
//        ConversationScreen.routeName: (ctx) => ConversationScreen(""),
      },
      ),
    );
  }
}


//class Blank extends StatefulWidget {
//  @override
//  _BlankState createState() => _BlankState();
//}
//
//class _BlankState extends State<Blank> {
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
