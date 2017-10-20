import 'dart:async';

import 'package:gobgift_mobile/src/models/gift.dart';
import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:redux/redux.dart';

class CurrentWishListState {
  final WishList wishList;
  final List<Gift> gifts;

  CurrentWishListState({this.wishList, this.gifts});

  CurrentWishListState apply({WishList wishList, List<Gift> gifts}) {
    return new CurrentWishListState(
        wishList: wishList ?? this.wishList, gifts: gifts ?? this.gifts);
  }
}

class SetSelectedListAction extends IsAction {
  final WishList wishList;

  SetSelectedListAction(this.wishList);

  @override
  AppState handle(AppState state) {
    CurrentWishListState selectedWishList =
        new CurrentWishListState(wishList: wishList);
    return state.apply(selectedList: selectedWishList);
  }
}

class AddGiftAction extends IsAction {
  final Gift gift;

  AddGiftAction(this.gift);

  AppState handle(AppState state) {
    List<Gift> gifts = state.selectedList.gifts;
    gifts.add(gift);
    return state.apply(selectedList: state.selectedList.apply(gifts: gifts));
  }
}

class AppState {
  List<Group> groups;
  List<WishList> wishLists;
  final CurrentWishListState selectedList;

  AppState.initial()
      : groups = [],
        wishLists = [],
        selectedList = null;

  AppState._({this.groups, this.wishLists, this.selectedList});

  AppState apply(
      {List<Group> groups,
      List<WishList> wishLists,
      CurrentWishListState selectedList}) {
    return new AppState._(
        groups: groups ?? this.groups,
        wishLists: wishLists ?? this.wishLists,
        selectedList: selectedList ?? this.selectedList);
  }
}

class FetchGroupsAction extends IsAsyncAction {
  final _authService = new AuthService();

  @override
  Future<Null> handle(Store<AppState> store) async {
    await _authService.init();
    final api = new GroupsApi(_authService);
    List<Group> groups = await api.getList();
    store.dispatch(new SetGroupsAction(groups));
  }
}

class AddGroupAction extends IsAction {
  final Group _group;

  AddGroupAction(this._group);

  @override
  AppState handle(AppState state) {
    List<Group> groups = state.groups;
    groups.add(_group);
    return state.apply(groups: groups);
  }
}

class DeleteGroupAction extends IsAsyncAction {
  final _authService = new AuthService();
  final Group _group;

  DeleteGroupAction(this._group);

  @override
  Future<Null> handle(Store<AppState> store) async {
    await _authService.init();
    final api = new GroupsApi(_authService);
    bool _success = await api.delete(_group);
    if (_success) {
      List<Group> groups = store.state.groups;
      groups.remove(_group);
      store.dispatch(new SetGroupsAction(groups));
    }
  }
}

class SetGroupsAction extends IsAction {
  final List<Group> _groups;

  SetGroupsAction(this._groups);

  @override
  AppState handle(AppState state) {
    return state.apply(groups: _groups);
  }
}

class FetchListsAction extends IsAsyncAction {
  final _authService = new AuthService();

  @override
  Future<Null> handle(Store<AppState> store) async {
    await _authService.init();
    final api = new ListsApi(_authService);
    List<WishList> wishLists = await api.getList();
    store.dispatch(new SetListsAction(wishLists));
  }
}

class DeleteListAction extends IsAsyncAction {
  final _authService = new AuthService();
  final WishList _wishList;

  DeleteListAction(this._wishList);

  @override
  Future<Null> handle(Store<AppState> store) async {
    await _authService.init();
    final api = new ListsApi(_authService);
    bool _success = await api.delete(_wishList);
    if (_success) {
      List<WishList> wishLists = store.state.wishLists;
      wishLists.remove(_wishList);
      store.dispatch(new SetListsAction(wishLists));
    }
  }
}

class SetListsAction extends IsAction {
  final List<WishList> _wishLists;

  SetListsAction(this._wishLists);

  @override
  AppState handle(AppState state) {
    return state.apply(wishLists: _wishLists);
  }
}

class AddListAction extends IsAction {
  final WishList _wishList;

  AddListAction(this._wishList);

  @override
  AppState handle(AppState state) {
    List<WishList> wishLists = state.wishLists;
    wishLists.add(_wishList);
    return state.apply(wishLists: wishLists);
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
  return action.handle(state);
}
