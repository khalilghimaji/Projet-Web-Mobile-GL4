import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/api_providers.dart';
import 'package:openapi/openapi.dart' as api;
import 'package:built_collection/built_collection.dart';

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
  final String? id;
  final String firstName;
  final String lastName;
  final String? email;
  final int score;
  final String? imageUrl;

  const RankingUser({
    this.id,
    required this.firstName,
    required this.lastName,
    this.email,
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
  (ref) => RankingsNotifier(ref),
);

class RankingsNotifier extends StateNotifier<RankingsState> {
  final Ref _ref;

  RankingsNotifier(this._ref) : super(const RankingsState());

  Future<void> loadRankings() async {
    // Prevent multiple simultaneous calls
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      print("Starting rankings API call...");
      // Use Dio directly to avoid deserialization issues with the User model
      final dio = _ref.read(dioProvider);
      final response = await dio
          .get('/user/rankings')
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timed out after 10 seconds');
            },
          );
      print("Rankings API call completed with status: ${response.statusCode}");
      print("Rankings response data: ${response.data}");
      if (response.statusCode == 200 && response.data != null) {
        final usersData = response.data as List<dynamic>;
        print("Processing ${usersData.length} users from rankings");
        final rankedUsers = usersData.asMap().entries.map((entry) {
          final index = entry.key;
          final userData = entry.value as Map<String, dynamic>;
          final rankingUser = RankingUser(
            id: userData['id'] as String?,
            firstName: userData['firstName'] as String? ?? 'Unknown',
            lastName: userData['lastName'] as String? ?? 'User',
            email: userData['email'] as String?,
            score: (userData['score'] as num?)?.toInt() ?? 0,
            imageUrl: userData['imageUrl'] as String?,
          );
          return RankedUser(user: rankingUser, rank: index + 1);
        }).toList();

        print("Successfully processed ${rankedUsers.length} ranked users");
        state = state.copyWith(rankings: rankedUsers, isLoading: false);
      } else {
        final errorMsg = 'Failed to load rankings: HTTP ${response.statusCode}';
        print(errorMsg);
        state = state.copyWith(isLoading: false, error: errorMsg);
      }
    } catch (error) {
      print("Rankings error: $error");
      print("Error type: ${error.runtimeType}");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load rankings: ${error.toString()}',
      );
    }
  }

  void updateRankings(
    BuiltList<api.NotificationDataAnyOf1RankingsInner> rankings,
  ) {
    final rankedUsers = rankings.asMap().entries.map((entry) {
      final index = entry.key;
      final userData = entry.value;
      final user = RankingUser(
        id: null, // Not provided by API
        firstName: userData.firstName ?? 'Unknown',
        lastName: userData.lastName ?? 'User',
        email: null, // Not provided by API
        score: (userData.score ?? 0).toInt(),
        imageUrl: userData.imageUrl,
      );
      return RankedUser(user: user, rank: index + 1);
    }).toList();

    state = state.copyWith(rankings: rankedUsers);
  }
}
