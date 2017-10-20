import 'dart:async';
import 'dart:convert';

import 'package:gobgift_mobile/src/models/gift.dart';
import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';

abstract class RestResource {
  final int id = null;
}

Map<Type, String> resourcesPaths = {
  Gift: 'gifts',
  WishList: 'lists',
  Group: 'listgroups'
};

class GobgiftApi {
  final String baseUrl = 'https://gobgift.kimond.com/api';
  final AuthService _authService;

  GobgiftApi(this._authService);

  Future<List<Map<String, dynamic>>> getList<R extends RestResource>(Type resourceType) async {
    List<Map<String, dynamic>> json;
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .get("$baseUrl/${resourcesPaths[resourceType]}/")
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      json = JSON.decode(response.body);
    } else {
      throw response.body;
    }
    return json;
  }

  Future<Map<String, dynamic>> add<R extends RestResource>(R resource) async {
    Map<String, dynamic> json;
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .post("$baseUrl/${resourcesPaths[resource.runtimeType]}/", body: JSON.encode(resource))
        .whenComplete(oauthClient.close);

    if (response.statusCode == 201) {
      json = JSON.decode(response.body);
    } else {
      throw response.body;
    }
    return json;
  }

  Future<bool> delete<R extends RestResource>(R resource) async {
    bool _success;
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .delete("$baseUrl/${resourcesPaths[resource.runtimeType]}/${resource.id}/")
        .whenComplete(oauthClient.close);

    if (response.statusCode == 204) {
      _success = true;
    } else {
      throw response.body;
    }
    return _success;
  }
}
