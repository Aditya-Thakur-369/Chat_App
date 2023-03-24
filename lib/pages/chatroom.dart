// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../backend/Model/ChatModel.dart';
import '../backend/Model/Model.dart';

class chatroom extends StatefulWidget {
  const chatroom({
    Key? key,
    required this.chatRoom,
    required this.targetUserMail,
    required this.targetUser,
  }) : super(key: key);

  final ChatRoomModel chatRoom;
  final String targetUserMail;
  final Model targetUser;

  @override
  State<chatroom> createState() => _chatroomState();
}

class _chatroomState extends State<chatroom> {
  String? email;
  String? mail;
  String? name;
  @override
  void initState() {
    super.initState();
    email = widget.targetUserMail;
    getmodel(email!);
  }

  getmodel(String email) {
    final auth = FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        // Model d = Model(
        //   email: data['email'],
        //   fullname: data['fullname'],
        // );
        mail:
        data['email'];
        name:
        data['name'];
        setState(() {
          log(name!);
        });
      });
    });
  }

  final store = FirebaseFirestore.instance.collection('Users').doc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
                // backgroundImage: widget.targetUser.imgurl != null
                //     ? NetworkImage(widget.targetUser.imgurl!)
                //     : null,
                // child: widget.targetUser.imgurl == null
                //     ? const Icon(Icons.person_3)
                //     : null,

                ),
          ],
        ),
        Column(children: [
          Text(
            "Aditya",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            "adityachauhan@gmail.com",
            style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
          ),
        ])
      ]),
    );
  }
}
