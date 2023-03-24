import 'dart:io';
import 'dart:developer';
import 'package:image_cropper/image_cropper.dart';
import 'package:advance_app/pages/updateprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart%20';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../backend/Model/Model.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String? imageUrl;
  String? email;
  String? fullname;
  String? number;
  String? address;
  String? etah;
  String? decp;
  int? datetime;
  Duration? dur;
  TextEditingController brief = TextEditingController();
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
      setState(() {
        print(data.toString());
        email = data['email'];
        fullname = data['fullname'];
        number = data['number'];
        address = data['address'];
        decp = data['decp'];
        imageUrl = data['imgurl'];
        datetime = data['briefTime'];
        print(imageUrl.toString());
        if (data['brief'] == null) {
          brief.text = " ";
        } else {
          brief.text = data['brief'];
        }
      });
      if (datetime != null) {
        Duration d = DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(datetime ?? 0));
        print(d.toString());
        setState(() {
          dur = d;
        });
        if (d.inMinutes > 2) {
          removebio();
        }
      } else {}
    }, onError: (e) => print("Error getting document: $e"));
  }

  updatebio() {
    datetime = DateTime.now().millisecondsSinceEpoch;
    final db = FirebaseFirestore.instance;
    final b = db
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
          "brief": brief.text,
          "briefTime": DateTime.now().millisecondsSinceEpoch
        })
        .then((value) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Status Has Been Updated"))))
        .onError((error, stackTrace) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$error"))));
  }

  removebio() {
    final a = FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({"brief": null, "briefTime": null});
    setState(() {
      brief.text = "";
    });
  }

  uploadImage() async {
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
      // ---------------------------------------------------------
      try {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .update({'imgurl': downloadUrl})
            .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Image Uploaded Successfully"))))
            .onError((error, stackTrace) => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("$error"))));
      } catch (e) {
        // log(e.toString());
        print(e.toString());
        // log(e.hashCode);
      }
      // -------------------------------------------------------------
      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      print('No Image Path Received');
    }
  }

  bool b = false;

  @override
  void initState() {
    super.initState();
    getdata();
    if (brief.text.length > 3) {
      b = true;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onLongPress: () async {
                          uploadImage();
                        },
                        child: Container(
                            height: 110,
                            width: 110,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey),
                            child: CircleAvatar(
                              backgroundImage: imageUrl != null
                                  ? NetworkImage(imageUrl!)
                                  : null,
                              child: imageUrl == null
                                  ? SvgPicture.asset(
                                      "assets/images/login.svg",
                                    )
                                  : null,
                            )),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 8),
                        child: Column(
                          children: [
                            Text(
                              "$fullname",
                              style: TextStyle(
                                  fontSize: 22, color: Colors.grey.shade700),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                "$email",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade500),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: brief,
                          keyboardType: TextInputType.multiline,
                          maxLines: 15,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Share Your Status To All ",
                            hintText: b ? "Share Your Status To All" : null,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 25,
                          top: 5,
                          bottom: 5,
                        ),
                        child: brief.text.length > 2
                            ? datetime != null
                                ? Text(
                                    "${dur!.inMinutes} min ago",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade400),
                                  )
                                : const SizedBox.shrink()
                            : const SizedBox.shrink(),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              updatebio();
                            },
                            child: Text("Status"),
                            style: const ButtonStyle(
                                padding: MaterialStatePropertyAll(
                                    EdgeInsets.only(
                                        top: 13,
                                        bottom: 13,
                                        left: 50,
                                        right: 50))),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            removebio();
                          },
                          child: Text("Remove"),
                          style: const ButtonStyle(
                              padding: MaterialStatePropertyAll(EdgeInsets.only(
                                  top: 13, bottom: 13, left: 50, right: 50))),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  child: const Text("Update Profile"),
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.only(
                          top: 10, bottom: 10, left: 120, right: 120))),
                  onPressed: () {
                    // createuser();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => updateprofile(),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
