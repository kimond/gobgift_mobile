import 'dart:async';
import 'dart:convert';

import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';

class GobgiftApi {
  final String baseUrl = 'https://gobgift.kimond.com/api';
  final AuthService _authService;

  GobgiftApi(this._authService);

  Future<List<Group>> getGroups() async {
    List<Group> groups = [];
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .get("$baseUrl/listgroups/")
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      var json = JSON.decode(response.body);
      groups = json.map((groupJson){
        return new Group.fromJson(groupJson);
      }).toList();
    } else {
      throw response.body;
    }
    return groups;
  }

  Future<List<WishList>> getWishLists() async {
    List<WishList> wishLists = [];
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .get("$baseUrl/lists/")
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      var json = JSON.decode(response.body);
      wishLists = json.map((groupJson){
        return new WishList.fromJson(groupJson);
      }).toList();
    } else {
      throw response.body;
    }
    return wishLists;
  }
}
