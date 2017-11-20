import 'package:gobgift_mobile/src/app_state/actions.dart';
import 'package:gobgift_mobile/src/models/gift.dart';
import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:redux/redux.dart';

class CurrentGroupState {
  final Group group;
  final List<WishList> wishLists;

  CurrentGroupState({this.group, this.wishLists});

  CurrentGroupState.initial()
      : group = null,
        wishLists = [];

  CurrentGroupState apply({Group group, List<WishList> wishLists}) {
    return new CurrentGroupState(
        wishLists: wishLists ?? this.wishLists, group: group ?? this.group);
  }
}

class CurrentWishListState {
  final WishList wishList;
  final List<Gift> gifts;
  final bool isLoading;

  CurrentWishListState({this.wishList, this.gifts, this.isLoading});

  CurrentWishListState.initial()
      : wishList = null,
        gifts = [],
        isLoading = false;

  CurrentWishListState apply(
      {WishList wishList, List<Gift> gifts, bool isLoading}) {
    return new CurrentWishListState(
        wishList: wishList ?? this.wishList,
        gifts: gifts ?? this.gifts,
        isLoading: isLoading ?? this.isLoading);
  }
}

class AppState {
  final List<Group> groups;
  final List<WishList> wishLists;
  final CurrentWishListState selectedList;
  final CurrentGroupState selectedGroup;

  AppState.initial()
      : groups = [],
        wishLists = [],
        selectedList = new CurrentWishListState.initial(),
        selectedGroup = new CurrentGroupState.initial();

  AppState._(
      {this.groups, this.wishLists, this.selectedList, this.selectedGroup});

  AppState apply(
      {List<Group> groups,
      List<WishList> wishLists,
      CurrentWishListState selectedList,
      CurrentGroupState selectedGroup}) {
    return new AppState._(
        groups: groups ?? this.groups,
        wishLists: wishLists ?? this.wishLists,
        selectedList: selectedList ?? this.selectedList,
        selectedGroup: selectedGroup ?? this.selectedGroup);
  }
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
