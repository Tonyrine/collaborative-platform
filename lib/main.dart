// import 'package:clpfus/pages/home.dart';
import 'package:clpfus/screens/login.dart';
// import 'package:clpfus/screens/activate.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      title: "Collaborative Learning Platform",
      debugShowCheckedModeBanner: false,
      // home: HomePage(key: GlobalKey()),
      home: LoginPage(),
      // home: ActivatePage(),
    );
  }
}
