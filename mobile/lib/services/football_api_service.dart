import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fixture_models.dart';
import '../models/match_models.dart';

/// AllSports API configuration
class AllSportsApiConfig {
  static const String baseUrl = 'https://apiv2.allsportsapi.com/football/';
  static const String apiKey = 'ba546426f762661fc2717d3d48459ad34508a34448b5d43c29a5af0f38e72b39';

  // Featured league IDs
  static const List<String> featuredLeagueIds = ['152', '302', '207', '175', '168'];
}

/// Football API Service for AllSports API
class FootballApiService {
  final Dio _dio;

  FootballApiService(this._dio);

  /// Get fixtures for a date range
  Future<List<Fixture>> getFixtures({
    required String from,
    required String to,
    String? leagueId,
  }) async {
    try {
      String url = '${AllSportsApiConfig.baseUrl}?met=Fixtures&APIkey=${AllSportsApiConfig.apiKey}&from=$from&to=$to';

      if (leagueId != null && leagueId != 'all') {
        url += '&leagueId=$leagueId';
      }

      final response = await _dio.get(url);

      if (response.data['success'] == 1 && response.data['result'] != null) {
        final List<dynamic> results = response.data['result'];
        return results.map((json) => Fixture.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Error fetching fixtures: $e');
      return [];
    }
  }

  /// Get live matches
  Future<List<Fixture>> getLiveMatches() async {
    try {
      final url = '${AllSportsApiConfig.baseUrl}?met=Livescore&APIkey=${AllSportsApiConfig.apiKey}';
      final response = await _dio.get(url);

      if (response.data['success'] == 1 && response.data['result'] != null) {
        final List<dynamic> results = response.data['result'];
        return results.map((json) => Fixture.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Error fetching live matches: $e');
      return [];
    }
  }

  /// Get all leagues
  Future<List<League>> getAllLeagues() async {
    try {
      final url = '${AllSportsApiConfig.baseUrl}?met=Leagues&APIkey=${AllSportsApiConfig.apiKey}';
      final response = await _dio.get(url);

      if (response.data['success'] == 1 && response.data['result'] != null) {
        final List<dynamic> results = response.data['result'];
        return results.map((json) => League.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Error fetching leagues: $e');
      return [];
    }
  }

  /// Get featured leagues
  Future<List<League>> getFeaturedLeagues() async {
    final allLeagues = await getAllLeagues();

    final featured = allLeagues.where(
      (league) => AllSportsApiConfig.featuredLeagueIds.contains(league.leagueKey)
    ).toList();

    // Sort by featured order
    featured.sort((a, b) {
      final indexA = AllSportsApiConfig.featuredLeagueIds.indexOf(a.leagueKey);
      final indexB = AllSportsApiConfig.featuredLeagueIds.indexOf(b.leagueKey);
      return indexA.compareTo(indexB);
    });

    return featured;
  }

  /// Get match details
  Future<MatchData> getMatchDetails(String matchId) async {
    try {
      // Fetch general info
      final generalInfoUrl = '${AllSportsApiConfig.baseUrl}?met=Fixtures&APIkey=${AllSportsApiConfig.apiKey}&matchId=$matchId';
      final generalInfoResponse = await _dio.get(generalInfoUrl);

      Map<String, dynamic>? matchJson;
      if (generalInfoResponse.data['success'] == 1 && generalInfoResponse.data['result'] != null) {
        final results = generalInfoResponse.data['result'];
        if (results is List && results.isNotEmpty) {
          matchJson = results[0];
        }
      }

      if (matchJson == null) {
        return MatchData.empty();
      }

      // Fetch videos
      List<VideoHighlight> highlights = [];
      try {
        final videosUrl = '${AllSportsApiConfig.baseUrl}?met=Videos&APIkey=${AllSportsApiConfig.apiKey}&eventId=$matchId';
        final videosResponse = await _dio.get(videosUrl);

        if (videosResponse.data['success'] == 1 && videosResponse.data['result'] != null) {
          final List<dynamic> videoResults = videosResponse.data['result'];
          highlights = videoResults.map((v) => VideoHighlight(
            id: v['video_id']?.toString() ?? '',
            title: v['video_title'] ?? '',
            thumbnail: v['video_thumbnail'],
            duration: v['video_duration'],
            url: v['video_url'] ?? '',
          )).toList();
        }
      } catch (e) {
        print('Error fetching videos: $e');
      }

      // Fetch H2H
      HeadToHead h2h = HeadToHead.empty();
      try {
        final homeTeamKey = matchJson['home_team_key']?.toString();
        final awayTeamKey = matchJson['away_team_key']?.toString();

        if (homeTeamKey != null && awayTeamKey != null) {
          final h2hUrl = '${AllSportsApiConfig.baseUrl}?met=H2H&APIkey=${AllSportsApiConfig.apiKey}&firstTeamId=$homeTeamKey&secondTeamId=$awayTeamKey';
          final h2hResponse = await _dio.get(h2hUrl);

          if (h2hResponse.data['success'] == 1 && h2hResponse.data['result'] != null) {
            h2h = _parseH2H(h2hResponse.data['result'], matchJson['home_team_logo'], matchJson['away_team_logo']);
          }
        }
      } catch (e) {
        print('Error fetching H2H: $e');
      }

      return MatchData(
        header: _parseMatchHeader(matchJson),
        timeline: _parseTimeline(matchJson),
        lineups: _parseLineups(matchJson),
        stats: _parseStats(matchJson),
        h2h: h2h,
        highlights: highlights,
      );
    } catch (e) {
      print('Error fetching match details: $e');
      return MatchData.empty();
    }
  }

  MatchHeader _parseMatchHeader(Map<String, dynamic> json) {
    final eventLive = json['event_live']?.toString() ?? '0';
    final eventStatus = json['event_status']?.toString() ?? '';

    bool isLive = eventLive == '1';
    String status = 'SCHEDULED';
    int minute = 0;

    if (isLive) {
      if (eventStatus == 'Half Time') {
        status = 'HT';
      } else {
        status = 'LIVE';
        minute = int.tryParse(eventStatus.replaceAll("'", '').trim()) ?? 0;
      }
    } else if (eventStatus == 'Finished') {
      status = 'FT';
    }

    // Parse score
    int homeScore = 0;
    int awayScore = 0;
    final finalResult = json['event_final_result']?.toString() ?? '';
    if (finalResult.isNotEmpty && finalResult != '-') {
      final parts = finalResult.split('-');
      if (parts.length == 2) {
        homeScore = int.tryParse(parts[0].trim()) ?? 0;
        awayScore = int.tryParse(parts[1].trim()) ?? 0;
      }
    }

    return MatchHeader(
      status: MatchStatus(
        isLive: isLive,
        minute: minute,
        status: status,
        competition: json['league_name'] ?? '',
      ),
      homeTeam: TeamInfo(
        id: json['home_team_key']?.toString() ?? '',
        name: json['event_home_team'] ?? '',
        shortName: _getShortName(json['event_home_team'] ?? ''),
        logo: json['home_team_logo'],
      ),
      awayTeam: TeamInfo(
        id: json['away_team_key']?.toString() ?? '',
        name: json['event_away_team'] ?? '',
        shortName: _getShortName(json['event_away_team'] ?? ''),
        logo: json['away_team_logo'],
      ),
      score: MatchScore(
        home: homeScore,
        away: awayScore,
        venue: json['event_stadium'],
      ),
    );
  }

  String _getShortName(String fullName) {
    if (fullName.length <= 3) return fullName.toUpperCase();
    return fullName.substring(0, 3).toUpperCase();
  }

  List<MatchEvent> _parseTimeline(Map<String, dynamic> json) {
    final List<MatchEvent> events = [];
    int eventId = 0;

    // Parse goalscorers
    final goalscorers = json['goalscorers'] as List<dynamic>? ?? [];
    for (final goal in goalscorers) {
      events.add(MatchEvent(
        id: 'goal_${eventId++}',
        minute: _parseMinute(goal['time']?.toString() ?? ''),
        type: EventType.goal,
        team: goal['home_scorer']?.toString().isNotEmpty == true ? TeamSide.home : TeamSide.away,
        player: goal['home_scorer']?.toString().isNotEmpty == true
            ? goal['home_scorer'].toString()
            : goal['away_scorer']?.toString() ?? '',
        detail: goal['home_assist']?.toString().isNotEmpty == true
            ? 'Assist: ${goal['home_assist']}'
            : goal['away_assist']?.toString().isNotEmpty == true
                ? 'Assist: ${goal['away_assist']}'
                : null,
      ));
    }

    // Parse cards
    final cards = json['cards'] as List<dynamic>? ?? [];
    for (final card in cards) {
      final isYellow = card['card']?.toString().toLowerCase().contains('yellow') ?? false;
      events.add(MatchEvent(
        id: 'card_${eventId++}',
        minute: _parseMinute(card['time']?.toString() ?? ''),
        type: isYellow ? EventType.yellowCard : EventType.redCard,
        team: card['home_fault']?.toString().isNotEmpty == true ? TeamSide.home : TeamSide.away,
        player: card['home_fault']?.toString().isNotEmpty == true
            ? card['home_fault'].toString()
            : card['away_fault']?.toString() ?? '',
      ));
    }

    // Parse substitutions
    final substitutions = json['substitutes'] as List<dynamic>? ?? [];
    for (final sub in substitutions) {
      final homeSubOut = sub['home_scorer']?['out']?.toString();
      final awaySubOut = sub['away_scorer']?['out']?.toString();

      if (homeSubOut != null && homeSubOut.isNotEmpty) {
        events.add(MatchEvent(
          id: 'sub_${eventId++}',
          minute: _parseMinute(sub['time']?.toString() ?? ''),
          type: EventType.substitution,
          team: TeamSide.home,
          player: homeSubOut,
          detail: 'In: ${sub['home_scorer']?['in'] ?? ''}',
        ));
      }
      if (awaySubOut != null && awaySubOut.isNotEmpty) {
        events.add(MatchEvent(
          id: 'sub_${eventId++}',
          minute: _parseMinute(sub['time']?.toString() ?? ''),
          type: EventType.substitution,
          team: TeamSide.away,
          player: awaySubOut,
          detail: 'In: ${sub['away_scorer']?['in'] ?? ''}',
        ));
      }
    }

    // Sort by minute
    events.sort((a, b) => a.minute.compareTo(b.minute));

    return events;
  }

  int _parseMinute(String timeStr) {
    if (timeStr.isEmpty) return 0;

    if (timeStr.contains('+')) {
      final parts = timeStr.split('+');
      final base = int.tryParse(parts[0].trim()) ?? 0;
      final added = int.tryParse(parts[1].trim()) ?? 0;
      return base + added;
    }

    return int.tryParse(timeStr.replaceAll("'", '').trim()) ?? 0;
  }

  Lineups _parseLineups(Map<String, dynamic> json) {
    final homeFormation = json['event_home_formation']?.toString() ?? '';
    final awayFormation = json['event_away_formation']?.toString() ?? '';

    final List<PlayerPosition> homePlayers = [];
    final List<PlayerPosition> awayPlayers = [];

    // Parse home lineup
    final homeLineup = json['lineup']?['home']?['starting_lineups'] as List<dynamic>? ?? [];
    for (int i = 0; i < homeLineup.length; i++) {
      final player = homeLineup[i];
      homePlayers.add(PlayerPosition(
        playerId: player['player_key']?.toString() ?? '',
        playerName: player['player'] ?? '',
        playerNumber: int.tryParse(player['player_number']?.toString() ?? '') ?? 0,
        position: player['player_position'] ?? '',
        row: i ~/ 4,
        col: i % 4,
      ));
    }

    // Parse away lineup
    final awayLineup = json['lineup']?['away']?['starting_lineups'] as List<dynamic>? ?? [];
    for (int i = 0; i < awayLineup.length; i++) {
      final player = awayLineup[i];
      awayPlayers.add(PlayerPosition(
        playerId: player['player_key']?.toString() ?? '',
        playerName: player['player'] ?? '',
        playerNumber: int.tryParse(player['player_number']?.toString() ?? '') ?? 0,
        position: player['player_position'] ?? '',
        row: i ~/ 4,
        col: i % 4,
      ));
    }

    return Lineups(
      homeFormation: homeFormation,
      awayFormation: awayFormation,
      homePlayers: homePlayers,
      awayPlayers: awayPlayers,
    );
  }

  TeamStats _parseStats(Map<String, dynamic> json) {
    final stats = json['statistics'] as List<dynamic>? ?? [];
    final List<StatItem> statItems = [];

    for (final stat in stats) {
      final type = stat['type']?.toString() ?? '';
      final home = stat['home']?.toString() ?? '0';
      final away = stat['away']?.toString() ?? '0';

      statItems.add(StatItem(
        label: type,
        homeValue: int.tryParse(home.replaceAll('%', '')) ?? 0,
        awayValue: int.tryParse(away.replaceAll('%', '')) ?? 0,
        isPercentage: home.contains('%'),
      ));
    }

    return TeamStats(stats: statItems);
  }

  HeadToHead _parseH2H(dynamic result, String? homeTeamLogo, String? awayTeamLogo) {
    final List<PastMatch> pastMatches = [];
    final List<FormResult> recentForm = [];

    // Parse H2H matches
    final h2hMatches = result['H2H'] as List<dynamic>? ?? [];

    for (final match in h2hMatches.take(10)) {
      final homeScore = int.tryParse(match['event_final_result']?.toString().split('-').first.trim() ?? '0') ?? 0;
      final awayScore = int.tryParse(match['event_final_result']?.toString().split('-').last.trim() ?? '0') ?? 0;

      pastMatches.add(PastMatch(
        id: match['event_key']?.toString() ?? '',
        date: DateTime.tryParse(match['event_date'] ?? '') ?? DateTime.now(),
        homeScore: homeScore,
        awayScore: awayScore,
        competition: match['league_name'] ?? '',
        homeTeam: match['event_home_team'],
        awayTeam: match['event_away_team'],
      ));

      // Calculate form from perspective of first team
      if (homeScore > awayScore) {
        recentForm.add(FormResult.win);
      } else if (homeScore < awayScore) {
        recentForm.add(FormResult.loss);
      } else {
        recentForm.add(FormResult.draw);
      }
    }

    return HeadToHead(
      homeTeamLogo: homeTeamLogo,
      awayTeamLogo: awayTeamLogo,
      recentForm: recentForm.take(5).toList(),
      totalMatches: pastMatches.length,
      homeWins: recentForm.where((r) => r == FormResult.win).length,
      awayWins: recentForm.where((r) => r == FormResult.loss).length,
      draws: recentForm.where((r) => r == FormResult.draw).length,
      pastMatches: pastMatches,
    );
  }
}

/// Provider for the football API service
final footballApiServiceProvider = Provider<FootballApiService>((ref) {
  final dio = Dio();
  return FootballApiService(dio);
});

