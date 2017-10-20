import 'package:gobgift_mobile/src/models/gift.dart';
import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:test/test.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';


main() {
  group('resourcePaths', () {
    test('should use resource type as map key', (){
      expect(resourcesPaths[Gift], 'gifts');
      expect(resourcesPaths[WishList], 'lists');
      expect(resourcesPaths[Group], 'listgroups');
    });
  });
}