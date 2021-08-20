import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../resources/firebase_methods.dart';
import '../screens/home.dart';
import '../screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "2 Factor Authentication",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _firebaseMethods.getCurrentUser(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return Login();
          }
        },
      ),
    );
  }
}
