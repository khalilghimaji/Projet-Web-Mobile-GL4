import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AppApi
void main() {
  final instance = Openapi().getAppApi();

  group(AppApi, () {
    //Future<String> appControllerGetHello() async
    test('test appControllerGetHello', () async {
      // TODO
    });

    //Future appControllerUploadFile({ MultipartFile file }) async
    test('test appControllerUploadFile', () async {
      // TODO
    });

  });
}
