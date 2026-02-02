// @dart=3.9
import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for MatchesApi
void main() {
  final instance = Openapi().getMatchesApi();

  group(MatchesApi, () {
    //Future matchesControllerAddDiamond(CanPredictMatchDto canPredictMatchDto) async
    test('test matchesControllerAddDiamond', () async {
      // TODO
    });

    //Future<bool> matchesControllerCanPredict(String id, CanPredictMatchDto canPredictMatchDto) async
    test('test matchesControllerCanPredict', () async {
      // TODO
    });

    //Future matchesControllerEndMatch(String id, TerminateMatchDto terminateMatchDto) async
    test('test matchesControllerEndMatch', () async {
      // TODO
    });

    //Future<MatchStat> matchesControllerGetPredictionsStatsForMatch(String id) async
    test('test matchesControllerGetPredictionsStatsForMatch', () async {
      // TODO
    });

    //Future<num> matchesControllerGetUserGains() async
    test('test matchesControllerGetUserGains', () async {
      // TODO
    });

    //Future<JsonObject> matchesControllerGetUserPrediction(String id) async
    test('test matchesControllerGetUserPrediction', () async {
      // TODO
    });

    //Future<Prediction> matchesControllerMakePrediction(String id, PredictDto predictDto) async
    test('test matchesControllerMakePrediction', () async {
      // TODO
    });

    //Future matchesControllerUpdateMatch(String id, TerminateMatchDto terminateMatchDto) async
    test('test matchesControllerUpdateMatch', () async {
      // TODO
    });

    //Future<Prediction> matchesControllerUpdatePrediction(String id, UpdatePredictionDto updatePredictionDto) async
    test('test matchesControllerUpdatePrediction', () async {
      // TODO
    });

  });
}
