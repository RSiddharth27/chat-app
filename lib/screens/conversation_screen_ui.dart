import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/screens/chatroom.dart';
import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

Map<String, dynamic> chatMessageMap1 = {};
String chatRoomid ;
class ConversationScreen extends StatefulWidget {

  static const routeName = '/ConversationScreen';
  final String chatRoomId;
  final String usename;
  ConversationScreen(this.chatRoomId, this.usename);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageEditingController = new TextEditingController();

  Stream<QuerySnapshot> chats;
  Widget chatMessages(){
    DateTime now = DateTime.now();
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return
                MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],

              );
            },
            reverse: true,
          shrinkWrap: true,
            ) :
        Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };
      chatMessageMap1 = chatMessageMap;
      DataBaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }
  @override
  void initState() {
    chatRoomid = widget.chatRoomId;
    DataBaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  showDialogue() {
    context : context;
    // ignore: unnecessary_statements
    builder : (BuildContext context){
      return AlertDialog(
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    };
    Container(
      height: 40,
      width: 120,
      constraints: BoxConstraints(maxWidth: 95, maxHeight: 40),
//      child: Button(text: "Yes", onPressed: onPressed),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usename),
        actions: <Widget>[
          IconButton(
            icon : Icon(Icons.delete),
            onPressed: ()
              {
              Firestore.instance.collection('chatRoom').document(widget.chatRoomId).collection('chats').getDocuments().then((value){
                        for(DocumentSnapshot doc in value.documents){
                          doc.reference.delete();
                        }
                      });
              }
//              AlertDialog(
//                title: Text('Are you sure you want to delete? \n '
//                    'The deleted message cant be retrieved and these messages will be deleted on you friends account too :)'),
//                actions: <Widget>[
//                  RaisedButton(
//                    child: Text('Yes'),
//                    onPressed: () {
//                      Firestore.instance.collection('chatRoom').document(widget.chatRoomId).collection('chats').getDocuments().then((value){
//                        for(DocumentSnapshot doc in value.documents){
//                          doc.reference.delete();
//                        }
//                      });
//                    },
//                  ),
//                  RaisedButton(
//                    child: Text('No'),
//                  )
//                ],
//                backgroundColor: Colors.black,
//              );


          )
        ],
        elevation: 5.0,
      ),
    body: Container(
      color: Colors.white70,
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(bottom: 80),
              child: chatMessages()
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.98,
            padding: EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 60,
              child: Material(
                borderRadius: BorderRadius.circular(80.0),
                color: Colors.grey[200],
                shadowColor: Colors.grey,
                elevation: 7.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  color: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.newline,
                            controller: messageEditingController,
//                          style: simpleTextStyle(),
                            decoration: InputDecoration(
                                hintText: "Type a message",
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                                border: InputBorder.none

                            ),
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          )
                      ),
                      SizedBox(width: 16,),
                      GestureDetector(
                        onTap: () {
                          addMessage();
                        },
                        child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
//                                gradient: LinearGradient(
//                                    colors: [
//                                      const Color(0x36FFFFFF),
//                                      const Color(0x0FFFFFFF)
//                                    ],
//                                    begin: FractionalOffset.topLeft,
//                                    end: FractionalOffset.bottomRight
//                                ),

                                borderRadius: BorderRadius.circular(40)
                            ),
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(
                                Icons.send,
                            color: Colors.black,),
//                        child: Image.asset("assets/images/send.png",
//                          height: 25, width: 25,)),
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 100,),
        ],
      ),
    ),


    );
  }
}
class MessageTile extends StatefulWidget {
  final String message;
  final bool sendByMe ;
  MessageTile({@required this.message, @required this.sendByMe});

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var initsettings = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initsettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload){
    debugPrint("payload $payload");
    Navigator.pushNamed(context, "/ConversationScreen");
  }

  @override
  Widget build(BuildContext context) {
    var now = Firestore.instance
        .collection("chatRoom")
        .document(chatRoomid)
        .collection("chats")
        .document("HLMQHAco4zHKzzUbaVrf")
        .collection("time");

    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: widget.sendByMe ? 0 : 24,
          right: widget.sendByMe ? 24 : 0),
      alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: widget.sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
//            gradient: LinearGradient(
//              colors: widget.sendByMe ? [
//                const Color(0xff007EF4),
//                const Color(0xff2A75BC)
//              ]
//                  : [
//                const Color(0x1FFFFF8E1),
//                const Color(0xFFFF6F00)
//              ],
//            )
          color: widget.sendByMe ? Colors.grey[200] : Colors.black,
        ),
        child:
            Text(
                widget.message,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: widget.sendByMe? Colors.black : Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300)
            ),

      ),
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails('channelId', 'channelName', 'channelDescription');
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(0, 'New Message', widget.message, platform);
  }
}