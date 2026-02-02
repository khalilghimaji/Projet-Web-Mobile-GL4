import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/fixture_models.dart';
/// Card displaying a single fixture
class FixtureCard extends StatelessWidget {
  final Fixture fixture;
  final VoidCallback? onTap;

  const FixtureCard({
    super.key,
    required this.fixture,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade900,
              Colors.grey.shade800.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: fixture.parsedStatus == FixtureStatus.live
                ? Colors.green.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
            width: fixture.parsedStatus == FixtureStatus.live ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Status badge
              _buildStatusBadge(),
              const SizedBox(height: 12),
              // Teams and score
              Row(
                children: [
                  // Home team
                  Expanded(child: _buildTeam(fixture.homeTeam, fixture.homeTeamLogo, true)),
                  // Score
                  _buildScore(),
                  // Away team
                  Expanded(child: _buildTeam(fixture.awayTeam, fixture.awayTeamLogo, false)),
                ],
              ),
              const SizedBox(height: 8),
              // Time
              if (fixture.parsedStatus == FixtureStatus.scheduled)
                Text(
                  fixture.eventTime,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String text;
    bool showPulse = false;

    switch (fixture.parsedStatus) {
      case FixtureStatus.live:
        badgeColor = Colors.green;
        text = fixture.minute != null ? "${fixture.minute}'" : 'LIVE';
        showPulse = true;
        break;
      case FixtureStatus.halftime:
        badgeColor = Colors.orange;
        text = 'HT';
        break;
      case FixtureStatus.finished:
        badgeColor = Colors.grey;
        text = 'FT';
        break;
      case FixtureStatus.scheduled:
      default:
        badgeColor = Colors.blue;
        text = 'Scheduled';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showPulse) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              color: badgeColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeam(String name, String? logo, bool isHome) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: logo != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: logo,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Icon(Icons.sports_soccer, color: Colors.grey),
                    errorWidget: (_, __, ___) => const Icon(Icons.sports_soccer, color: Colors.grey),
                  ),
                )
              : const Icon(Icons.sports_soccer, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildScore() {
    if (fixture.parsedStatus == FixtureStatus.scheduled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const Text(
          'vs',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${fixture.homeScore ?? 0} - ${fixture.awayScore ?? 0}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

