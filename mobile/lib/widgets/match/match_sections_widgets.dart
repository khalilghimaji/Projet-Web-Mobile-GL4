import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/match_models.dart';
import '../../utils/formation_util.dart';

/// Timeline section showing match events
class MatchTimelineWidget extends StatelessWidget {
  final List<MatchEvent> events;

  const MatchTimelineWidget({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Match Events',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...events.map((event) => _buildEventItem(event)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.sports_soccer, size: 48, color: Colors.grey.shade600),
            const SizedBox(height: 12),
            Text(
              'No events yet',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem(MatchEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Minute
          SizedBox(
            width: 50,
            child: Text(
              "${event.minute}'",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _getEventColor(event.type).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getEventIcon(event.type),
              color: _getEventColor(event.type),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: event.team == TeamSide.home
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.team == TeamSide.home ? 'HOME' : 'AWAY',
                        style: TextStyle(
                          color: event.team == TeamSide.home ? Colors.blue : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.player,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (event.detail != null && event.detail!.isNotEmpty)
                  Text(
                    event.detail!,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(EventType type) {
    switch (type) {
      case EventType.goal:
        return Icons.sports_soccer;
      case EventType.yellowCard:
        return Icons.square_rounded;
      case EventType.redCard:
        return Icons.square_rounded;
      case EventType.substitution:
        return Icons.swap_horiz;
    }
  }

  Color _getEventColor(EventType type) {
    switch (type) {
      case EventType.goal:
        return Colors.green;
      case EventType.yellowCard:
        return Colors.yellow;
      case EventType.redCard:
        return Colors.red;
      case EventType.substitution:
        return Colors.blue;
    }
  }
}

/// Team statistics comparison widget
class TeamStatsWidget extends StatelessWidget {
  final TeamStats stats;

  const TeamStatsWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.stats.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...stats.stats.map((stat) => _buildStatBar(stat)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.bar_chart, size: 48, color: Colors.grey.shade600),
            const SizedBox(height: 12),
            Text(
              'Statistics not available',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(StatItem stat) {
    final total = stat.homeValue + stat.awayValue;
    final homePercent = total > 0 ? stat.homeValue / total : 0.5;
    final awayPercent = total > 0 ? stat.awayValue / total : 0.5;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stat.isPercentage ? '${stat.homeValue}%' : '${stat.homeValue}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                stat.label,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
              ),
              Text(
                stat.isPercentage ? '${stat.awayValue}%' : '${stat.awayValue}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: (homePercent * 100).toInt().clamp(1, 99),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(3),
                      bottomLeft: Radius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                flex: (awayPercent * 100).toInt().clamp(1, 99),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(3),
                      bottomRight: Radius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Lineups pitch widget
class LineupsPitchWidget extends StatelessWidget {
  final Lineups lineups;

  const LineupsPitchWidget({super.key, required this.lineups});

  @override
  Widget build(BuildContext context) {
    if (lineups.homePlayers.isEmpty && lineups.awayPlayers.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Formations (following front-end layout)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LINEUPS',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Row(
                children: [
                  _buildFormationBadge(lineups.homeFormation),
                  const SizedBox(width: 8),
                  _buildFormationBadge(lineups.awayFormation),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Pitch
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 500),
              decoration: BoxDecoration(
                color: const Color(0xFF2a4e3a), // Match front-end color
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // Pitch lines
                      _buildPitchLines(),
                      // Home players (top half)
                      ..._buildPlayerPositions(lineups.homePlayers, true, constraints.maxWidth, constraints.maxHeight),
                      // Away players (bottom half)
                      ..._buildPlayerPositions(lineups.awayPlayers, false, constraints.maxWidth, constraints.maxHeight),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.people, size: 48, color: Colors.grey.shade600),
            const SizedBox(height: 12),
            Text(
              'Lineups not available',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormationBadge(String formation) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        formation.isEmpty ? '-' : formation,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPitchLines() {
    return Positioned.fill(
      child: CustomPaint(
        painter: PitchLinesPainter(),
      ),
    );
  }

  List<Widget> _buildPlayerPositions(List<PlayerPosition> players, bool isHome, double containerWidth, double containerHeight) {
    if (players.isEmpty) return [];

    // Use formation utility to get properly positioned players
    final formation = isHome ? lineups.homeFormation : lineups.awayFormation;
    final positionedPlayers = mapPlayersToFormation(players, formation, isHome);

    return positionedPlayers.map((player) {
      // Check if player is goalkeeper
      final isGoalkeeper = player.position.toLowerCase() == 'gk' || player.position.toLowerCase() == 'goalkeeper';

      // Use the row (y%) and col (x%) from the player position
      // Convert percentage to actual position
      final xPercent = player.col / 100.0;
      final yPercent = player.row / 100.0;

      return Positioned(
        left: xPercent * containerWidth,
        top: yPercent * containerHeight,
        child: Transform.translate(
          offset: const Offset(-18, -18), // Center the 36px circle
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isGoalkeeper
                      ? const Color(0xFFFACC15) // Yellow for goalkeepers
                      : isHome
                          ? const Color(0xFFBAE6FD) // Sky blue for home
                          : const Color(0xFFDC2626), // Red for away
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${player.playerNumber}',
                    style: TextStyle(
                      color: isGoalkeeper || isHome ? Colors.black : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                constraints: const BoxConstraints(maxWidth: 70),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  player.playerName.split(' ').last,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

/// Custom painter for pitch lines
class PitchLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const inset = 16.0; // Match front-end inset-4 (16px)

    // Outer boundary
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(inset, inset, size.width - inset, size.height - inset),
        const Radius.circular(4),
      ),
      paint,
    );

    // Center line
    canvas.drawLine(
      Offset(inset, size.height / 2),
      Offset(size.width - inset, size.height / 2),
      paint,
    );

    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      min(size.width, size.height) * 0.08, // 8% of smallest dimension
      paint,
    );

    // Goal areas
    final goalWidth = size.width * 0.3; // 30% of width
    final goalHeight = size.height * 0.06; // 6% of height

    // Top goal area
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          (size.width - goalWidth) / 2,
          inset,
          goalWidth,
          goalHeight,
        ),
        const Radius.circular(8),
      ),
      paint,
    );

    // Bottom goal area
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          (size.width - goalWidth) / 2,
          size.height - inset - goalHeight,
          goalWidth,
          goalHeight,
        ),
        const Radius.circular(8),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Head to head section
class HeadToHeadWidget extends StatelessWidget {
  final HeadToHead h2h;

  const HeadToHeadWidget({super.key, required this.h2h});

  @override
  Widget build(BuildContext context) {
    if (h2h.pastMatches.isEmpty && h2h.recentForm.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Head to Head',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Summary
          if (h2h.totalMatches != null)
            _buildSummary(),
          const SizedBox(height: 16),
          // Recent form
          if (h2h.recentForm.isNotEmpty) ...[
            Text(
              'Recent Form',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: h2h.recentForm.map((result) => _buildFormIndicator(result)).toList(),
            ),
          ],
          const SizedBox(height: 16),
          // Past matches
          if (h2h.pastMatches.isNotEmpty) ...[
            Text(
              'Recent Matches',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ...h2h.pastMatches.take(5).map((match) => _buildPastMatchItem(match)),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.history, size: 48, color: Colors.grey.shade600),
            const SizedBox(height: 12),
            Text(
              'No head-to-head data available',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('${h2h.homeWins ?? 0}', 'Wins', Colors.blue),
          _buildSummaryItem('${h2h.draws ?? 0}', 'Draws', Colors.grey),
          _buildSummaryItem('${h2h.awayWins ?? 0}', 'Wins', Colors.red),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFormIndicator(FormResult result) {
    Color color;
    String letter;

    switch (result) {
      case FormResult.win:
        color = Colors.green;
        letter = 'W';
        break;
      case FormResult.draw:
        color = Colors.grey;
        letter = 'D';
        break;
      case FormResult.loss:
        color = Colors.red;
        letter = 'L';
        break;
    }

    return Container(
      width: 28,
      height: 28,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPastMatchItem(PastMatch match) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              match.homeTeam ?? 'Home',
              style: const TextStyle(color: Colors.white, fontSize: 13),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${match.homeScore} - ${match.awayScore}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              match.awayTeam ?? 'Away',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Highlights section showing videos
class HighlightsWidget extends StatelessWidget {
  final List<VideoHighlight> highlights;

  const HighlightsWidget({super.key, required this.highlights});

  @override
  Widget build(BuildContext context) {
    if (highlights.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Highlights & Media',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...highlights.map((video) => _buildVideoCard(video)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.video_library, size: 48, color: Colors.grey.shade600),
            const SizedBox(height: 12),
            Text(
              'No highlights available',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(VideoHighlight video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 120,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (video.thumbnail != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Image.network(
                      video.thumbnail!,
                      fit: BoxFit.cover,
                      width: 120,
                      height: 70,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                  ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (video.duration != null)
                    Text(
                      video.duration!,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

