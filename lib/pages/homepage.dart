import 'dart:developer';

import 'package:advance_app/backend/Model/Model.dart';
import 'package:advance_app/pages/chatroom.dart';
import 'package:advance_app/pages/drawer/drawertop.dart';
import 'package:advance_app/pages/searchuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../backend/Model/Auth.dart';
import '../backend/Model/ChatModel.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<ChatRoomModel>? recent;
  Model? model;
  List<Model>? searchResult;
  String? imgurl;
  TextEditingController search = TextEditingController();
  getRecentChats() async {
    List<ChatRoomModel> temp = await Auth.getRecentChat();
    setState(() {
      recent = temp;
    });
  }

  getinfo() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      imgurl = data['imgurl'];
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getRecentChats();
    });
    getinfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => searchuser(),
                ));
          },
          child: Icon(CupertinoIcons.add),
        ),
        appBar: AppBar(
          title: const Text("Advance"),
          actions: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_rounded),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                    ),
                  ],
                ))
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          imgurl != null ? NetworkImage(imgurl!) : null,
                      child: imgurl == null
                          ? SvgPicture.asset(
                              "assets/images/login.svg",
                            )
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 110,
                    child: TextFormField(
                      controller: search,
                      decoration: InputDecoration(
                          labelText: "Search Recent Chat .. ",
                          hintText: "Aditya ",
                          suffixIcon: search.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                      search.clear();
                                    });
                                  },
                                  icon: Icon(Icons.clear))
                              : null,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onChanged: (value) {
                        setState(() {
                          search = search;
                        });
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (search.text.isNotEmpty) {
                          setState(() {
                            searchResult = null;
                          });
                          List<Model> d = await Auth.recentsearch(search.text);
                          setState(() {
                            searchResult = d;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.search_sharp,
                        size: 28,
                      ))
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Recent Chats ...",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              search.text.isNotEmpty
                  ? Expanded(
                      child: searchResult != null
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height - 58,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                itemCount: searchResult!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: MaterialButton(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      onPressed: () async {
                                        model = Model(
                                            email: searchResult!
                                                .elementAt(index)
                                                .email!);
                                        ChatRoomModel chatRoom =
                                            // await Auth.getChatRoom(model!.email!);
                                            // await Auth.getChatRoom(searchResult!.elementAt(index).email!);
                                            await Auth.getChatRoom(
                                                model!.email!);
                                        log(searchResult!
                                            .elementAt(index)
                                            .email!);
                                        if (context.mounted) {
                                          (searchResult!
                                              .elementAt(index)
                                              .email!);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => chatroom(
                                                  chatRoom: chatRoom,
                                                  targetUserMail: searchResult!
                                                      .elementAt(index)
                                                      .email!,
                                                  targetUser: model!),
                                            ),
                                          );
                                        }
                                      },
                                      child: ListTile(
                                        leading: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                    content: Container(
                                                  height: 300,
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 70,
                                                        backgroundImage: searchResult!
                                                                    .elementAt(
                                                                        index)
                                                                    .imgurl !=
                                                                null
                                                            ? NetworkImage(
                                                                searchResult!
                                                                    .elementAt(
                                                                        index)
                                                                    .imgurl!)
                                                            : null,
                                                        child: searchResult!
                                                                    .elementAt(
                                                                        index)
                                                                    .imgurl ==
                                                                null
                                                            ? const Icon(
                                                                Icons.person_4)
                                                            : null,
                                                      ),
                                                      Divider(
                                                        thickness: 1,
                                                        color: Colors.black,
                                                      ),
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              "Status .. ")),
                                                      Container(
                                                        height: 100,
                                                        width: 240,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                border: Border
                                                                    .all()),
                                                        child: Text(
                                                          searchResult!
                                                                  .elementAt(
                                                                      index)
                                                                  .brief ??
                                                              "No Status",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                              },
                                            );
                                          },
                                          child: CircleAvatar(
                                            backgroundImage: searchResult!
                                                        .elementAt(index)
                                                        .imgurl !=
                                                    null
                                                ? NetworkImage(searchResult!
                                                    .elementAt(index)
                                                    .imgurl!)
                                                : null,
                                            child: searchResult!
                                                        .elementAt(index)
                                                        .imgurl ==
                                                    null
                                                ? const Icon(Icons.person_4)
                                                : null,
                                          ),
                                        ),
                                        title: Text(searchResult!
                                            .elementAt(index)
                                            .fullname!),
                                        subtitle: Text(
                                            " ${searchResult!.elementAt(index).email!}"),
                                        // trailing: IconButton(
                                        //     onPressed: () {},
                                        //     icon: Icon(Icons.message_rounded)),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                    )
                  : Expanded(
                      child: recent != null
                          ? recent!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: recent!.length,
                                  itemBuilder: (context, index) {
                                    String targetUserMail = recent!
                                                .elementAt(index)
                                                .users![0] ==
                                            FirebaseAuth
                                                .instance.currentUser!.email
                                        ? recent!.elementAt(index).users![1]
                                        : recent!.elementAt(index).users![0];
                                    return RecentChatCard(
                                        chatRoom: recent!.elementAt(index),
                                        targetUserMail: targetUserMail);
                                  },
                                )
                              : const Center(
                                  child: Text("No recent chat!!"),
                                )
                          : Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(.25),
                              highlightColor: Colors.white.withOpacity(.6),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  itemCount: 10,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color:
                                                  Colors.grey.withOpacity(.9),
                                            ),
                                            height: 50,
                                            width: 50,
                                          ),
                                          const SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 15,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                              const SizedBox(height: 5),
                                              Container(
                                                height: 15,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                    ),
            ],
          ),
        ),
        drawer: Drawer(
          elevation: 0.1,
          child: Column(
            children: [
              const drawertop(),
            ],
          ),
        ));
  }
}

