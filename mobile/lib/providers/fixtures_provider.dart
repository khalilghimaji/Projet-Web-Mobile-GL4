import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fixture_models.dart';
import '../models/match_models.dart';
import '../services/football_api_service.dart';
import '../services/live_match_service.dart';
import '../utils/match_utils.dart';
import 'dart:async';

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
  StreamSubscription<Map<String, dynamic>>? _subscription;
  bool _isWebSocketConnected = false;

  MatchDetailNotifier(this._apiService, this._liveService, this.matchId)
      : super(MatchDetailState(
          matchData: MatchData.empty(),
          prediction: PredictionData.empty(),
        )) {
    loadMatchData();
    _subscribeToLiveEvents();
  }

  @override
  void dispose() {
    _unsubscribeFromLiveEvents();
    super.dispose();
  }

  void _unsubscribeFromLiveEvents() {
    _subscription?.cancel();
    _subscription = null;
    _isWebSocketConnected = false;
  }

  void _subscribeToLiveEvents() {
    // Cancel existing subscription if any
    _subscription?.cancel();

    // Connect to WebSocket
    _liveService.connect();
    _isWebSocketConnected = true;

    _subscription = _liveService.events.listen(
      (event) {
        print('[MatchDetail] Received event: $event');
        if (event['match_id']?.toString() == matchId) {
          _handleMatchUpdate(event);
        }
      },
      onError: (error) {
        print('[MatchDetail] WebSocket error: $error');
        _isWebSocketConnected = false;
        // Try to reconnect after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _subscribeToLiveEvents();
          }
        });
      },
    );
  }

  /// Reconnect to WebSocket if disconnected
  void ensureWebSocketConnection() {
    if (!_isWebSocketConnected || !_liveService.isConnected) {
      print('[MatchDetail] Reconnecting WebSocket...');
      _subscribeToLiveEvents();
    }
  }

  void _handleMatchUpdate(Map<String, dynamic> event) {
    // If not loaded yet, we can't really update anything meaningful
    if (state.isLoading || state.matchData.header.homeTeam.id.isEmpty) return;

    MatchData updatedMatch = state.matchData;
    bool hasChanged = false;

    final typeStr = event['type']?.toString();
    print('[MatchDetail] Processing event type: $typeStr');

    switch (typeStr) {
      case 'GOAL_SCORED':
        final goalMinute = _parseMinuteString(event['minute']?.toString() ?? '');
        final team = event['team']?.toString() == 'home' ? TeamSide.home : TeamSide.away;
        final scorer = event['scorer']?.toString() ?? 'Unknown';

        // Update score
        updatedMatch = updatedMatch.copyWith(
          header: updatedMatch.header.copyWith(
            status: updatedMatch.header.status.copyWith(minute: goalMinute),
            score: updatedMatch.header.score.copyWith(
              home: team == TeamSide.home
                  ? updatedMatch.header.score.home + 1
                  : updatedMatch.header.score.home,
              away: team == TeamSide.away
                  ? updatedMatch.header.score.away + 1
                  : updatedMatch.header.score.away,
            ),
          ),
        );

        // Add to timeline
        final goalEvent = MatchEvent(
          id: 'event-goal-${event['minute']}-$scorer',
          minute: goalMinute,
          type: EventType.goal,
          team: team,
          player: scorer,
          detail: event['assist']?.toString(),
        );
        updatedMatch = updatedMatch.copyWith(
          timeline: [...updatedMatch.timeline, goalEvent],
        );
        hasChanged = true;
        break;

      case 'CARD_ISSUED':
        final cardMinute = _parseMinuteString(event['minute']?.toString() ?? '');
        final team = event['team']?.toString() == 'home' ? TeamSide.home : TeamSide.away;
        final player = event['player']?.toString() ?? 'Unknown';
        final cardType = event['card_type']?.toString() == 'red card'
            ? EventType.redCard
            : EventType.yellowCard;

        updatedMatch = updatedMatch.copyWith(
          header: updatedMatch.header.copyWith(
            status: updatedMatch.header.status.copyWith(minute: cardMinute),
          ),
        );

        final cardEvent = MatchEvent(
          id: 'event-card-${event['minute']}-$player',
          minute: cardMinute,
          type: cardType,
          team: team,
          player: player,
        );
        updatedMatch = updatedMatch.copyWith(
          timeline: [...updatedMatch.timeline, cardEvent],
        );
        hasChanged = true;
        break;

      case 'SUBSTITUTION':
        final subMinute = _parseMinuteString(event['minute']?.toString() ?? '');
        final team = event['team']?.toString() == 'home' ? TeamSide.home : TeamSide.away;
        final playerIn = event['player_in']?.toString() ?? 'Unknown';
        final playerOut = event['player_out']?.toString() ?? '';

        updatedMatch = updatedMatch.copyWith(
          header: updatedMatch.header.copyWith(
            status: updatedMatch.header.status.copyWith(minute: subMinute),
          ),
        );

        final subEvent = MatchEvent(
          id: 'event-substitution-${event['minute']}-$playerIn',
          minute: subMinute,
          type: EventType.substitution,
          team: team,
          player: playerIn,
          detail: playerOut.isNotEmpty ? 'OUT: $playerOut' : null,
        );
        updatedMatch = updatedMatch.copyWith(
          timeline: [...updatedMatch.timeline, subEvent],
        );
        hasChanged = true;
        break;

      case 'MATCH_ENDED':
        updatedMatch = updatedMatch.copyWith(
          header: updatedMatch.header.copyWith(
            status: updatedMatch.header.status.copyWith(
              minute: 0,
              isLive: false,
              status: 'FT',
            ),
          ),
        );
        hasChanged = true;
        break;

      case 'HALF_TIME':
        updatedMatch = updatedMatch.copyWith(
          header: updatedMatch.header.copyWith(
            status: updatedMatch.header.status.copyWith(
              minute: 0,
              isLive: true,
              status: 'HT',
            ),
          ),
        );
        hasChanged = true;
        break;

      case 'SECOND_HALF_STARTED':
        updatedMatch = updatedMatch.copyWith(
          header: updatedMatch.header.copyWith(
            status: updatedMatch.header.status.copyWith(
              isLive: true,
              status: 'LIVE',
              minute: 46,
            ),
          ),
        );
        hasChanged = true;
        break;

      case 'MATCH_STARTED':
        final startTime = event['start_time'] != null
            ? DateTime.tryParse(event['start_time'].toString())
            : null;
        final minute = startTime != null
            ? ((DateTime.now().millisecondsSinceEpoch -
                        startTime.millisecondsSinceEpoch) ~/
                    60000)
                .clamp(0, 90)
            : 0;

        updatedMatch = updatedMatch.copyWith(
          header: updatedMatch.header.copyWith(
            status: updatedMatch.header.status.copyWith(
              isLive: true,
              status: 'LIVE',
              minute: minute,
            ),
          ),
        );
        hasChanged = true;
        break;

      case 'SCORE_UPDATE':
        final scoreStr = event['score']?.toString() ?? '0-0';
        final parts = scoreStr.split('-');
        final homeScore = int.tryParse(parts[0]) ?? 0;
        final awayScore = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

        updatedMatch = updatedMatch.copyWith(
          header: updatedMatch.header.copyWith(
            score: updatedMatch.header.score.copyWith(
              home: homeScore,
              away: awayScore,
            ),
          ),
        );
        hasChanged = true;
        break;

      default:
        // Handle legacy format with match_hometeam_score, match_awayteam_score, match_status
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
              ),
            ),
          );
          hasChanged = true;
        }

        if (event['match_status'] != null) {
          final rawStatus = event['match_status'].toString();
          final rawLive = event['match_live']?.toString() ??
              (state.matchData.header.status.isLive ? '1' : '0');

          final result = MatchUtils.parseStatus(rawStatus, rawLive);

          updatedMatch = updatedMatch.copyWith(
            header: updatedMatch.header.copyWith(
              status: updatedMatch.header.status.copyWith(
                status: result.status,
                minute: result.minute,
                isLive: result.isLive,
              ),
            ),
          );
          hasChanged = true;
        }
        break;
    }

    if (hasChanged) {
      // Sort timeline by minute
      final sortedTimeline = List<MatchEvent>.from(updatedMatch.timeline)
        ..sort((a, b) => a.minute.compareTo(b.minute));
      updatedMatch = updatedMatch.copyWith(timeline: sortedTimeline);

      state = state.copyWith(matchData: updatedMatch);
      print('[MatchDetail] State updated with new match data');
    }
  }

  /// Parse minute string handling formats like "45+2"
  int _parseMinuteString(String timeStr) {
    if (timeStr.isEmpty) return 0;
    if (timeStr.contains('+')) {
      final parts = timeStr.split('+');
      return (int.tryParse(parts[0]) ?? 0) + (int.tryParse(parts[1]) ?? 0);
    }
    return int.tryParse(timeStr.replaceAll("'", '')) ?? 0;
  }

  Future<void> loadMatchData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final matchData = await _apiService.getMatchDetails(matchId);
      state = state.copyWith(
        matchData: matchData,
        isLoading: false,
      );

      // Ensure WebSocket is connected after data load
      ensureWebSocketConnection();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load match details',
      );
    }
  }

  /// Refresh match data and reconnect to WebSocket
  Future<void> refresh() async {
    // Ensure WebSocket connection
    ensureWebSocketConnection();

    // Reload data
    await loadMatchData();
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
