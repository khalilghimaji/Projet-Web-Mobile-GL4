// Models for Fixtures and Matches

/// Status of a fixture
enum FixtureStatus {
  live,
  scheduled,
  finished,
  halftime,
}

/// League model
class League {
  final String leagueKey;
  final String leagueName;
  final String? leagueLogo;
  final String? countryName;

  const League({
    required this.leagueKey,
    required this.leagueName,
    this.leagueLogo,
    this.countryName,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      leagueKey: json['league_key']?.toString() ?? '',
      leagueName: json['league_name'] ?? '',
      leagueLogo: json['league_logo'],
      countryName: json['country_name'],
    );
  }
}

/// Fixture model
class Fixture {
  final String eventKey;
  final String eventDate;
  final String eventTime;
  final String homeTeam;
  final String homeTeamKey;
  final String? homeTeamLogo;
  final String awayTeam;
  final String awayTeamKey;
  final String? awayTeamLogo;
  final String? eventFinalResult;
  final String? eventHalftimeResult;
  final String eventStatus;
  final String eventLive;
  final String leagueName;
  final String leagueKey;
  final String? leagueLogo;
  final String? countryName;
  final String? eventStadium;

  // Parsed fields
  final FixtureStatus parsedStatus;
  final int? minute;
  final int? homeScore;
  final int? awayScore;

  const Fixture({
    required this.eventKey,
    required this.eventDate,
    required this.eventTime,
    required this.homeTeam,
    required this.homeTeamKey,
    this.homeTeamLogo,
    required this.awayTeam,
    required this.awayTeamKey,
    this.awayTeamLogo,
    this.eventFinalResult,
    this.eventHalftimeResult,
    required this.eventStatus,
    required this.eventLive,
    required this.leagueName,
    required this.leagueKey,
    this.leagueLogo,
    this.countryName,
    this.eventStadium,
    required this.parsedStatus,
    this.minute,
    this.homeScore,
    this.awayScore,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    // Parse status
    FixtureStatus parsedStatus = FixtureStatus.scheduled;
    int? minute;
    int? homeScore;
    int? awayScore;

    final eventLive = json['event_live']?.toString() ?? '0';
    final eventStatus = json['event_status']?.toString() ?? '';

    if (eventLive == '1') {
      if (eventStatus == 'Half Time') {
        parsedStatus = FixtureStatus.halftime;
      } else {
        parsedStatus = FixtureStatus.live;
        minute = _parseMinuteString(eventStatus);
      }
    } else if (eventStatus == 'Finished') {
      parsedStatus = FixtureStatus.finished;
    }

    // Parse score
    final finalResult = json['event_final_result']?.toString() ?? '';
    if (finalResult.isNotEmpty && finalResult != '-') {
      final parts = finalResult.split('-');
      if (parts.length == 2) {
        homeScore = int.tryParse(parts[0].trim());
        awayScore = int.tryParse(parts[1].trim());
      }
    }

    return Fixture(
      eventKey: json['event_key']?.toString() ?? '',
      eventDate: json['event_date'] ?? '',
      eventTime: json['event_time'] ?? '',
      homeTeam: json['event_home_team'] ?? '',
      homeTeamKey: json['home_team_key']?.toString() ?? '',
      homeTeamLogo: json['home_team_logo'],
      awayTeam: json['event_away_team'] ?? '',
      awayTeamKey: json['away_team_key']?.toString() ?? '',
      awayTeamLogo: json['away_team_logo'],
      eventFinalResult: json['event_final_result'],
      eventHalftimeResult: json['event_halftime_result'],
      eventStatus: eventStatus,
      eventLive: eventLive,
      leagueName: json['league_name'] ?? '',
      leagueKey: json['league_key']?.toString() ?? '',
      leagueLogo: json['league_logo'],
      countryName: json['country_name'],
      eventStadium: json['event_stadium'],
      parsedStatus: parsedStatus,
      minute: minute,
      homeScore: homeScore,
      awayScore: awayScore,
    );
  }

  static int? _parseMinuteString(String timeStr) {
    if (timeStr.isEmpty) return null;

    if (timeStr.contains('+')) {
      final parts = timeStr.split('+');
      final base = int.tryParse(parts[0].trim()) ?? 0;
      final added = int.tryParse(parts[1].trim()) ?? 0;
      return base + added;
    }

    return int.tryParse(timeStr.replaceAll("'", '').trim());
  }
}

/// Fixtures grouped by league
class FixturesByLeague {
  final League league;
  final List<Fixture> fixtures;

  const FixturesByLeague({
    required this.league,
    required this.fixtures,
  });
}

/// Date tab for date selector
class DateTab {
  final DateTime date;
  final String dayName;
  final int dayNumber;
  final bool isToday;

  const DateTab({
    required this.date,
    required this.dayName,
    required this.dayNumber,
    required this.isToday,
  });
}

