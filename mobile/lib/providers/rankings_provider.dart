import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart' as api;
import 'package:mobile/providers/api_providers.dart';

// State class for rankings
class RankingsState {
  final List<RankedUser> rankings;
  final bool isLoading;
  final String? error;

  const RankingsState({
    this.rankings = const [],
    this.isLoading = false,
    this.error,
  });

  RankingsState copyWith({
    List<RankedUser>? rankings,
    bool? isLoading,
    String? error,
  }) {
    return RankingsState(
      rankings: rankings ?? this.rankings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<RankedUser> get topThree => rankings.take(3).toList();
  List<RankedUser> get remaining => rankings.skip(3).toList();
}

// Wrapper class for users with rank
class RankedUser {
  final api.User user;
  final int rank;

  const RankedUser({required this.user, required this.rank});

  String get displayName => '${user.firstName} ${user.lastName}';
  String get initials =>
      '${user.firstName[0]}${user.lastName[0]}'.toUpperCase();
}

// Provider for rankings state
final rankingsProvider = StateNotifierProvider<RankingsNotifier, RankingsState>(
  (ref) {
    final api = ref.watch(userApiProvider);
    return RankingsNotifier(api);
  },
);

class RankingsNotifier extends StateNotifier<RankingsState> {
  final api.UserApi _api;

  RankingsNotifier(this._api) : super(const RankingsState()) {
    loadRankings();
  }

  Future<void> loadRankings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _api.userControllerGetRankings();
      if (response.statusCode == 200 && response.data != null) {
        final rankedUsers = response.data!.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;
          return RankedUser(user: user, rank: index + 1);
        }).toList();

        state = state.copyWith(rankings: rankedUsers, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load rankings',
        );
      }
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }
}
