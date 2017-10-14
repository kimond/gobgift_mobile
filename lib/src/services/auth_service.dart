import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

const ApiBaseUrl = "http://gobgift.kimond.com";

class AuthProvider {
  final String  authProviderAsString;

  AuthProvider._(this.authProviderAsString);

  static final AuthProvider facebook = new AuthProvider._('facebook');
  static final AuthProvider google = new AuthProvider._('google');
}

class AuthService {
  static const String KEY_OAUTH_TOKEN = 'KEY_AUTH_TOKEN';

  bool _loggedIn;
  bool _initialized;
  Client _client;
  OauthClient _oauthClient;

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String oauthToken = prefs.getString(KEY_OAUTH_TOKEN);

    if (oauthToken == null) {
      _loggedIn = false;
      await logout();
    } else {
      _loggedIn = true;
      _oauthClient = new OauthClient(_client, oauthToken);
    }

    _initialized = true;
  }

  Future logout() async {
    await _saveTokens(null);
    _loggedIn = false;
  }

  Future<bool> login(AuthProvider provider, String providerToken) async {
    final requestBody = JSON.encode({
      'access_token': providerToken,
    });

    final loginResponse = await _client.post(
        '$ApiBaseUrl/${provider.authProviderAsString}/',
        body: requestBody)
        .whenComplete(_client.close);

    if (loginResponse.statusCode == 201) {
      final bodyJson = JSON.decode(loginResponse.body);
      await _saveTokens(bodyJson['token']);
      _loggedIn = true;
    } else {
      _loggedIn = false;
    }

    return _loggedIn;
  }

  Future _saveTokens(String oauthToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY_OAUTH_TOKEN, oauthToken);
    await prefs.commit();
    _oauthClient = new OauthClient(_client, oauthToken);
  }
}

class OauthClient extends _AuthClient {
  OauthClient(Client client, String token) : super(client, 'token ${token}');
}

abstract class _AuthClient extends BaseClient {
  final Client _client;
  final String _authorization;

  _AuthClient(this._client, this._authorization);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['Authorization'] = _authorization;
    return _client.send(request);
  }
}
