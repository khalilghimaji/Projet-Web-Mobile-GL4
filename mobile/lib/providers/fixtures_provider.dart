import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fixture_models.dart';
import '../models/match_models.dart';
import '../services/football_api_service.dart';
import '../services/live_match_service.dart';

/// State for fixtures page
class FixturesState {
  final List<Fixture> fixtures;
  final List<League> allLeagues;
  final List<League> featuredLeagues;
  final DateTime selectedDate;
  final String selectedLeagueId;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const FixturesState({
    this.fixtures = const [],
    this.allLeagues = const [],
    this.featuredLeagues = const [],
    required this.selectedDate,
    this.selectedLeagueId = 'all',
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  FixturesState copyWith({
    List<Fixture>? fixtures,
    List<League>? allLeagues,
    List<League>? featuredLeagues,
    DateTime? selectedDate,
    String? selectedLeagueId,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return FixturesState(
      fixtures: fixtures ?? this.fixtures,
      allLeagues: allLeagues ?? this.allLeagues,
      featuredLeagues: featuredLeagues ?? this.featuredLeagues,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedLeagueId: selectedLeagueId ?? this.selectedLeagueId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Group fixtures by league
  List<FixturesByLeague> get fixturesByLeague {
    if (fixtures.isEmpty) return [];

    final grouped = <String, FixturesByLeague>{};

    for (final fixture in fixtures) {
      if (!grouped.containsKey(fixture.leagueKey)) {
        grouped[fixture.leagueKey] = FixturesByLeague(
          league: League(
            leagueKey: fixture.leagueKey,
            leagueName: fixture.leagueName,
            leagueLogo: fixture.leagueLogo,
            countryName: fixture.countryName,
          ),
          fixtures: [],
        );
      }
      // Add fixture to mutable list
      final existingGroup = grouped[fixture.leagueKey]!;
      grouped[fixture.leagueKey] = FixturesByLeague(
        league: existingGroup.league,
        fixtures: [...existingGroup.fixtures, fixture],
      );
    }

    return grouped.values.toList();
  }

  /// Generate date tabs (-2 to +2 days from today)
  List<DateTab> get dateTabs {
    final today = DateTime.now();
    final tabs = <DateTab>[];
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    for (int i = -2; i <= 2; i++) {
      final date = today.add(Duration(days: i));
      tabs.add(DateTab(
        date: date,
        dayName: dayNames[date.weekday % 7],
        dayNumber: date.day,
        isToday: i == 0,
      ));
    }

    return tabs;
  }

  /// Filter leagues by search query
  List<League> get filteredLeagues {
    if (searchQuery.isEmpty) return allLeagues;
    return allLeagues.where((league) {
      return league.leagueName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (league.countryName?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
    }).toList();
  }
}

/// Fixtures notifier
class FixturesNotifier extends StateNotifier<FixturesState> {
  final FootballApiService _apiService;

  FixturesNotifier(this._apiService) : super(FixturesState(selectedDate: DateTime.now())) {
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      loadLeagues(),
      loadFixtures(),
    ]);
  }

  Future<void> loadLeagues() async {
    try {
      final results = await Future.wait([
        _apiService.getAllLeagues(),
        _apiService.getFeaturedLeagues(),
      ]);

      state = state.copyWith(
        allLeagues: results[0],
        featuredLeagues: results[1],
      );
    } catch (e) {
      print('Error loading leagues: $e');
    }
  }

  Future<void> loadFixtures() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final dateStr = _formatDate(state.selectedDate);
      final fixtures = await _apiService.getFixtures(
        from: dateStr,
        to: dateStr,
        leagueId: state.selectedLeagueId == 'all' ? null : state.selectedLeagueId,
      );

      state = state.copyWith(
        fixtures: fixtures,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load fixtures',
      );
    }
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    loadFixtures();
  }

  void selectLeague(String leagueId) {
    state = state.copyWith(selectedLeagueId: leagueId);
    loadFixtures();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilter() {
    state = state.copyWith(selectedLeagueId: 'all', searchQuery: '');
    loadFixtures();
  }

  String _formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

/// Provider for fixtures state
final fixturesProvider = StateNotifierProvider<FixturesNotifier, FixturesState>((ref) {
  final apiService = ref.watch(footballApiServiceProvider);
  return FixturesNotifier(apiService);
});

/// State for match detail page
class MatchDetailState {
  final MatchData matchData;
  final PredictionData prediction;
  final bool isLoading;
  final String? error;
  final String activeTab;

  const MatchDetailState({
    required this.matchData,
    required this.prediction,
    this.isLoading = false,
    this.error,
    this.activeTab = 'OVERVIEW',
  });

  MatchDetailState copyWith({
    MatchData? matchData,
    PredictionData? prediction,
    bool? isLoading,
    String? error,
    String? activeTab,
  }) {
    return MatchDetailState(
      matchData: matchData ?? this.matchData,
      prediction: prediction ?? this.prediction,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}

/// Match detail notifier
class MatchDetailNotifier extends StateNotifier<MatchDetailState> {
  final FootballApiService _apiService;
  final LiveMatchService _liveService;
  final String matchId;

  MatchDetailNotifier(this._apiService, this._liveService, this.matchId)
      : super(MatchDetailState(
          matchData: MatchData.empty(),
          prediction: PredictionData.empty(),
        )) {
    loadMatchData();
    _subscribeToLiveEvents();
  }

  void _subscribeToLiveEvents() {
    _liveService.connect();
    _liveService.events.listen((event) {
      if (event['match_id']?.toString() == matchId) {
        _handleMatchUpdate(event);
      }
    });
  }

  void _handleMatchUpdate(Map<String, dynamic> event) {
    if (state.isLoading) return; // Maybe wait until loaded?

    MatchData updatedMatch = state.matchData;
    bool hasChanged = false;

    // Update Score
    int? homeScore;
    int? awayScore;

    if (event['match_hometeam_score'] != null) {
      homeScore = int.tryParse(event['match_hometeam_score'].toString());
    }
    if (event['match_awayteam_score'] != null) {
      awayScore = int.tryParse(event['match_awayteam_score'].toString());
    }

    if (homeScore != null || awayScore != null) {
      updatedMatch = updatedMatch.copyWith(
        header: updatedMatch.header.copyWith(
          score: updatedMatch.header.score.copyWith(
            home: homeScore ?? updatedMatch.header.score.home,
            away: awayScore ?? updatedMatch.header.score.away,
          )
        )
      );
      hasChanged = true;
    }

    // Update Status
    if (event['match_status'] != null) {
      updatedMatch = updatedMatch.copyWith(
        header: updatedMatch.header.copyWith(
          status: updatedMatch.header.status.copyWith(
            status: event['match_status'].toString(),
            // Update minute if available or if status implies something
            // event['minute'] check?
          )
        )
      );
      hasChanged = true;
    }

    // Handle Events (Goal, Card, Substitution)
    // Add to timeline
    // Use proper MatchEvent model
    // type: GOAL_SCORED -> EventType.goal

    final typeStr = event['type']?.toString();
    if (typeStr != null) {
       EventType? type;
       switch (typeStr) {
         case 'GOAL_SCORED': type = EventType.goal; break;
         case 'CARD_ISSUED':
           // Check if red or yellow? Usually detail in event
           type = EventType.yellowCard;
           break;
         case 'SUBSTITUTION': type = EventType.substitution; break;
       }

       if (type != null) {
          // Construct MatchEvent
          // Need to parse minute, team, player
          // This is intricate without detailed event payload knowledge
          // For now, logging and minimal update is good.
          // Ideally we append to timeline
       }
    }

    if (hasChanged) {
      state = state.copyWith(matchData: updatedMatch);
    }
  }

  Future<void> loadMatchData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final matchData = await _apiService.getMatchDetails(matchId);
      state = state.copyWith(
        matchData: matchData,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load match details',
      );
    }
  }

  void setActiveTab(String tab) {
    state = state.copyWith(activeTab: tab);
  }

  void updatePrediction(PredictionData prediction) {
    state = state.copyWith(prediction: prediction);
  }
}

/// Provider family for match detail state
final matchDetailProvider = StateNotifierProvider.family<MatchDetailNotifier, MatchDetailState, String>((ref, matchId) {
  final apiService = ref.watch(footballApiServiceProvider);
  final liveService = ref.watch(liveMatchServiceProvider);
  return MatchDetailNotifier(apiService, liveService, matchId);
});

