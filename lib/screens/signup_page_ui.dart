import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/helper/helperfunctionsforsharedpreference.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/SignUpPage';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthService authService = new AuthService();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  signMeUp() async {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": usernameEditingController.text,
        "email": emailEditingController.text
      };
      print("$emailEditingController dsfasdgsfdgsfdgsdfgsfgsfg");
      print("$passwordEditingController passssfsdghsdfghsdhsdhf");
      print("$usernameEditingController emallldfgsfgsfgsg");
      setState(() {
        isLoading = true;
      });
      await authService.signUpWithEmailAndPassword(
          emailEditingController.text, passwordEditingController.text
      ).then((value) {
        print("$value");

        dataBaseMethods.uploadUserInfo(userInfoMap);
        HelperFunction.saveUserLoggedInSharedPreference(true);
        HelperFunction.saveUserEmailSharedPreference(emailEditingController.text);
        HelperFunction.saveUserNameSharedPreference(usernameEditingController.text);
        Navigator.pushNamed(context, '/ChatRoom');
      });
    }
  }
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
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator()
        ),
      ) :
      Container(
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
                    'New',
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
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: AutoSizeText(
                    'Account',
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
                            controller: usernameEditingController,
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
                            validator: (val) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                            null : "Enter a valid email",
                            onChanged: (val) {
                              setState(() => email = val);
                            },
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
                            controller: emailEditingController,
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
                              setState(() => password = val);
                            },
                            decoration: const InputDecoration(
                                icon: Icon(Icons.lock, color: Colors.white,),
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
                            controller: passwordEditingController,
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        SizedBox(
                          height: 50.0,
                          width: screenWidth ,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.lock_outline, color: Colors.white,),
                                labelText: 'Confirm Password',
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
                            validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                            controller: passwordEditingController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 80.0,),
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
                        signMeUp();
                        //Navigator.pushNamed(context, '/LoginPage');
                      },
                      child: Center(
                        child: Text(
                          'Sign Up',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
