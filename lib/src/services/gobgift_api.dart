import 'dart:async';
import 'dart:convert';

import 'package:gobgift_mobile/src/models/gift.dart';
import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';

abstract class RestResource {
  int get id;
}

abstract class GobgiftApi<M extends RestResource> {
  final String baseUrl = 'https://gobgift.kimond.com/api';
  final AuthService _authService;

  String get resourcePath;

  M Function(Map<String, dynamic> json) get reviver;

  GobgiftApi(this._authService);

  Future<List<M>> getList() async {
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .get("$baseUrl/$resourcePath/")
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> json = JSON.decode(response.body);
      return json.map(reviver).toList();
    } else {
      throw response.body;
    }
  }

  Future<M> add(M model) async {
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .post("$baseUrl/$resourcePath/", body: JSON.encode(model))
        .whenComplete(oauthClient.close);

    if (response.statusCode == 201) {
      var body = response.body;
      Map<String, dynamic> json = JSON.decode(body);
      var decoded = reviver(json);
      return decoded;
    } else {
      throw response.body;
    }
  }

  Future<bool> delete(M model) async {
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .delete("$baseUrl/$resourcePath/${model.id}/")
        .whenComplete(oauthClient.close);

    if (response.statusCode == 204) {
      return true;
    } else {
      throw response.body;
    }
  }
}

class GiftApi extends GobgiftApi<Gift> {
  GiftApi(AuthService authService) : super(authService);

  @override
  String get resourcePath => 'gifts';

  @override
  Gift Function(Map<String, dynamic>) get reviver =>
      (json) => new Gift.fromJson(json);
}

class ListsApi extends GobgiftApi<WishList> {
  ListsApi(AuthService authService) : super(authService);

  @override
  String get resourcePath => 'lists';

  @override
  WishList Function(Map<String, dynamic>) get reviver =>
      (json) => new WishList.fromJson(json);

  Future<List<Gift>> getGifts(WishList wishList) async {
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .get("$baseUrl/$resourcePath/${wishList.id}/gifts")
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> json = JSON.decode(response.body);
      return json.map((json) => new Gift.fromJson(json)).toList();
    } else {
      throw response.body;
    }
  }
}

class GroupsApi extends GobgiftApi<Group> {
  GroupsApi(AuthService authService) : super(authService);

  @override
  String get resourcePath => 'listgroups';

  @override
  Group Function(Map<String, dynamic>) get reviver =>
      (json) => new Group.fromJson(json);
}
