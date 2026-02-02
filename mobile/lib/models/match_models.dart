// Match detail models

/// Event types for match timeline
enum EventType {
  goal,
  yellowCard,
  redCard,
  substitution,
}

/// Team side
enum TeamSide {
  home,
  away,
}

/// Match event for timeline
class MatchEvent {
  final String id;
  final int minute;
  final EventType type;
  final TeamSide team;
  final String player;
  final String? detail;

  const MatchEvent({
    required this.id,
    required this.minute,
    required this.type,
    required this.team,
    required this.player,
    this.detail,
  });
}

/// Team info for match header
class TeamInfo {
  final String id;
  final String name;
  final String shortName;
  final String? logo;

  const TeamInfo({
    required this.id,
    required this.name,
    required this.shortName,
    this.logo,
  });
}

/// Match status
class MatchStatus {
  final bool isLive;
  final int minute;
  final String status; // LIVE, FT, HT, SCHEDULED
  final String competition;

  const MatchStatus({
    required this.isLive,
    required this.minute,
    required this.status,
    required this.competition,
  });
}

/// Match score
class MatchScore {
  final int home;
  final int away;
  final String? venue;

  const MatchScore({
    required this.home,
    required this.away,
    this.venue,
  });
}

/// Match header data
class MatchHeader {
  final MatchStatus status;
  final TeamInfo homeTeam;
  final TeamInfo awayTeam;
  final MatchScore score;

  const MatchHeader({
    required this.status,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
  });

  factory MatchHeader.empty() {
    return const MatchHeader(
      status: MatchStatus(
        isLive: false,
        minute: 0,
        status: 'SCHEDULED',
        competition: '',
      ),
      homeTeam: TeamInfo(id: '', name: '', shortName: ''),
      awayTeam: TeamInfo(id: '', name: '', shortName: ''),
      score: MatchScore(home: 0, away: 0),
    );
  }
}

/// Player position for lineups
class PlayerPosition {
  final String playerId;
  final String playerName;
  final int playerNumber;
  final String position; // GK, DF, MF, FW
  final int row;
  final int col;

  const PlayerPosition({
    required this.playerId,
    required this.playerName,
    required this.playerNumber,
    required this.position,
    required this.row,
    required this.col,
  });
}

/// Lineups data
class Lineups {
  final String homeFormation;
  final String awayFormation;
  final List<PlayerPosition> homePlayers;
  final List<PlayerPosition> awayPlayers;

  const Lineups({
    required this.homeFormation,
    required this.awayFormation,
    required this.homePlayers,
    required this.awayPlayers,
  });

  factory Lineups.empty() {
    return const Lineups(
      homeFormation: '',
      awayFormation: '',
      homePlayers: [],
      awayPlayers: [],
    );
  }
}

/// Stat item for team comparison
class StatItem {
  final String label;
  final int homeValue;
  final int awayValue;
  final bool isPercentage;

  const StatItem({
    required this.label,
    required this.homeValue,
    required this.awayValue,
    this.isPercentage = false,
  });
}

/// Team stats
class TeamStats {
  final List<StatItem> stats;

  const TeamStats({required this.stats});

  factory TeamStats.empty() {
    return const TeamStats(stats: []);
  }
}

/// Form result for H2H
enum FormResult { win, draw, loss }

/// Head to head data
class HeadToHead {
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final List<FormResult> recentForm;
  final int? totalMatches;
  final int? homeWins;
  final int? awayWins;
  final int? draws;
  final List<PastMatch> pastMatches;

  const HeadToHead({
    this.homeTeamLogo,
    this.awayTeamLogo,
    required this.recentForm,
    this.totalMatches,
    this.homeWins,
    this.awayWins,
    this.draws,
    this.pastMatches = const [],
  });

  factory HeadToHead.empty() {
    return const HeadToHead(recentForm: [], pastMatches: []);
  }
}

/// Past match for H2H
class PastMatch {
  final String id;
  final DateTime date;
  final int homeScore;
  final int awayScore;
  final String competition;
  final String? homeTeam;
  final String? awayTeam;

  const PastMatch({
    required this.id,
    required this.date,
    required this.homeScore,
    required this.awayScore,
    required this.competition,
    this.homeTeam,
    this.awayTeam,
  });
}

/// Video highlight
class VideoHighlight {
  final String id;
  final String title;
  final String? thumbnail;
  final String? duration;
  final String url;

  const VideoHighlight({
    required this.id,
    required this.title,
    this.thumbnail,
    this.duration,
    required this.url,
  });
}

/// Vote option for predictions
enum VoteOption { home, draw, away }

/// User vote
class UserVote {
  final VoteOption option;
  final int homeScore;
  final int awayScore;
  final int diamonds;

  const UserVote({
    required this.option,
    required this.homeScore,
    required this.awayScore,
    required this.diamonds,
  });
}

/// Prediction data
class PredictionData {
  final int totalVotes;
  final double homePercentage;
  final double drawPercentage;
  final double awayPercentage;
  final UserVote? userVote;
  final bool voteEnabled;

  const PredictionData({
    required this.totalVotes,
    required this.homePercentage,
    required this.drawPercentage,
    required this.awayPercentage,
    this.userVote,
    this.voteEnabled = true,
  });

  factory PredictionData.empty() {
    return const PredictionData(
      totalVotes: 0,
      homePercentage: 0,
      drawPercentage: 0,
      awayPercentage: 0,
    );
  }
}

/// Complete match data
class MatchData {
  final MatchHeader header;
  final List<MatchEvent> timeline;
  final Lineups lineups;
  final TeamStats stats;
  final HeadToHead h2h;
  final List<VideoHighlight> highlights;

  const MatchData({
    required this.header,
    required this.timeline,
    required this.lineups,
    required this.stats,
    required this.h2h,
    required this.highlights,
  });

  factory MatchData.empty() {
    return MatchData(
      header: MatchHeader.empty(),
      timeline: const [],
      lineups: Lineups.empty(),
      stats: TeamStats.empty(),
      h2h: HeadToHead.empty(),
      highlights: const [],
    );
  }
}

