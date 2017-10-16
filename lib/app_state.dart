import 'dart:async';

import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:redux/redux.dart';

class AppState {
  List<Group> groups;
  List<WishList> wishLists;

  AppState.initial()
      : groups = [],
        wishLists = [] {}

  AppState._(this.groups, this.wishLists);

  AppState clone() {
    return new AppState._(new List.from(groups), new List.from(wishLists));
  }
}

class FetchGroupsAction extends IsAsyncAction {
  final _authService = new AuthService();

  @override
  Future<AppState> handle(AppState state) async {
    await _authService.init();
    final api = new GobgiftApi(_authService);
    List<Group> groups = await api.getGroups();
    state.groups = groups;
    return state;
  }
}

abstract class IsAction {
  AppState result;
  void handle(AppState state);
}

class FutureCompleteAction extends IsAction {
  AppState result;

  FutureCompleteAction(this.result);
  void handle(AppState state){}
}

abstract class IsAsyncAction {
  Future<AppState> handle(AppState state);
}

void futureMiddleware<State>(Store<State> store, action, NextDispatcher next) {
  if (action is IsAsyncAction) {
    action.handle(store.state as AppState).then((appState) {
      store.dispatch(new FutureCompleteAction(appState));
    });
  } else {
    next(action);
  }
}

AppState reducer<T extends IsAction>(AppState state, T action) {
  return action.result;
}

