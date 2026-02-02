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
      print('[MATCH_DETAILS] Fetching match details for ID: $matchId');

      // Fetch general info
      final generalInfoUrl = '${AllSportsApiConfig.baseUrl}?met=Fixtures&APIkey=${AllSportsApiConfig.apiKey}&matchId=$matchId';
      final generalInfoResponse = await _dio.get(generalInfoUrl);

      print('[MATCH_DETAILS] Response success: ${generalInfoResponse.data['success']}');

      Map<String, dynamic>? matchJson;
      if (generalInfoResponse.data['success'] == 1 && generalInfoResponse.data['result'] != null) {
        final results = generalInfoResponse.data['result'];
        if (results is List && results.isNotEmpty) {
          matchJson = results[0];
          print('[MATCH_DETAILS] Match data found. Status: ${matchJson?['event_status']}, Live: ${matchJson?['event_live']}');
        } else {
          print('[MATCH_DETAILS] ERROR: Result is not a list or is empty');
        }
      } else {
        print('[MATCH_DETAILS] ERROR: API returned success != 1 or result is null');
      }

      if (matchJson == null) {
        print('[MATCH_DETAILS] ERROR: matchJson is null, returning empty data');
        return MatchData.empty();
      }

      print('[MATCH_DETAILS] Parsing match header...');
      final header = _parseMatchHeader(matchJson);
      print('[MATCH_DETAILS] Header parsed: ${header.status.status}, Score: ${header.score.home}-${header.score.away}');

      // Fetch videos
      List<VideoHighlight> highlights = [];
      try {
        print('[MATCH_DETAILS] Fetching videos...');
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
          print('[MATCH_DETAILS] Found ${highlights.length} video highlights');
        } else {
          print('[MATCH_DETAILS] No videos available');
        }
      } catch (e) {
        print('[MATCH_DETAILS] Error fetching videos: $e');
      }

      // Fetch H2H
      HeadToHead h2h = HeadToHead.empty();
      try {
        print('[MATCH_DETAILS] Fetching H2H data...');
        final homeTeamKey = matchJson?['home_team_key']?.toString();
        final awayTeamKey = matchJson?['away_team_key']?.toString();

        if (homeTeamKey != null && awayTeamKey != null) {
          final h2hUrl = '${AllSportsApiConfig.baseUrl}?met=H2H&APIkey=${AllSportsApiConfig.apiKey}&firstTeamId=$homeTeamKey&secondTeamId=$awayTeamKey';
          final h2hResponse = await _dio.get(h2hUrl);

          if (h2hResponse.data['success'] == 1 && h2hResponse.data['result'] != null) {
            h2h = _parseH2H(h2hResponse.data['result'], matchJson?['home_team_logo'], matchJson?['away_team_logo']);
            print('[MATCH_DETAILS] H2H parsed successfully');
          }
        } else {
          print('[MATCH_DETAILS] Missing team keys for H2H');
        }
      } catch (e) {
        print('[MATCH_DETAILS] Error fetching H2H: $e');
      }

      print('[MATCH_DETAILS] Parsing timeline...');
      final timeline = _parseTimeline(matchJson);
      print('[MATCH_DETAILS] Timeline parsed: ${timeline.length} events');

      print('[MATCH_DETAILS] Parsing lineups...');
      final lineups = _parseLineups(matchJson);
      print('[MATCH_DETAILS] Lineups parsed: Home=${lineups.homePlayers.length}, Away=${lineups.awayPlayers.length}');

      print('[MATCH_DETAILS] Parsing stats...');
      final stats = _parseStats(matchJson);
      print('[MATCH_DETAILS] Stats parsed: ${stats.stats.length} items');

      return MatchData(
        header: header,
        timeline: timeline,
        lineups: lineups,
        stats: stats,
        h2h: h2h,
        highlights: highlights,
      );
    } catch (e, stackTrace) {
      print('[MATCH_DETAILS] CRITICAL ERROR fetching match details: $e');
      print('[MATCH_DETAILS] Stack trace: $stackTrace');
      return MatchData.empty();
    }
  }

  MatchHeader _parseMatchHeader(Map<String, dynamic> json) {
    final eventLive = json['event_live']?.toString() ?? '0';
    final eventStatus = json['event_status']?.toString() ?? '';

    // Suivre exactement la logique du front: getEventStatus()
    String status;
    if (eventLive == '1') {
      if (eventStatus == 'Half Time') {
        status = 'HT';
      } else {
        status = 'LIVE';
      }
    } else if (eventStatus == 'Finished') {
      status = 'FT';
    } else if (eventLive == '0' && eventStatus.isNotEmpty && eventStatus != 'null') {
      status = 'FT';
    } else {
      status = 'SCHEDULED';
    }

    final isLive = eventLive == '1';
    final minute = _parseStatusMinute(eventStatus);

    // Parse score - suivre la logique du front
    int homeScore = 0;
    int awayScore = 0;

    final finalResult = json['event_final_result']?.toString() ?? '';
    if (finalResult.isNotEmpty && finalResult != '-' && finalResult != 'null') {
      final parts = finalResult.split('-');
      if (parts.length >= 2) {
        homeScore = int.tryParse(parts[0].trim()) ?? 0;
        awayScore = int.tryParse(parts[1].trim()) ?? 0;
      }
    }

    return MatchHeader(
      status: MatchStatus(
        isLive: isLive,
        minute: minute,
        status: status,
        competition: json['league_name']?.toString() ?? '',
      ),
      homeTeam: TeamInfo(
        id: json['home_team_key']?.toString() ?? '',
        name: json['event_home_team']?.toString() ?? '',
        shortName: json['event_home_team']?.toString() ?? '',
        logo: json['home_team_logo']?.toString(),
      ),
      awayTeam: TeamInfo(
        id: json['away_team_key']?.toString() ?? '',
        name: json['event_away_team']?.toString() ?? '',
        shortName: json['event_away_team']?.toString() ?? '',
        logo: json['away_team_logo']?.toString(),
      ),
      score: MatchScore(
        home: homeScore,
        away: awayScore,
        venue: json['event_stadium']?.toString(),
      ),
    );
  }

  // Méthode pour parser la minute du statut (comme parseStatusMinute dans le front)
  int _parseStatusMinute(String status) {
    if (status.isEmpty) return 0;

    // Extraire le nombre de minutes du statut
    final match = RegExp(r'(\d+)').firstMatch(status);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '0') ?? 0;
    }

    return 0;
  }

  String _getShortName(String fullName) {
    if (fullName.length <= 3) return fullName.toUpperCase();
    return fullName.substring(0, 3).toUpperCase();
  }

  List<MatchEvent> _parseTimeline(Map<String, dynamic> json) {
    final List<MatchEvent> events = [];
    int eventId = 0;

    try {
      // Parse goalscorers
      final goalscorers = json['goalscorers'] as List<dynamic>? ?? [];
      for (final goal in goalscorers) {
        try {
          final homeScorer = goal['home_scorer']?.toString() ?? '';
          final awayScorer = goal['away_scorer']?.toString() ?? '';

          if (homeScorer.isNotEmpty || awayScorer.isNotEmpty) {
            events.add(MatchEvent(
              id: 'goal_${eventId++}',
              minute: _parseMinute(goal['time']?.toString() ?? ''),
              type: EventType.goal,
              team: homeScorer.isNotEmpty ? TeamSide.home : TeamSide.away,
              player: homeScorer.isNotEmpty ? homeScorer : awayScorer,
              detail: goal['home_assist']?.toString().isNotEmpty == true
                  ? 'Assist: ${goal['home_assist']}'
                  : goal['away_assist']?.toString().isNotEmpty == true
                      ? 'Assist: ${goal['away_assist']}'
                      : null,
            ));
          }
        } catch (e) {
          print('[TIMELINE] Error parsing goalscorer: $e');
        }
      }
    } catch (e) {
      print('[TIMELINE] Error parsing goalscorers list: $e');
    }

    try {
      // Parse cards
      final cards = json['cards'] as List<dynamic>? ?? [];
      for (final card in cards) {
        try {
          final homeFault = card['home_fault']?.toString() ?? '';
          final awayFault = card['away_fault']?.toString() ?? '';

          if (homeFault.isNotEmpty || awayFault.isNotEmpty) {
            final isYellow = card['card']?.toString().toLowerCase().contains('yellow') ?? false;
            events.add(MatchEvent(
              id: 'card_${eventId++}',
              minute: _parseMinute(card['time']?.toString() ?? ''),
              type: isYellow ? EventType.yellowCard : EventType.redCard,
              team: homeFault.isNotEmpty ? TeamSide.home : TeamSide.away,
              player: homeFault.isNotEmpty ? homeFault : awayFault,
            ));
          }
        } catch (e) {
          print('[TIMELINE] Error parsing card: $e');
        }
      }
    } catch (e) {
      print('[TIMELINE] Error parsing cards list: $e');
    }

    // Parse substitutions - handle both String and Object formats
    final substitutions = json['substitutes'] as List<dynamic>? ?? [];
    for (final sub in substitutions) {
      try {
        // Check if home_scorer exists and is not empty string
        final homeScorer = sub['home_scorer'];
        if (homeScorer != null && homeScorer != '') {
          String? playerOut;
          String? playerIn;

          // Handle both String and Object formats
          if (homeScorer is Map) {
            playerOut = homeScorer['out']?.toString();
            playerIn = homeScorer['in']?.toString();
          } else if (homeScorer is String && homeScorer.isNotEmpty) {
            // If it's a string, use it as the player out
            playerOut = homeScorer;
          }

          if (playerOut != null && playerOut.isNotEmpty) {
            events.add(MatchEvent(
              id: 'sub_${eventId++}',
              minute: _parseMinute(sub['time']?.toString() ?? ''),
              type: EventType.substitution,
              team: TeamSide.home,
              player: playerOut,
              detail: playerIn != null && playerIn.isNotEmpty ? 'In: $playerIn' : null,
            ));
          }
        }

        // Check if away_scorer exists and is not empty string
        final awayScorer = sub['away_scorer'];
        if (awayScorer != null && awayScorer != '') {
          String? playerOut;
          String? playerIn;

          // Handle both String and Object formats
          if (awayScorer is Map) {
            playerOut = awayScorer['out']?.toString();
            playerIn = awayScorer['in']?.toString();
          } else if (awayScorer is String && awayScorer.isNotEmpty) {
            // If it's a string, use it as the player out
            playerOut = awayScorer;
          }

          if (playerOut != null && playerOut.isNotEmpty) {
            events.add(MatchEvent(
              id: 'sub_${eventId++}',
              minute: _parseMinute(sub['time']?.toString() ?? ''),
              type: EventType.substitution,
              team: TeamSide.away,
              player: playerOut,
              detail: playerIn != null && playerIn.isNotEmpty ? 'In: $playerIn' : null,
            ));
          }
        }
      } catch (e) {
        print('[TIMELINE] Error parsing substitution: $e');
        // Continue with next substitution
      }
    } catch (e) {
      print('[TIMELINE] Error parsing substitutes list: $e');
    }

    // Sort by minute with error handling
    try {
      events.sort((a, b) => a.minute.compareTo(b.minute));
    } catch (e) {
      print('[TIMELINE] Error sorting events: $e');
    }

    print('[TIMELINE] Successfully parsed ${events.length} events');
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
    final homeFormation = json['event_home_formation']?.toString() ?? '4-3-3';
    final awayFormation = json['event_away_formation']?.toString() ?? '4-3-3';

    final List<PlayerPosition> homePlayers = [];
    final List<PlayerPosition> awayPlayers = [];

    // Suivre exactement la logique du front: dto.lineups?.home_team
    try {
      final lineupData = json['lineups'];

      if (lineupData != null && lineupData['home_team'] != null && lineupData['away_team'] != null) {
        // Parse home lineup - suivre la logique du front mapLineupPlayers()
        final homeLineup = lineupData['home_team']['starting_lineups'] as List<dynamic>? ?? [];
        homePlayers.addAll(_mapLineupPlayers(homeLineup, homeFormation, true));

        // Parse away lineup
        final awayLineup = lineupData['away_team']['starting_lineups'] as List<dynamic>? ?? [];
        awayPlayers.addAll(_mapLineupPlayers(awayLineup, awayFormation, false));

        print('[LINEUPS] Parsed using lineups.home_team structure');
      } else {
        print('[LINEUPS] No lineups.home_team found, lineups will be empty');
      }
    } catch (e) {
      print('[LINEUPS] Error parsing lineups: $e');
    }

    return Lineups(
      homeFormation: homeFormation,
      awayFormation: awayFormation,
      homePlayers: homePlayers,
      awayPlayers: awayPlayers,
    );
  }

  // Méthode helper pour mapper les joueurs (comme mapLineupPlayers dans le front)
  List<PlayerPosition> _mapLineupPlayers(List<dynamic> apiPlayers, String formation, bool isHome) {
    if (apiPlayers.isEmpty) return [];

    final List<PlayerPosition> players = [];

    // Séparer gardien et joueurs de champ (comme dans le front)
    final goalkeeper = apiPlayers.firstWhere(
      (p) => p['player_position']?.toString() == '1',
      orElse: () => null,
    );

    final outfieldPlayers = apiPlayers.where(
      (p) => p['player_position']?.toString() != '1',
    ).toList();

    // Trier par numéro de maillot (comme dans le front)
    outfieldPlayers.sort((a, b) {
      final numA = int.tryParse(a['player_number']?.toString() ?? '99') ?? 99;
      final numB = int.tryParse(b['player_number']?.toString() ?? '99') ?? 99;
      return numA.compareTo(numB);
    });

    // Ajouter le gardien en premier
    if (goalkeeper != null) {
      players.add(PlayerPosition(
        playerId: goalkeeper['player_key']?.toString() ?? '',
        playerName: _extractShortName(goalkeeper['player']?.toString() ?? ''),
        playerNumber: int.tryParse(goalkeeper['player_number']?.toString() ?? '1') ?? 1,
        position: 'GK',
        row: 0,
        col: 0,
      ));
    }

    // Ajouter EXACTEMENT 10 joueurs de champ maximum (comme dans le front)
    final maxOutfield = 10;
    for (int i = 0; i < outfieldPlayers.length && i < maxOutfield; i++) {
      final player = outfieldPlayers[i];
      players.add(PlayerPosition(
        playerId: player['player_key']?.toString() ?? '',
        playerName: _extractShortName(player['player']?.toString() ?? ''),
        playerNumber: int.tryParse(player['player_number']?.toString() ?? '0') ?? 0,
        position: player['player_position']?.toString() ?? '',
        row: i,
        col: i,
      ));
    }

    return players;
  }

  // Extraire le nom court (comme extractShortName dans le front)
  String _extractShortName(String fullName) {
    if (fullName.isEmpty) return '';
    final parts = fullName.trim().split(' ');
    if (parts.length == 1) return parts[0];
    return parts.last; // Retourner le nom de famille
  }

  TeamStats _parseStats(Map<String, dynamic> json) {
    final stats = json['statistics'] as List<dynamic>? ?? [];
    final List<StatItem> statItems = [];

    // Suivre exactement la logique du front
    for (final stat in stats) {
      final type = stat['type']?.toString() ?? '';
      final home = stat['home']?.toString() ?? '0';
      final away = stat['away']?.toString() ?? '0';

      // Utiliser parseFloat comme dans le front
      final homeValue = double.tryParse(home) ?? 0.0;
      final awayValue = double.tryParse(away) ?? 0.0;

      statItems.add(StatItem(
        label: type,
        homeValue: homeValue.toInt(),
        awayValue: awayValue.toInt(),
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

