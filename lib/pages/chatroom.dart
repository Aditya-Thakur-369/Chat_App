// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:advance_app/backend/Model/Auth.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  String? imgurl;
  TextEditingController msgcontrol = TextEditingController();
  @override
  void initState() {
    super.initState();
    email = widget.targetUserMail;
    getmodel(email!);
  }

  getmodel(String email) {
    final auth = FirebaseFirestore.instance
        .collection("Users")
        .doc(email)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      log(data.toString());
      setState(() {
        // Model d = Model(
        //   email: data['email'],
        //   fullname: data['fullname'],
        // );
        mail = data['email'];
        name = data['fullname'];
        imgurl = data['imgurl'];
      });
    });
  }

  final store = FirebaseFirestore.instance.collection('Users').doc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        title: SizedBox(
          width: MediaQuery.of(context).size.width - 55,
          height: 48,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: imgurl != null ? NetworkImage(imgurl!) : null,
                child: imgurl == null ? const Icon(Icons.person_3) : null,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width - 122,
                height: 48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        "$email",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                175 -
                (MediaQuery.of(context).viewInsets.bottom),
            child: StreamBuilder(
                stream: Auth.getChats(widget.chatRoom.chatroomid!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data!.docs.length,
                          // physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            ChatModel chat = ChatModel.fromMap(
                                snapshot.data!.docs.elementAt(index).data());

                            bool self = chat.sender ==
                                FirebaseAuth.instance.currentUser!.email;

                            return Column(children: [
                              BubbleSpecialThree(
                                seen: true,
                                text: "${chat.message}",
                                color: self
                                    ? const Color(0xFFE8E8EE)
                                    : Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.7),
                                tail: false,
                                isSender: self,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Align(
                                  alignment: self
                                      ? Alignment.centerRight
                                      : Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 8),
                                    child: Text(
                                      "${chat.timeStamp!.hour}:${chat.timeStamp!.minute}",
                                      style: TextStyle(
                                          // color: Colors.white,

                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              )
                            ]);
                          });
                    } else {
                      return Container(
                          child: Column(children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 55,
                            height: 408,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: imgurl != null
                                      ? NetworkImage(imgurl!)
                                      : null,
                                  child: imgurl == null
                                      ? const Icon(Icons.person_3)
                                      : null,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text("$name",
                                                  style: TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              SizedBox(
                                                child: Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "$email",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 150,
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Text(
                                                    "No messages yet!!",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors
                                                            .grey.shade700),
                                                  ))
                                            ],
                                          )
                                        ]),
                                  ),
                                ),
                              ],
                            ))
                      ]));
                    }
                  } else {
                    return Center(
                        child: SpinKitCircle(
                            color: Theme.of(context).primaryColor, size: 55));
                  }
                }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 65,
                    child: TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      autocorrect: true,
                      controller: msgcontrol,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.grey),
                        labelText: "Enter message",
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Enter something to Chats ",
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () async {
                      if (msgcontrol.text.trim().isNotEmpty) {
                        ChatModel chat = ChatModel(
                            message: msgcontrol.text.trim(),
                            sender: FirebaseAuth.instance.currentUser!.email,
                            timeStamp: DateTime.now());
                        await Auth.sendChat(widget.chatRoom.chatroomid!, chat);
                      }
                      msgcontrol.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.grey,
                      size: 30,
                    ),
                  )
                  // IconButton(
                  //   color: const Color.fromARGB(255, 48, 220, 53),
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.attach_file),
                  // ),

                  // const SizedBox(width: 4),
                  // if(tcontroller.text!=null)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
