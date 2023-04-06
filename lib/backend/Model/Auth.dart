import 'dart:developer';
import 'package:advance_app/backend/Model/Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'ChatModel.dart';

class Auth {
  static Future<List<Model>> searchUser(String keyword) async {
    final FirebaseFirestore store = FirebaseFirestore.instance;
    final CollectionReference usersRef = store.collection("Users");
    final CollectionReference chatRoomRef = store.collection("chatrooms");
    final CollectionReference userDetailsRef = store.collection("userDetails");

    QuerySnapshot<Object?> res = await usersRef
        .where("fullname", isGreaterThanOrEqualTo: keyword)
        // .where('name', isGreaterThanOrEqualTo: keyword)
        .get();
    List<Model> data = [];
    for (var e in res.docs) {
      Model form = Model.fromMap(e.data() as Map<String, dynamic>);
      if (form.email!.startsWith(keyword, 0) &&
          form.email != FirebaseAuth.instance.currentUser!.email) {
        data.add(form);
      }
    }
    QuerySnapshot<Object?> res2 =
        await usersRef.where("email", isGreaterThanOrEqualTo: keyword).get();
    for (var e in res2.docs) {
      Model temp = Model.fromMap(e.data() as Map<String, dynamic>);
      if (temp.fullname!.startsWith(keyword, 0) &&
          temp.email != FirebaseAuth.instance.currentUser!.email) {
        if (data.contains(temp)) {
        } else {
          data.add(temp);
        }
      }
    }
    return data;
  }

  static Future<List<Model>> recentsearch(String keyword) async {
    final FirebaseFirestore store = FirebaseFirestore.instance;
    final CollectionReference usersRef = store.collection("Users");
    final CollectionReference chatRoomRef = store.collection("chatrooms");
    final CollectionReference userDetailsRef = store.collection("userDetails");

    QuerySnapshot<Object?> res = await usersRef
        .where("fullname", isGreaterThanOrEqualTo: keyword)
        // .where('name', isGreaterThanOrEqualTo: keyword)
        // .orderBy('lastActive', descending: true)
        .get();
    List<Model> data = [];
    for (var e in res.docs) {
      Model form = Model.fromMap(e.data() as Map<String, dynamic>);
      if (form.email!.startsWith(keyword, 0) &&
          form.email != FirebaseAuth.instance.currentUser!.email) {
        data.add(form);
      }
    }
    QuerySnapshot<Object?> res2 =
        await usersRef.where("email", isGreaterThanOrEqualTo: keyword).get();
    for (var e in res2.docs) {
      Model temp = Model.fromMap(e.data() as Map<String, dynamic>);
      if (temp.fullname!.startsWith(keyword, 0) &&
          temp.email != FirebaseAuth.instance.currentUser!.email) {
        if (data.contains(temp)) {
        } else {
          data.add(temp);
        }
      }
    }
    return data;
  }

  static Future<ChatRoomModel> getChatRoom(String targetUserMail) async {
    final FirebaseFirestore store = FirebaseFirestore.instance;
    final CollectionReference usersRef = store.collection("Users");
    final CollectionReference chatRoomRef = store.collection("chatrooms");
    final CollectionReference userDetailsRef = store.collection("userDetails");
    QuerySnapshot<Object?> d = await chatRoomRef
        .where('participants.${targetUserMail.hashCode}', isEqualTo: true)
        .where(
            "participants.${FirebaseAuth.instance.currentUser!.email!.hashCode}",
            isEqualTo: true)
        .get();
    log("${d.docs.length}");
    if (d.docs.isNotEmpty) {
      return ChatRoomModel.fromMap(d.docs.first.data() as Map<String, dynamic>);
    } else {
      ChatRoomModel model =
          ChatRoomModel(chatroomid: const Uuid().v1(), participants: {
        FirebaseAuth.instance.currentUser!.email!.hashCode.toString(): true,
        targetUserMail.hashCode.toString(): true
      }, users: [
        FirebaseAuth.instance.currentUser!.email!,
        targetUserMail,
      ]);
      await chatRoomRef.doc(model.chatroomid).set(model.toMap());
      return model;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChats(String roomID) {
    final FirebaseFirestore store = FirebaseFirestore.instance;
    final CollectionReference usersRef = store.collection("Users");
    final CollectionReference chatRoomRef = store.collection("chatrooms");
    return chatRoomRef
        .doc(roomID)
        .collection("chats")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }

  static sendChat(String roomID, ChatModel chat) async {
    final FirebaseFirestore store = FirebaseFirestore.instance;
    final CollectionReference chatRoomRef = store.collection("chatrooms");
    await chatRoomRef.doc(roomID).update({
      'lastActive': "${DateTime.now().millisecondsSinceEpoch}",
      'lastmessage': chat.message
    });
    await chatRoomRef
        .doc(roomID)
        .collection("chats")
        .doc(const Uuid().v1())
        .set(chat.toMap());

  
  }

  static sendimg(String roomID, ChatModel imgurl) async {
    final FirebaseFirestore store = FirebaseFirestore.instance;
    final CollectionReference usersRef = store.collection("Users");
    final CollectionReference chatRoomRef = store.collection("chatrooms");
    // await chatRoomRef.doc(roomID).update({
    //   'lastActive': "${DateTime.now().millisecondsSinceEpoch}",
    //   'imgurl': imgurl
    // });
    await chatRoomRef
        .doc(roomID)
        .collection("chats")
        .doc(const Uuid().v1())
        .set({
      "sender": FirebaseAuth.instance.currentUser!.email,
      "message": null,
      "imgurl": imgurl.imgurl,
      "timeStamp": "${DateTime.now().millisecondsSinceEpoch}"
    });
  }

  static Future<List<ChatRoomModel>> getRecentChat() async {
    final FirebaseFirestore store = FirebaseFirestore.instance;
    final CollectionReference chatRoomRef = store.collection("chatrooms");
    List<ChatRoomModel> model = [];

    QuerySnapshot<Object?> temp = await chatRoomRef
        .where('users',
            arrayContains: FirebaseAuth.instance.currentUser!.email!)
        .orderBy('lastActive', descending: true)
        .get();

    for (var e1 in temp.docs) {
      log("aslkdf");
      model.add(ChatRoomModel.fromMap(e1.data() as Map<String, dynamic>));
    }
    return model;
  }

  static Future<Model?> getProfileByMail(String email) async {
    final FirebaseFirestore store = FirebaseFirestore.instance;
    final CollectionReference usersRef = store.collection("Users");
    DocumentSnapshot<Object?> data = await usersRef.doc(email).get();
    if (data.data() != null) {
      return Model.fromMap(data.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
