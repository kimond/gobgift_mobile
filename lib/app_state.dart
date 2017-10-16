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
        wishLists = [];

  AppState._(this.groups, this.wishLists);

  AppState clone() {
    return new AppState._(new List.from(groups), new List.from(wishLists));
  }
}

class FetchGroupsAction extends IsAsyncAction {
  final _authService = new AuthService();

  @override
  Future<Null> handle(Store<AppState> store) async {
    await _authService.init();
    final api = new GobgiftApi(_authService);
    List<Group> groups = await api.getGroups();
    store.dispatch(new SetGroupsAction(groups));
  }
}

class AddGroupAction extends IsAction {
  final Group _group;

  AddGroupAction(this._group);

  @override
  AppState handle(AppState state) {
    state.groups.add(_group);
    return state;
  }
}

class SetGroupsAction extends IsAction {
  final List<Group> _groups;

  SetGroupsAction(this._groups);

  @override
  AppState handle(AppState state) {
    state.groups = _groups;
    return state;
  }
}

class FetchListsAction extends IsAsyncAction {
  final _authService = new AuthService();

  @override
  Future<Null> handle(Store<AppState> store) async {
    await _authService.init();
    final api = new GobgiftApi(_authService);
    List<WishList> wishLists = await api.getWishLists();
    store.dispatch(new SetListsAction(wishLists));
  }
}

class SetListsAction extends IsAction{
  final List<WishList> _wishLists;

  SetListsAction(this._wishLists);

  @override
  AppState handle(AppState state) {
    state.wishLists = _wishLists;
    return state;
  }
}

class AddListAction extends IsAction {
  final WishList _wishList;

  AddListAction(this._wishList);

  @override
  AppState handle(AppState state) {
    state.wishLists.add(_wishList);
    return state;
  }
}

abstract class IsAction {
  AppState handle(AppState state);
}

abstract class IsAsyncAction {
  Future<Null> handle(Store<AppState> store);
}

void futureMiddleware<State>(Store<State> store, action, NextDispatcher next) {
  if (action is IsAsyncAction) {
    action.handle(store as Store<AppState>);
  } else {
    next(action);
  }
}

AppState reducer<T extends IsAction>(AppState state, T action) {
  return action.handle(state.clone());
}