class RecentChatCard extends StatefulWidget {
  const RecentChatCard({
    super.key,
    required this.chatRoom,
    required this.targetUserMail,
  });

  final ChatRoomModel chatRoom;
  final String targetUserMail;

  @override
  State<RecentChatCard> createState() => _RecentChatCardState();
}

class _RecentChatCardState extends State<RecentChatCard> {
  Model? targetUser;
  getProfile() async {
    Model? temp = await Auth.getProfileByMail(widget.targetUserMail);
    setState(() {
      targetUser = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return targetUser != null
        ? ListTile(
            leading: MaterialButton(
              padding: const EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              minWidth: 0,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * .7,
                        width: MediaQuery.of(context).size.width * .7,
                        child: targetUser!.imgurl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  "${targetUser!.imgurl}",
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(child: Text("No profile pic!!")),
                      ),
                    );
                  },
                );
              },
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: Container(
                        height: 300,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage: targetUser!.imgurl != null
                                  ? NetworkImage(targetUser!.imgurl!)
                                  : null,
                              child: targetUser!.imgurl == null
                                  ? const Icon(Icons.person_4)
                                  : null,
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Status .. ")),
                            Container(
                              height: 100,
                              width: 240,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all()),
                              child: Text(
                                targetUser!.brief ?? "No Status",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                      ));
                    },
                  );
                },
                child: CircleAvatar(
                  backgroundImage: targetUser!.imgurl != null
                      ? NetworkImage(targetUser!.imgurl!)
                      : null,
                  child: targetUser!.imgurl == null
                      ? const Icon(Icons.person_4)
                      : null,
                ),
              ),
              // ============================================================
              // child: CircleAvatar(
              //     backgroundImage: targetUser!.imgurl != null
              //         ? NetworkImage(targetUser!.imgurl!)
              //         : null,
              //     child: targetUser!.imgurl == null
              //         ? const Icon(Icons.person_3)
              //         : null),
            ),
            title: Text("${targetUser!.fullname}"),
            subtitle: Text("${widget.chatRoom.lastmessage}"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => chatroom(
                      targetUser: targetUser!,
                      chatRoom: widget.chatRoom,
                      targetUserMail: widget.targetUserMail,
                    ),
                  ));
            },
          )
        : Container(
            margin: const EdgeInsets.all(10),
            child: Shimmer.fromColors(
              period: const Duration(seconds: 2),
              enabled: true,
              baseColor: Colors.grey.withOpacity(.25),
              highlightColor: Colors.white.withOpacity(.6),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey.withOpacity(.9),
                    ),
                    height: 50,
                    width: 50,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 15,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.6),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 15,
                        width: MediaQuery.of(context).size.width - 100,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.6),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
