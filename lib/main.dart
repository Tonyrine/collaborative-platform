import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clpfus/screens/login.dart';
import 'package:clpfus/screens/user_id_provider.dart'; // Import the UserIdProvider

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserIdProvider(),
      child: MaterialApp(
        title: "Collaborative Learning Platform",
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
