import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/match_models.dart';

/// Match header section showing teams, score, and status
class MatchHeaderWidget extends StatelessWidget {
  final MatchHeader header;

  const MatchHeaderWidget({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade900,
            Colors.grey.shade800,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Competition name
          Text(
            header.status.competition,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          // Teams and Score
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Home team
              Expanded(
                child: _buildTeam(header.homeTeam, true),
              ),
              // Score
              _buildScoreSection(),
              // Away team
              Expanded(
                child: _buildTeam(header.awayTeam, false),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Venue
          if (header.score.venue != null && header.score.venue!.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stadium, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Text(
                  header.score.venue!,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTeam(TeamInfo team, bool isHome) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: team.logo != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: team.logo!,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Icon(Icons.sports_soccer, color: Colors.grey, size: 40),
                    errorWidget: (_, __, ___) => const Icon(Icons.sports_soccer, color: Colors.grey, size: 40),
                  ),
                )
              : const Icon(Icons.sports_soccer, color: Colors.grey, size: 40),
        ),
        const SizedBox(height: 10),
        Text(
          team.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Status badge
          _buildStatusBadge(),
          const SizedBox(height: 10),
          // Score
          Text(
            '${header.score.home} - ${header.score.away}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String text;
    bool showPulse = false;

    switch (header.status.status) {
      case 'LIVE':
        badgeColor = Colors.green;
        text = header.status.minute > 0 ? "${header.status.minute}'" : 'LIVE';
        showPulse = true;
        break;
      case 'HT':
        badgeColor = Colors.orange;
        text = 'HT';
        break;
      case 'FT':
        badgeColor = Colors.grey;
        text = 'FT';
        break;
      default:
        badgeColor = Colors.blue;
        text = 'Scheduled';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tabs navigation for match detail sections
class MatchTabsNavigation extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChanged;
  final List<String> tabs;

  const MatchTabsNavigation({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
    this.tabs = const ['OVERVIEW', 'LINEUPS', 'STATS', 'H2H', 'MEDIA'],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isActive = tab == activeTab;

          return GestureDetector(
            onTap: () => onTabChanged(tab),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isActive ? const Color(0xFF6366F1) : Colors.grey.shade400,
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

