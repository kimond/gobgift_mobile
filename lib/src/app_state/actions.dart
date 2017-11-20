import 'dart:async';

import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/services.dart';
import 'package:gobgift_mobile/src/models/gift.dart';
import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/models/user.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:redux/redux.dart';

class SetSelectedGroupAction extends IsAction {
  final Group group;

  SetSelectedGroupAction(this.group);

  @override
  AppState handle(AppState state) {
    final selectedGroup = state.selectedGroup.apply(group: group);
    return state.apply(selectedGroup: selectedGroup);
  }
}

class FetchListsForSelectedGroupAction extends IsAsyncAction {
  final _authService = new AuthService();

  FetchListsForSelectedGroupAction();

  @override
  Future<Null> handle(Store<AppState> store) async {
    await _authService.init();
    final groupApi = new GroupsApi(_authService);
    List<WishList> wishLists =
        await groupApi.getLists(store.state.selectedGroup.group);
    store.dispatch(new SetListsForSelectedGroupAction(wishLists));
  }
}

class SetListsForSelectedGroupAction extends IsAction {
  final List<WishList> wishLists;

  SetListsForSelectedGroupAction(this.wishLists);

  @override
  AppState handle(AppState state) {
    final selectedGroup = state.selectedGroup.apply(wishLists: wishLists);
    return state.apply(selectedGroup: selectedGroup);
  }
}

class SetSelectedListAction extends IsAction {
  final WishList wishList;

  SetSelectedListAction(this.wishList);

  @override
  AppState handle(AppState state) {
    final selectedWishList = state.selectedList.apply(wishList: wishList);
    return state.apply(selectedList: selectedWishList);
  }
}

class SetGiftsForSelectedListAction extends IsAction {
  final List<Gift> gifts;

  SetGiftsForSelectedListAction(this.gifts);

  @override
  AppState handle(AppState state) {
    return state.apply(selectedList: state.selectedList.apply(gifts: gifts));
  }
}

class FetchGiftsForSelectedListAction extends IsAsyncAction {
  final _authService = new AuthService();

  FetchGiftsForSelectedListAction();

  @override
  Future<Null> handle(Store<AppState> store) async {
    await _authService.init();
    final listApi = new ListsApi(_authService);
    store.dispatch(new SetIsLoadingForSelectedList(true));
    List<Gift> gifts =
        await listApi.getGifts(store.state.selectedList.wishList);
    store.dispatch(new SetGiftsForSelectedListAction(gifts));
    store.dispatch(new SetIsLoadingForSelectedList(false));
  }
}

class SetIsLoadingForSelectedList extends IsAction {
  final bool loadingStatus;

  SetIsLoadingForSelectedList(this.loadingStatus);

  @override
  AppState handle(AppState state) {
    return state.apply(
        selectedList: state.selectedList.apply(isLoading: loadingStatus));
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

class FetchCurrentUserAction extends IsAsyncAction {
  final _authService = new AuthService();

  FetchCurrentUserAction();

  @override
  Future<Null> handle(Store<AppState> store) async {
    await _authService.init();
    final userApi = new UserApi(_authService);
    User user = await userApi.getCurrent();
    store.dispatch(new SetCurrentUserAction(user));
  }
}

class SetCurrentUserAction extends IsAction {
  final User _user;

  SetCurrentUserAction(this._user);

  @override
  AppState handle(AppState state) {
    return state.apply(user: _user);
  }
}

abstract class IsAction {
  AppState handle(AppState state);
}

abstract class IsAsyncAction {
  Future<Null> handle(Store<AppState> store);
}
