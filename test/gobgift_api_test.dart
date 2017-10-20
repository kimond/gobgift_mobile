import 'package:gobgift_mobile/services.dart';
import 'package:test/test.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:mockito/mockito.dart';

class AuthServiceMock extends Mock implements AuthService {}

main() {
  group('resourcePaths', () {
    final authApi = new AuthServiceMock();

    test('Lists API has correct path', () {
      expect(new ListsApi(authApi).resourcePath, 'lists');
    });

    test('Gifts API has correct path', () {
      expect(new GiftApi(authApi).resourcePath, 'gifts');
    });

    test('Groups API has correct path', () {
      expect(new GroupsApi(authApi).resourcePath, 'listgroups');
    });
  });
}
