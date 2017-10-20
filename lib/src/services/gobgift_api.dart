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

  GobgiftApi(this._authService);

  Future<List<Map<String, dynamic>>> getList(Type resourceType) async {
    List<Map<String, dynamic>> json;
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .get("$baseUrl/$resourcePath/")
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      json = JSON.decode(response.body);
    } else {
      throw response.body;
    }
    return json;
  }

  Future<Map<String, dynamic>> add(M model) async {
    Map<String, dynamic> json;
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .post("$baseUrl/$resourcePath/", body: JSON.encode(model))
        .whenComplete(oauthClient.close);

    if (response.statusCode == 201) {
      json = JSON.decode(response.body);
    } else {
      throw response.body;
    }
    return json;
  }

  Future<bool> delete(M model) async {
    bool _success;
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .delete("$baseUrl/$resourcePath/${model.id}/")
        .whenComplete(oauthClient.close);

    if (response.statusCode == 204) {
      _success = true;
    } else {
      throw response.body;
    }
    return _success;
  }
}

class GiftApi extends GobgiftApi<Gift> {
  GiftApi(AuthService authService) : super(authService);

  @override
  String get resourcePath => 'gifts';
}

class ListsApi extends GobgiftApi<WishList> {
  ListsApi(AuthService authService) : super(authService);

  @override
  String get resourcePath => 'lists';
}

class GroupsApi extends GobgiftApi<Group> {
  GroupsApi(AuthService authService) : super(authService);

  @override
  String get resourcePath => 'listgroups';
}
