import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../backend/Model/Model.dart';

class updateprofile extends StatefulWidget {
  const updateprofile({super.key});

  @override
  State<updateprofile> createState() => _updateprofileState();
}

class _updateprofileState extends State<updateprofile> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController decp = TextEditingController();
  String? imgurl;
  @override
  final CollectionReference reference =
      FirebaseFirestore.instance.collection("Users");
  getdata() {
    final db = FirebaseFirestore.instance;
    final ref = db
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      // email.text = data['email'];
      // fullname.text = data['fullname'];
      // number.text = data['number'];
      // address.text = data['address'];
      // decp.text = data['decp'];
      Model a = Model(
          address: data['address'],
          decp: data['decp'],
          number: data['number'],
          fullname: data['fullname'],
          imgurl: data['imgurl'],
          email: data['email']);

      setState(() {
        fullname.text = a.fullname!;
        decp.text = a.decp!;
        number.text = a.number!;
        address.text = a.address!;
        email.text = a.email!;
        imgurl = a.imgurl;
      });
    }, onError: (e) => print("Error getting document: $e"));
  }

  update() {
    final db = FirebaseFirestore.instance;
    Model p = Model(
        address: address.text,
        fullname: fullname.text,
        number: number.text,
        email: email.text,
        decp: decp.text);
    final up = db
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update(p.toMap())
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile Updated Successfully"))));
    // .onError((error, stackTrace) => print(error));
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Prifle"),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 120,
                width: 120,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey),
                child: CircleAvatar(
                  backgroundImage:
                      imgurl != null ? NetworkImage(imgurl!) : null,
                  child: imgurl == null
                      ? SvgPicture.asset(
                          "assets/images/login.svg",
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "Enter Your Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                validator: (value) {
                  if (value!.isEmpty || value.length < 1) {
                    return "Email Can not be Empty";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: fullname,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    labelText: "Fullname",
                    hintText: "Enter Your Fullname",
                    prefixIcon: Icon(Icons.abc),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                validator: (value) {
                  if (value!.isEmpty || value.length < 1) {
                    return "Fullname Can not be Empty";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: number,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Number",
                    hintText: "Enter Your Number",
                    prefixIcon: Icon(Icons.numbers_rounded),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                validator: (value) {
                  if (value!.isEmpty || value.length != 10) {
                    return "Enter a Valid Number";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: address,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    labelText: "Address",
                    hintText: "Enter Your Address",
                    prefixIcon: Icon(Icons.place_rounded),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                validator: (value) {
                  if (value!.isEmpty || value.length < 1) {
                    return "Address Can not be Empty";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: decp,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: const InputDecoration(
                    labelText: "description",
                    hintText: "Enter description About YourSelf",
                    prefixIcon: Icon(Icons.description_rounded),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: const Text("Update"),
                style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 1, color: Colors.brown),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.only(
                        top: 13, bottom: 13, left: 140, right: 140)),
                onPressed: () {
                  // createuser();
                  update();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
