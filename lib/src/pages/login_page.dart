import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/src/pages/home_page.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = new GoogleSignIn();

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService _authService = new AuthService();
  bool _isLoggedIn = false;

  void initState() {
    super.initState();
    initAuthService();
  }

  Future<Null> _handleGoogleSignIn() async {
    try {
      await googleSignIn.signIn();
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      bool isLoggedIn =
          await _authService.login(AuthProvider.google, credentials.accessToken);
      setState(() {
        _isLoggedIn = isLoggedIn;
      });
    } catch (error) {
      print(error);
    }
  }

  Future initAuthService() async {
    await authService.init();
    bool isLoggedIn = authService.loggedIn;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return new Homepage();
    }
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
    );
  }
}
