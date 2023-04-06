import 'dart:developer';
import 'dart:io';

import 'package:advance_app/backend/Model/Auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart%20';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  String? token;
  String? tokentest;
  String? msg;
  String? currentusername;
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
    gettoken();
    getname();
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

  gettoken() async {
    var store = FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.targetUser.email)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      // token = data['Token'];
      Model q = Model(
          token: data['Token'],
          fullname: data['fullname'],
          address: data['address'],
          email: data['email'],
          number: data['number'],
          decp: data['decp']);
      setState(() {
        tokentest = q.token.toString();
        token = tokentest.toString();
      });
    });
    log(token.toString());
  }

  getname() async {
    var cname = FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      Model a = Model(fullname: data['fullname'], imgurl: data['imgurl']);
      setState(() {
        currentusername = a.fullname;
      });
    });
    log(currentusername.toString());
  }

  selectimg() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final get = FirebaseAuth.instance.currentUser!.email;
    final _imagePicker = ImagePicker();
    PickedFile? image;

    image = await _imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 80);

    if (image != null) {
      var file = File(image.path);
      var snapshot =
          await _firebaseStorage.ref().child('images/$get').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      log(downloadUrl.toString());
      ChatModel q = ChatModel(
        imgurl: downloadUrl,
      );
      Auth.sendimg(widget.chatRoom.chatroomid!, q);
    }
  }

  final store = FirebaseFirestore.instance.collection('Users').doc();

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

                            DateTime dt = DateTime.fromMillisecondsSinceEpoch(
                                int.parse(chat.timeStamp!));
                            return Column(children: [
                              chat.imgurl == null
                                  ? BubbleSpecialThree(
                                      seen: true,
                                      text: "${chat.message}",
                                      color: self
                                          ? const Color(0xFFE8E8EE)
                                          : Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.7),
                                      tail: false,
                                      isSender: self,
                                    )
                                  : BubbleNormalImage(
                                      id: chat.imgurl!,
                                      image: SizedBox(
                                        width: 120,
                                        height: 250,
                                        child: CachedNetworkImage(
                                            imageUrl: chat.imgurl!),
                                      ),
                                      color: self
                                          ? const Color(0xFFE8E8EE)
                                          : Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.7),
                                      tail: false,
                                      isSender: self,
                                      onTap: () {},
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
                                      "${dt.hour}:${dt.minute}",
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10, right: 2),
                        child: IconButton(
                            onPressed: () {
                              selectimg();
                            },
                            icon: Icon(
                              Icons.image_outlined,
                              size: 35,
                            ))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
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
                        // var cname =
                        //     FirebaseAuth.instance.currentUser?.displayName!;

                        if (msgcontrol.text.trim().isNotEmpty) {
                          msg = msgcontrol.text.toString();
                          ChatModel chat = ChatModel(
                              message: msgcontrol.text.trim(),
                              sender: FirebaseAuth.instance.currentUser!.email,
                              timeStamp: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString());
                          await Auth.sendChat(
                              widget.chatRoom.chatroomid!, chat);
                          log(msg.toString());
                          log(currentusername.toString());
                          log(token.toString());
                          log(await FirebaseMessaging.instance.getToken() ??
                              "NaN");
                          token = await FirebaseMessaging.instance.getToken();
                          try {
                            http.Response response = await http.post(
                              Uri.parse('https://fcm.googleapis.com/fcm/send'),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                'Authorization':
                                    'key=AAAAYP4fAZY:APA91bEv54sdYCDVVACt2X98SmN5KbdM8sn2lKiYTK0IpoGiJpRlm25IpbSNnGuwCbeUa4Sz4SbPik02FfBPDIqg0OC5Umu8H5VTv_Jjyq_clW7H7lxnw7q64l3rSMLamk4Wwb0IXLT8',
                              },
                              body: jsonEncode(
                                <String, dynamic>{
                                  'notification': <String, dynamic>{
                                    'body': '$msg',
                                    'title': '$currentusername',
                                  },
                                  'priority': 'high',
                                  'data': <String, dynamic>{
                                    'imgUrl':
                                        'https://images.unsplash.com/photo-1680399524821-d4e6b225b0ee?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
                                    'url': 'https://www.google.com/'
                                  },
                                  'to': '$token',
                                  // 'fB2rO8EsRjG9KqIkEFusYf:APA91bEVi-SmOP_vVil0_zCAoNX5mt7bh6ljTMWpDsnalE4qqKBEmN2dsly4gfgUP91ZdVuIVDBrt_QkJE9pQWNoBFFfh5rCQWp75GP9Mu3lcSPyY66eCrCLw8ZbVVe0c43h05xPlZTe',
                                },
                              ),
                            );
                            response;
                            print("Sent Notification");
                          } catch (e) {
                            print(e.toString());
                          }
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
          ),
        ],
      ),
    );
  }
}
