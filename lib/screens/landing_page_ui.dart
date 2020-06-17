import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/screens/login_page_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    print(screenHeight);
    return Scaffold(
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
           child: SafeArea(
             child: SingleChildScrollView(
               padding: EdgeInsets.fromLTRB(
                 screenWidth * 0.15,
                 0.0,
                 screenWidth * 0.15,
                 screenHeight * 0.1,
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start  ,
                 children: <Widget>[
                   Container(
                     padding: EdgeInsets.only(top: 50.0),
                     child: Image.asset(
                       'assets/images/icons1.png',
                       height: 100.0,
                       width: 100.0,
                       fit: BoxFit.cover,
                       semanticLabel: 'icon',
                     ),
                   ),
                   Container(
                     child: Stack(
                       children: <Widget>[
                         Container(
                           padding: EdgeInsets.fromLTRB(0.0, screenHeight * 0.1, 0.0, 0.0),
                           child: AutoSizeText(
                             'Welcome',
                             style: TextStyle(
                               fontSize: 50.0,
                               fontWeight: FontWeight.normal,
                               fontFamily: 'Raleway',
                               color: Colors.cyanAccent,
                               letterSpacing: 3.0,
                             ),
                             maxLines: 1,
                             maxFontSize: 60.0,
                           ),
                         ),
                         Container(
                           padding: EdgeInsets.fromLTRB(0.0, screenHeight * 0.17, 0.0, 0.0),
                           child: AutoSizeText(
                             'to',
                             style: TextStyle(
                                 fontSize: 60.0,
                                 fontWeight: FontWeight.normal,
                               fontFamily: 'Raleway',
                               color: Colors.cyanAccent,
                               letterSpacing: 3.0,
                             ),
                             maxLines: 1,
                             maxFontSize: 60.0,
                           ),
                         ),
                         Container(
                           padding: EdgeInsets.fromLTRB(0.0, screenHeight * 0.24, 0.0, 0.0),
                           child: AutoSizeText(
                             '...',
                             style: TextStyle(
                                 fontSize: 60.0,
                                 fontWeight: FontWeight.bold,
                               fontFamily: 'Raleway',
                               color: Colors.cyanAccent,
                               letterSpacing: 3.0,
                             ),
                             maxLines: 1,
                             maxFontSize: 60.0,
                           ),
                         ),
                       ],
                     ),
                   ),
                   SizedBox(height: screenHeight * 0.24,),
                   SizedBox(
                     height: 50.0,
                     width: screenWidth ,
                     child: Material(
                       borderRadius: BorderRadius.circular(20.0),
                       color: Colors.black,
                       shadowColor: Colors.black,
                       elevation: 7.0,
                       child: RaisedButton(
                         color: Colors.black45 ,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(22.0),
                           side: BorderSide(color: Colors.red),
                         ),
                         elevation: 7.0,
                         onPressed: (){

                           Navigator.pushNamed(context, '/LoginPage');
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
//                 SizedBox(height: screenHeight * 0.02,),
                   Container(
                     padding: EdgeInsets.only(top: 25.0, left: 10.0),
                     child: Text(
                       'Don\'t have an account ?',
                       style: TextStyle(
                         fontSize: 14.0,
                         fontWeight: FontWeight.normal,
                         fontFamily: 'Raleway',
                         color: Colors.lightGreen
                       ),
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(top: 0.0, left: 10.0),
                     child: InkWell(
                       child: Text(
                         'Sign up here',
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
             ),
           ),
         ),
       );

  }
}
