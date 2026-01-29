// @dart=3.9
import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for UserApi
void main() {
  final instance = Openapi().getUserApi();

  group(UserApi, () {
    //Future<BuiltList<User>> userControllerGetRankings() async
    test('test userControllerGetRankings', () async {
      // TODO
    });

  });
}
