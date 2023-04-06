import 'dart:developer';

import 'package:advance_app/pages/forgetpassword.dart';
import 'package:advance_app/pages/homepage.dart';
import 'package:advance_app/pages/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController pass = TextEditingController();
    bool secure = false;
    final formkey = GlobalKey<FormState>();
    login() async {
      if (formkey.currentState!.validate()) {
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: email.text, password: pass.text)
              .then((value) => const ScaffoldMessenger(
                  child: SnackBar(content: Text("Welcome To Advance App"))));

          // if (context.mounted) {
          //   Navigator.pop(context);
          // }
          // .then((value) => Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => homepage(),
          //     )));
        } on FirebaseAuthException catch (e) {
          log(e.toString());
          if (e.code == "invalid-email") {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text("Please Enter A Valid Email"),
                  actions: [
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"))
                      ],
                    )
                  ],
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                );
              },
            );
          } else if (e.code == "wrong-password") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Wrong Password'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'Ok',
                onPressed: () {},
              ),
            ));
          } else if (e.code == "network-request-failed") {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text("No Internet Connection"),
                  actions: [
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"))
                      ],
                    )
                  ],
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                );
              },
            );
          } else if (e.code == "unknown") {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text("Something Went Wrong"),
                  actions: [
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"))
                      ],
                    )
                  ],
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                );
              },
            );
          } else if (e.code == "user-not-found") {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text("Something Went Wrong"),
                  actions: [
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"))
                      ],
                    )
                  ],
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                );
              },
            );
          }
          // print(e);
          log(e.code);
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
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SvgPicture.asset(
                    "assets/images/login.svg",
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 50,
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
                    obscureText: secure ? false : true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Enter Your Password",
                      prefixIcon: Icon(Icons.password),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      // suffix: IconButton(
                      //   icon: Icon(
                      //     Icons.remove_red_eye,
                      //     size: 15,
                      //   ),
                      //   onPressed: () {
                      //     secure = true;
                      //   },
                      // ),
                    ),
                    onChanged: (value) {
                      setSate() {
                        pass.text = pass.text;
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 1) {
                        return "Password can not be Empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text("Log In"),
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(width: 1, color: Colors.brown),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.only(
                            top: 13, bottom: 13, left: 150, right: 150)),
                    onPressed: () {
                      login();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const forgetpassword(),
                                ));
                          },
                          child: const Text(
                            "Forget Password",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("or",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Create New Account ? ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const signup(),
                                ));
                          },
                          child: const Text("Create Account",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)))
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
