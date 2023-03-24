import 'package:advance_app/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgetpassword extends StatefulWidget {
  const forgetpassword({super.key});

  @override
  State<forgetpassword> createState() => _forgetpasswordState();
}

class _forgetpasswordState extends State<forgetpassword> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 200),
                  child: Text(
                    "Forget Password",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
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
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    child: const Text("Send Link"),
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.only(
                            top: 13, bottom: 13, left: 140, right: 140))),
                    onPressed: () {
                      // login();
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(
                              email: email.text.toString().trim())
                          .then((value) => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    'Password Reset Email Has Been Send !!'),
                                duration: const Duration(seconds: 1),
                                action: SnackBarAction(
                                  label: 'Ok',
                                  onPressed: () {},
                                ),
                              )))
                          .onError((error, stackTrace) =>
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("$error"),
                                duration: const Duration(seconds: 1),
                                action: SnackBarAction(
                                  label: 'ok',
                                  onPressed: () {},
                                ),
                              )));
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("or",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Back to log in ? ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const login(),
                            ));
                      },
                      child: const Text("Log In",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)))
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
