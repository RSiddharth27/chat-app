import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctionsforsharedpreference.dart';
import 'package:chatapp/screens/conversation_screen_ui.dart';
import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/SearchPage';
  @override
  _SearchPageState createState() => _SearchPageState();
}
String _myName;
class _SearchPageState extends State<SearchPage> {
  TextEditingController searchEditingController = new TextEditingController();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  QuerySnapshot searchSnapshot;



  initiateSearch(){
    dataBaseMethods.getUserByUserName(searchEditingController.text).then((val){
    setState(() {
      searchSnapshot = val;
    });
    });
  }

  createChatRoomAndStartConversation({String userName}){
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatRoomId" : chatRoomId,
      };

      dataBaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId, userName)
      ));
    }
    else{
      print("asdfg");
    }
  }

  Widget SearchTile({String userName, String userEmail}) {
    return  Container(
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AutoSizeText(
                userName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Raleway',
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
              AutoSizeText(
                userEmail,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Raleway',
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: IconButton(icon: Icon(Icons.message),)
//            AutoSizeText(
//              'Message',
//              style: TextStyle(
//                fontSize: 20.0,
//                fontWeight: FontWeight.normal,
//                fontFamily: 'Raleway',
//                color: Colors.black,
//                letterSpacing: 2.0,
//              ),
//            ),
            ),

            onTap: () {
              print("$userName dfghdfghdghdgh");
              createChatRoomAndStartConversation(userName : userName);
            },
          )
        ],
      ),
    );
  }

  Widget searchList(){
    return searchSnapshot != null ? Container(
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: searchSnapshot.documents.length,
          itemBuilder: (context, index){
            return SearchTile(
              userName: searchSnapshot.documents[index].data["name"],
              userEmail: searchSnapshot.documents[index].data["email"],
            );
          },
      ),
    ) : Container(
//      child: AutoSizeText("Oopsey.. You don't have any chats.. \n please search and start a new conversation"),
    );
  }
  Future getDocs() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("users").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      print(a.documentID);
    }
  }




  @override
  void initState() {
    // TODO: implement initState
//    getUserInfo();
    super.initState();
  }

//  getUserInfo() async{
//    _myName = await HelperFunction.getUserNameSharedPreference();
//    setState(() {
//
//    });
//    print("$_myName");
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FloatingSearchBar.builder(
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back
            ),
            onTap: () => Navigator.pop(context),
          ),
          pinned: true,
          itemCount: 1,
          padding: EdgeInsets.only(top: 10.0),
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: searchList()
//            child: PrintData(),
            );
          },
          onChanged: (String value) {
            searchEditingController.text = value;
          },
          onTap: () {
            dataBaseMethods.getUserByUserName(searchEditingController.text).then((val){
              print(val.toString());
            });
          },
          decoration: InputDecoration.collapsed(
            hintText: "Search for the user name",
          ),
//         trailing: IconButton(icon: Icon(Icons.clear),onPressed:() => searchEditingController.text = "",),
//          controller: searchEditingController,
        body: Container(
          child: Text('dsagf'),
        ),
          trailing: GestureDetector(
            child: Icon(
              Icons.search
            ),
            onTap: () {
              initiateSearch();
            },
          ),
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}