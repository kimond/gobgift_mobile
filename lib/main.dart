import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gobgift_mobile/src/pages/login_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Gobgift',
      theme: new ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: new LoginPage(),
    );
  }
}

