import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gobgift_mobile/src/models/gift.dart';
import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:http/http.dart';

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

  Future<Gift> addWithPhoto(Gift model, File photo) async {
    final uri = Uri.parse("$baseUrl/$resourcePath/");
    final request = new MultipartRequest("POST", uri);
    request.fields['name'] = model.name;
    request.fields['wishlist'] = model.wishList.toString();
    request.fields['description'] = model.description;
    if (model.price != null) {
      request.fields['price'] = model.price.toString();
    }
    request.fields['website'] = model.website;
    request.fields['store'] = model.store;
    request.files.add(
      await MultipartFile.fromPath('photo', photo.path),
    );
    request.headers['Authorization'] = 'token ${_authService.oauthToken}';

    final response = await request.send();
    if (response.statusCode == 201) {
      var body = await response.stream.bytesToString();
      Map<String, dynamic> json = JSON.decode(body);
      var decoded = reviver(json);
      return decoded;
    } else {
      throw await response.stream.bytesToString();
    }
  }
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

  Future<List<WishList>> getLists(Group group) async {
    final oauthClient = _authService.oauthClient;
    var response = await oauthClient
        .get("$baseUrl/$resourcePath/${group.id}/lists")
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> json = JSON.decode(response.body);
      return json.map((json) => new WishList.fromJson(json)).toList();
    } else {
      throw response.body;
    }
  }
}
