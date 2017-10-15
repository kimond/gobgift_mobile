import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gobgift_mobile/src/pages/home_page.dart';
import 'package:gobgift_mobile/src/pages/login_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final Map<String, WidgetBuilder> routes = {
    '/': (BuildContext c) => new LoginPage(),
  };
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Gobgift',
      theme: new ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      routes: routes
    );
  }
}

