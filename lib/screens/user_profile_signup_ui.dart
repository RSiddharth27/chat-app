import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProfilePageSignUp extends StatefulWidget {
  static const routeName  = '/ProfilePageSignUp';
  @override
  _ProfilePageSignUpState createState() => _ProfilePageSignUpState();
}

class _ProfilePageSignUpState extends State<ProfilePageSignUp> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    String email = '';
    String password = '';
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (){
            setState(() {

            });
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
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, screenHeight * 0.2, 0.0, 0.0),
                  child: AutoSizeText(
                    'User Name',
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
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50.0,
                          width: screenWidth ,
                          child: TextFormField(
                            validator: (val) => val.length > 6 ?
                            null : "Enter a valid userName",
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                            decoration: const InputDecoration(
                                icon: Icon(Icons.person, color: Colors.white,),
                                labelText: 'User Name',
                                labelStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.cyan),
                                )
                            ),
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontFamily: 'Raleway',
                            ),
                            //controller: emailEditingController,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
