import 'package:flutter/material.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/pages/login_page.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  static final Store<AppState> store = new Store(
    combineReducers([reducer as Reducer]),
    middleware: [futureMiddleware],
    initialState: new AppState.initial(),
  );
  final Map<String, WidgetBuilder> routes = {
    '/': (BuildContext c) => new LoginPage(store: store),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    store.dispatch(new FetchCurrentUserAction());
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
          title: 'Gobgift',
          theme: new ThemeData(
            primarySwatch: Colors.lightGreen,
          ),
          routes: routes),
    );
  }
}
