import 'dart:developer';

import 'package:advance_app/pages/homepage.dart';
import 'package:advance_app/pages/login.dart';
import 'package:advance_app/pages/profile.dart';
import 'package:advance_app/pages/searchuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  log(fcmToken.toString());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
          colorSchemeSeed: Colors.orangeAccent,
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle())),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const NavigationBar();
        } else {
          return const login();
        }
      },
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int index = 0;
  static TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> Pages = <Widget>[
    const homepage(),
    const searchuser(),
    const profile(),
  ];
  void onItemTap(int num) {
    setState(() {
      index = num;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pages.elementAt(index),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: index,
        selectedItemColor: Colors.orange,
        onTap: onItemTap,
      ),
    );
  }
}
