// @dart=3.9
import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for TestApi
void main() {
  final instance = Openapi().getTestApi();

  group(TestApi, () {
    //Future testControllerAddDiamond(String userId, CanPredictMatchDto canPredictMatchDto) async
    test('test testControllerAddDiamond', () async {
      // TODO
    });

    //Future testControllerEndMatch(String id, TerminateMatchDto terminateMatchDto) async
    test('test testControllerEndMatch', () async {
      // TODO
    });

    //Future<Prediction> testControllerMakePrediction(String userId, String matchId, PredictDto predictDto) async
    test('test testControllerMakePrediction', () async {
      // TODO
    });

    //Future testControllerUpdateMatch(String id, TerminateMatchDto terminateMatchDto) async
    test('test testControllerUpdateMatch', () async {
      // TODO
    });

  });
}
