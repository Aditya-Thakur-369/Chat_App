import 'dart:developer';
import 'package:advance_app/pages/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../backend/Model/Auth.dart';
import '../backend/Model/ChatModel.dart';
import '../backend/Model/Model.dart';

class searchuser extends StatefulWidget {
  const searchuser({super.key});

  @override
  State<searchuser> createState() => _searchuserState();
}

class _searchuserState extends State<searchuser> {
  Model? model;
  List<Model>? searchResult;
  String? imgurl;
  TextEditingController search = TextEditingController();
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
    getinfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        actions: [
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width - 110,
            child: TextFormField(
              controller: search,
              decoration: InputDecoration(
                  labelText: "Search .. ",
                  hintText: "Aditya ",
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          search.clear();
                        });
                      },
                      icon: Icon(Icons.clear)),
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
                  List<Model> d = await Auth.searchUser(search.text);
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
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              searchResult != null
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
                                  borderRadius: BorderRadius.circular(12)),
                              onPressed: () async {
                                model = Model(
                                    email:
                                        searchResult!.elementAt(index).email!);
                                ChatRoomModel chatRoom =
                                    // await Auth.getChatRoom(model!.email!);
                                    // await Auth.getChatRoom(searchResult!.elementAt(index).email!);
                                    await Auth.getChatRoom(model!.email!);
                                log(searchResult!.elementAt(index).email!);
                                if (context.mounted) {
                                  (searchResult!.elementAt(index).email!);
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
                                              Divider(
                                                thickness: 1,
                                                color: Colors.black,
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text("Status .. ")),
                                              Container(
                                                height: 100,
                                                width: 240,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all()),
                                                child: Text(
                                                  searchResult!
                                                          .elementAt(index)
                                                          .brief ??
                                                      "No Status",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage:
                                        searchResult!.elementAt(index).imgurl !=
                                                null
                                            ? NetworkImage(searchResult!
                                                .elementAt(index)
                                                .imgurl!)
                                            : null,
                                    child:
                                        searchResult!.elementAt(index).imgurl ==
                                                null
                                            ? const Icon(Icons.person_4)
                                            : null,
                                  ),
                                ),
                                title: Text(
                                    searchResult!.elementAt(index).fullname!),
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
            ],
          ),
        ),
      )),
    );
  }
}
