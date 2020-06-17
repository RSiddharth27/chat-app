import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctionsforsharedpreference.dart';
import 'package:chatapp/models/theme.dart';
import 'package:chatapp/screens/conversation_screen_ui.dart';
import 'package:chatapp/screens/landing_page_ui.dart';
import 'package:chatapp/screens/search.dart';
import 'package:chatapp/screens/splashscreen.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  static const routeName = '/ChatRoom';
  bool dark;
  ChatRoom({this.dark});
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                userName: snapshot.data.documents[index].data['chatRoomId']
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
              );
            }

            )
            : Container();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunction.getUserNameSharedPreference();
    DataBaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LandingPage()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)
            ),
          ),
//          GestureDetector(
//            onTap: () {
//
//            },
//            child: Container(
//              child: Switch(
//              onChanged: toggleSwitch ,
//              value: switchControl,
//              activeColor: Colors.blue,
//              activeTrackColor: Colors.green,
//              inactiveThumbColor: Colors.white,
//              inactiveTrackColor: Colors.grey,
//              ),
//          )
//          ),
        ],
        leading: Container(),
        backgroundColor: Colors.black54,
        title: AutoSizeText(
          'Chats',
          maxLines: 1,
        ),
        titleSpacing: 10,
        primary: true,
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage()));
        },
      ),
    );

  }
  bool switchControl = false;

  var textHolder = 'Switch is OFF';

  void toggleSwitch(bool value) {

    if(switchControl == false)
    {
      setState(() {
        switchControl = true;
        textHolder = 'Switch is ON';
      });
      print('Switch is ON');
      // Put your code here which you want to execute on Switch ON event.

    }
    else
    {
      setState(() {
        switchControl = false;
        textHolder = 'Switch is OFF';
        widget.dark = false;
      });
      print('Switch is OFF');
      // Put your code here which you want to execute on Switch OFF event.
    }
  }

}
class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(
              chatRoomId, userName
          )
      )),
      onLongPress: ()
      {
        AlertDialog(
          title: Text('nothing here'),
          content: Text('Play somewhere else'),
        );
      },
      child: Card(
        borderOnForeground: true,
        semanticContainer: true,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        shadowColor: Colors.black,
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => ConversationScreen(
                  chatRoomId, userName
                )
            ));
          },
          child: Container(
//            color: Colors.black26,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text(userName.substring(0, 1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)),
                ),
                SizedBox(
                  width: 12,
                ),
                AutoSizeText(
                    userName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300),
                  maxFontSize: 16,
                  maxLines: 1,
                  minFontSize: 10,
                ),
              ],
            ),
          ),
//          child: ListView.builder(
//            itemCount: 1,
//            itemBuilder: (context, index){
//
//            },
//          ),
        ),
      ),
    );
  }
}