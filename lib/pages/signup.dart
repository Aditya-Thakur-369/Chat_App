import 'dart:developer';

import 'package:advance_app/pages/homepage.dart';
import 'package:advance_app/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../backend/Model/Model.dart';

class signup extends StatelessWidget {
  const signup({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController pass = TextEditingController();
    TextEditingController fullname = TextEditingController();
    TextEditingController number = TextEditingController();
    TextEditingController address = TextEditingController();
    TextEditingController decp = TextEditingController();
    final formkey = GlobalKey<FormState>();
    final db = FirebaseFirestore.instance;
    createuser() async {
      if (formkey.currentState!.validate()) {
        try {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email.text, password: pass.text)
              .then((value) async {
            // final user = <String, dynamic>{
            //   'email': email.text,
            //   'fullname': fullname.text,
            //   'number': number.text,
            //   'address': address.text,
            //   'decp': decp.text,
            // };
            Model u = Model(
              address: address.text,
              decp: decp.text,
              email: email.text,
              fullname: fullname.text,
              number: number.text,
              uid: value.user!.uid,
            );
            await db
                .collection("Users")
                .doc(u.email)
                .set(u.toMap())
                .onError((e, _) => print("Error writing document: $e"));
            // .then((value) => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => homepage(),
            //     )));
          }).then((value) async {
            final fcmToken = await FirebaseMessaging.instance.getToken();
            FirebaseFirestore.instance
                .collection("Users")
                .doc(email.text)
                .update({"Token": fcmToken});
            log(fcmToken.toString());
          });
          if (context.mounted) {
            Navigator.pop(context);
          }
        } on FirebaseAuthException catch (e) {
          log(e.toString());
          if (e.code == "email-already-in-use") {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text(
                    "Please Enter A Valid Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                );
              },
            );
          } else if (e.code == "weak-password") {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text(
                    "Week Password",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                );
              },
            );
          } else if (e.code == "invalid-email") {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text(
                    "Invalid Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                );
              },
            );
          } else if (e.code == "operation-not-allowed") {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text(
                    "Something Went Wrong",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                );
              },
            );
          }
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Create Your Account",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
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
                    controller: pass,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter Your Password",
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a Valid Password";
                      } else if (value.length < 6) {
                        return "Password Should Greater Then 6 Digits";
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: const Text("Sign Up"),
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(width: 1, color: Colors.brown),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.only(
                            top: 13, bottom: 13, left: 140, right: 140)),
                    onPressed: () {
                      createuser();
                    },
                  ),
                  const Text("or"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Log In In Older Account ? "),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => login(),
                                ));
                          },
                          child: const Text("Log In"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
