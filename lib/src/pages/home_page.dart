import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/pages/group_page.dart';
import 'package:gobgift_mobile/src/pages/list_page.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

GoogleSignIn googleSignIn = new GoogleSignIn();
AuthService authService = new AuthService();

class Homepage extends StatefulWidget {
  final Store<AppState> store;

  Homepage({Key key, @required this.store}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState(store: store);
}

class _HomePageState extends State<Homepage> with TickerProviderStateMixin {
  final Store<AppState> store;
  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;

  _HomePageState({@required this.store});

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: const Icon(Icons.group),
        body: new GroupPage(store: store),
        title: const Text('My groups'),
        color: new Color.fromARGB(0xFF, 0xF4, 0x43, 0x36),
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.event_note),
        body: new ListPage(),
        title: const Text('My lists'),
        color: new Color.fromARGB(0xFF, 0x34, 0x73, 0x36),
        vsync: this,
      ),
    ];

    for (NavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }

    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews) {
      transitions.add(view.transition(context));
    }

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.listenable;
      final Animation<double> bAnimation = b.listenable;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.shifting,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );
    return new Scaffold(
      body: new Center(child: _buildTransitionsStack()),
      bottomNavigationBar: botNavBar,
    );
  }
}

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget body,
    Widget title,
    Color color,
    TickerProvider vsync,
  })
      : _body = body,
        item = new BottomNavigationBarItem(
          icon: icon,
          title: title,
          backgroundColor: color,
        ),
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final Widget _body;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(BuildContext context) {
    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 0.02),
          end: Offset.zero,
        )
            .animate(_animation),
        child: _body,
      ),
    );
  }
}
