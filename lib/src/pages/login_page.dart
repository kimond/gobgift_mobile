import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = new GoogleSignIn();
AuthService authService = new AuthService();

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<Null> _handleGoogleSignIn() async {
    try {
      await googleSignIn.signIn();
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      authService.login(AuthProvider.google, credentials.accessToken);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Gobgift'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new RaisedButton(
              color: Colors.red,
              child: new Text(
                'Sign in with Google',
                style: new TextStyle(color: Colors.white),
              ),
              onPressed: _handleGoogleSignIn,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
