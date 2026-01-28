import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/rankings_provider.dart';

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> {
  @override
  Widget build(BuildContext context) {
    final rankingsState = ref.watch(rankingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Rankings'),
        actions: [
          IconButton(
            onPressed: rankingsState.isLoading
                ? null
                : () => ref.read(rankingsProvider.notifier).loadRankings(),
            icon: rankingsState.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            tooltip: 'Reload rankings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(rankingsProvider.notifier).loadRankings(),
        child: _buildBody(rankingsState),
      ),
    );
  }

  Widget _buildBody(RankingsState state) {
    if (state.isLoading && state.rankings.isEmpty) {
      return _buildLoadingState();
    }

    if (state.error != null && state.rankings.isEmpty) {
      return _buildErrorState(state.error!);
    }

    if (state.rankings.isEmpty) {
      return _buildEmptyState();
    }

    return _buildRankingsContent(state);
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Podium skeleton
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
                  (index) => _buildPodiumSkeletonItem(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Table skeleton
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(5, (index) => _buildTableSkeletonRow()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumSkeletonItem() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 100, height: 16, color: Colors.grey),
        const SizedBox(height: 4),
        Container(width: 60, height: 14, color: Colors.grey),
      ],
    );
  }

  Widget _buildTableSkeletonRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(width: 40, height: 16, color: Colors.grey),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Container(height: 16, color: Colors.grey)),
          const SizedBox(width: 16),
          Container(width: 60, height: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to load rankings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => ref.read(rankingsProvider.notifier).loadRankings(),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Rankings Yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rankings will appear here once users start making predictions',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingsContent(RankingsState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Top 3 Podium
          if (state.topThree.isNotEmpty) _buildPodium(state.topThree),
          const SizedBox(height: 16),
          // Remaining Rankings Table
          if (state.remaining.isNotEmpty) _buildRankingsTable(state.remaining),
        ],
      ),
    );
  }

  Widget _buildPodium(List<RankedUser> topThree) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Top 3 Users',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: topThree
                  .map((rankedUser) => _buildPodiumItem(rankedUser))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumItem(RankedUser rankedUser) {
    final isFirstPlace = rankedUser.rank == 1;

    return Column(
      children: [
        // Medal
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getMedalColor(rankedUser.rank),
            shape: BoxShape.circle,
          ),
          child: Text(
            _getMedalIcon(rankedUser.rank),
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Avatar
        CircleAvatar(
          radius: 35,
          backgroundImage: rankedUser.user.imageUrl.isNotEmpty
              ? NetworkImage(rankedUser.user.imageUrl)
              : null,
          child: rankedUser.user.imageUrl.isEmpty
              ? Text(
                  rankedUser.initials,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(height: 8),

        // User Info
        Text(
          rankedUser.displayName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isFirstPlace ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 16, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              '${rankedUser.user.score} points',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Rank #${rankedUser.rank}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRankingsTable(List<RankedUser> remaining) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Other Rankings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...remaining.map((rankedUser) => _buildTableRow(rankedUser)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(RankedUser rankedUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 50,
            child: Text(
              '#${rankedUser.rank}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: rankedUser.user.imageUrl.isNotEmpty
                ? NetworkImage(rankedUser.user.imageUrl)
                : null,
            child: rankedUser.user.imageUrl.isEmpty
                ? Text(
                    rankedUser.initials,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),

          // Name
          Expanded(
            child: Text(
              rankedUser.displayName,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // Score
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '${rankedUser.user.score}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMedalIcon(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '$rank';
    }
  }

  Color _getMedalColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }
}
