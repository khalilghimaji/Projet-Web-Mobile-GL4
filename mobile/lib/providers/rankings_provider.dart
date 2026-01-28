import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
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

// Simple user model for rankings
class RankingUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final int score;
  final String? imageUrl;

  const RankingUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.score,
    this.imageUrl,
  });

  String get displayName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
}

// Wrapper class for users with rank
class RankedUser {
  final RankingUser user;
  final int rank;

  const RankedUser({required this.user, required this.rank});

  String get displayName => '${user.firstName} ${user.lastName}';
  String get initials =>
      '${user.firstName[0]}${user.lastName[0]}'.toUpperCase();
}

// Provider for rankings state
final rankingsProvider = StateNotifierProvider<RankingsNotifier, RankingsState>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return RankingsNotifier(dio);
  },
);

class RankingsNotifier extends StateNotifier<RankingsState> {
  final Dio _dio;

  RankingsNotifier(this._dio) : super(const RankingsState()) {
    loadRankings();
  }

  Future<void> loadRankings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _dio.get('/user/rankings');
      print("Rankings response: ${response.data}");
      if (response.statusCode == 200 && response.data != null) {
        final users = response.data as List;
        final rankedUsers = users.asMap().entries.map((entry) {
          final index = entry.key;
          final userData = entry.value as Map<String, dynamic>;
          final user = RankingUser(
            id: userData['id']?.toString() ?? '',
            firstName: userData['firstName'] ?? '',
            lastName: userData['lastName'] ?? '',
            email: userData['email'] ?? '',
            score: (userData['score'] as num?)?.toInt() ?? 0,
            imageUrl: userData['imageUrl'] as String?,
          );
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
      print("Rankings error: $error");
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }
}
