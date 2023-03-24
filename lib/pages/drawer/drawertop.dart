import 'package:advance_app/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class drawertop extends StatefulWidget {
  const drawertop({super.key});

  @override
  State<drawertop> createState() => _drawertopState();
}

class _drawertopState extends State<drawertop> {
  String? name;
  String? email;
  String? imgurl;
  showinfo() {
    final db = FirebaseFirestore.instance;
    final ref = db
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((DocumentSnapshot doc) {
      final info = doc.data() as Map<String, dynamic>;
      print(info.toString());
      setState(() {
        name = info['fullname'];
        email = info['email'];
        imgurl = info['imgurl'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    showinfo();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                    child: CircleAvatar(
                      backgroundImage:
                          imgurl != null ? NetworkImage(imgurl!) : null,
                      child: imgurl == null
                          ? SvgPicture.asset(
                              "assets/images/login.svg",
                            )
                          : null,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text(
                      "$name",
                      style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$email",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => profile(),
                            ));
                      },
                      child: Text("View Profile"))),
            )
          ],
        ),
      ),
    );
  }
}
