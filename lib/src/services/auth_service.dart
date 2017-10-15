import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

const ApiBaseUrl = "https://gobgift.kimond.com";

class AuthProvider {
  final String authProviderAsString;

  AuthProvider._(this.authProviderAsString);

  static final AuthProvider facebook = new AuthProvider._('facebook');
  static final AuthProvider google = new AuthProvider._('google');
}

class AuthService {
  static const String KEY_OAUTH_TOKEN = 'KEY_AUTH_TOKEN';

  bool loggedIn;
  bool _initialized;
  final Client _client = new Client();
  OauthClient _oauthClient;

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String oauthToken = prefs.getString(KEY_OAUTH_TOKEN);
    print(oauthToken);

    if (oauthToken == null) {
      loggedIn = false;
      await logout();
    } else {
      loggedIn = true;
      _oauthClient = new OauthClient(_client, oauthToken);
    }

    _initialized = true;
  }

  Future logout() async {
    await _saveTokens(null);
    loggedIn = false;
  }

  Future<bool> login(AuthProvider provider, String providerToken) async {
    final String authUrl = '$ApiBaseUrl/rest-auth/${provider
        .authProviderAsString}/';
    final requestHeader = {'Content-type': 'application/json'};
    final requestBody = JSON.encode({
      'access_token': providerToken,
    });

    final loginResponse = await _client
        .post(authUrl, headers: requestHeader, body: requestBody)
        .whenComplete(_client.close);

    if (loginResponse.statusCode == 200) {
      final bodyJson = JSON.decode(loginResponse.body);
      await _saveTokens(bodyJson['key']);
      loggedIn = true;
    } else {
      loggedIn = false;
    }

    return loggedIn;
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
