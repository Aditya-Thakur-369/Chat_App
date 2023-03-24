import 'package:advance_app/backend/Model/Model.dart';
import 'package:advance_app/pages/chatroom.dart';
import 'package:advance_app/pages/drawer/drawertop.dart';
import 'package:advance_app/pages/searchuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../backend/Model/Auth.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
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
            child: IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
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
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => chatroom(),
                                //   ),
                                // );
                              },
                              child: ListTile(
                                leading: CircleAvatar(
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
                                title: Text(
                                    searchResult!.elementAt(index).fullname!),
                                subtitle: Text(
                                    " ${searchResult!.elementAt(index).email!}"),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.message_rounded)),
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
      ),
      drawer: Drawer(
        elevation: 0.1,
        child: Column(
          children: [
            const drawertop(),
          ],
        ),
      ),
    );
  }
}
