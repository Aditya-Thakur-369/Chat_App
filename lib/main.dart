import 'dart:developer';

import 'package:advance_app/pages/homepage.dart';
import 'package:advance_app/pages/login.dart';
import 'package:advance_app/pages/profile.dart';
import 'package:advance_app/pages/searchuser.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> handleBackgroundNotification(RemoteMessage message) async {
  String? title = message.notification!.title;
  String? body = message.notification!.body;
  String? image = message.data['imgUrl'];
  String? newsUrl = message.data['url'];

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 01,
      channelKey: 'noti',
      title: title,
      body: body,
      wakeUpScreen: true,
      notificationLayout: image != null
          ? NotificationLayout.BigPicture
          : NotificationLayout.Default,
    ),
  );
}

void main() async {
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'noti',
      channelName: 'Notifications Channel',
      channelDescription: 'Channel which will be used for notifications',
      defaultColor: Colors.deepOrange.shade700,
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
      defaultRingtoneType: DefaultRingtoneType.Notification,
    )
  ]);

  FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // FirebaseFirestore.instance
  //     .collection("Users")
  //     .doc(FirebaseAuth.instance.currentUser!.email)
  //     .update({"Token": fcmToken});
  // log(fcmToken.toString());
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

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((event) {});

    FirebaseMessaging.onMessage.listen((message) {
      String? title = message.notification!.title;
      String? body = message.notification!.body;
      String? image = message.data['imgUrl'];
      String? newsUrl = message.data['url'];

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 01,
          channelKey: 'noti',
          title: title,
          body: body,
          wakeUpScreen: true,
          notificationLayout: image != null
              ? NotificationLayout.BigPicture
              : NotificationLayout.Default,
          bigPicture: image,
        ),
      );
      // AwesomeNotifications().actionStream.listen((event) {
      //   Uri? uri = Uri.tryParse(newsUrl ?? "");
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => SplashScreen(
      //       initialURI: uri,
      //     ),
      //   ),
      // );
      // });
    });
  }

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
