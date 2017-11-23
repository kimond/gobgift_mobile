import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/pages/home_page.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

GoogleSignIn googleSignIn = new GoogleSignIn();

class LoginPage extends StatefulWidget {
  final Store<AppState> store;

  LoginPage({Key key, @required this.store}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState(store: store);
}

class _LoginPageState extends State<LoginPage> {
  final Store<AppState> store;
  AuthService _authService = new AuthService();
  bool _isLoggedIn = false;

  _LoginPageState({@required this.store});

  void initState() {
    super.initState();
    initAuthService();
  }

  Future<Null> _handleGoogleSignIn() async {
    try {
      await googleSignIn.signIn();
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      bool isLoggedIn = await _authService.login(
          AuthProvider.google, credentials.accessToken);
      store.dispatch(new FetchCurrentUserAction());
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
      return new Homepage(store: store);
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
              'Please sign in to begin!',
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
