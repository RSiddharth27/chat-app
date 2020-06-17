import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  getUserByUserName(String username) async {
    return await Firestore.instance.collection("users").where("name", isEqualTo: username).getDocuments();
  }
  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance.collection("users").where("email", isEqualTo: userEmail).getDocuments();
  }
  uploadUserInfo(userMap){
    Firestore.instance.collection("users").add(userMap);
  }
  createChatRoom(String chatRoomId, chatRoomMap){
    Firestore.instance.collection("chatRoom")
        .document(chatRoomId).setData(chatRoomMap).catchError((e){
          print(e.toString());
    });
  }

   getConversationMessages(String chatRoomId, messageMap) async {
      return await Firestore.instance.collection("ChatRoom")
          .document(chatRoomId)
          .collection("chats")
          .add(messageMap)
          .catchError((e){
            print(e.toString());
      });
   }
  getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots();
  }
  Future<void> addMessage(String chatRoomId, chatMessageData) async {

    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
}