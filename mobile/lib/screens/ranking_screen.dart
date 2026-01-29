import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/providers/rankings_provider.dart';
import 'package:mobile/providers/api_providers.dart';
import 'package:mobile/widgets/app_drawer.dart';
import 'package:mobile/utils/url_utils.dart';

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> {
  @override
  void initState() {
    super.initState();
    // Load rankings when the screen is first opened (only if authenticated)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authStateProvider);
      if (authState.isAuthenticated) {
        ref.read(rankingsProvider.notifier).loadRankings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rankingsState = ref.watch(rankingsProvider);
    final authState = ref.watch(authStateProvider);

    // Check if user is authenticated
    if (!authState.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('User Rankings')),
        drawer: const AppDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.login, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Authentication Required',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please log in to view user rankings',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }

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
      drawer: const AppDrawer(),
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
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(rankingsProvider.notifier).loadRankings();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // Top 3 Podium
            if (state.topThree.isNotEmpty) ...[
              _buildPodium(state.topThree),
              const SizedBox(height: 24),
            ],

            // Remaining Rankings Table
            if (state.remaining.isNotEmpty) ...[
              _buildRankingsTable(state.remaining),
              const SizedBox(height: 16),
            ],

            // Empty state if no rankings
            if (state.topThree.isEmpty && state.remaining.isEmpty)
              const SizedBox(height: 100), // Space for refresh indicator
          ],
        ),
      ),
    );
  }

  Widget _buildPodium(List<RankedUser> topThree) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '🏆 Top 3 Champions 🏆',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Responsive podium layout
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / 3;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: topThree.asMap().entries.map((entry) {
                    final rankedUser = entry.value;
                    return SizedBox(
                      width: itemWidth,
                      child: _buildPodiumItem(rankedUser),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumItem(RankedUser rankedUser) {
    final isFirstPlace = rankedUser.rank == 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Medal with glow effect for first place
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getMedalColor(rankedUser.rank),
            shape: BoxShape.circle,
            boxShadow: isFirstPlace
                ? [
                    BoxShadow(
                      color: Colors.amber.withAlpha((0.3 * 255).round()),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Text(
            _getMedalIcon(rankedUser.rank),
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Avatar with border
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isFirstPlace
                ? const LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                rankedUser.user.imageUrl != null &&
                    rankedUser.user.imageUrl!.isNotEmpty
                ? NetworkImage(UrlUtils.transformUrl(rankedUser.user.imageUrl!))
                : null,
            child:
                rankedUser.user.imageUrl == null ||
                    rankedUser.user.imageUrl!.isEmpty
                ? Text(
                    rankedUser.initials,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isFirstPlace ? Colors.white : Colors.black87,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),

        // User Info with text overflow protection
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                rankedUser.displayName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isFirstPlace ? FontWeight.bold : FontWeight.w600,
                  color: isFirstPlace ? Colors.amber[800] : Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${rankedUser.user.score}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rank #${rankedUser.rank}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRankingsTable(List<RankedUser> remaining) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.leaderboard, color: Colors.amber),
                const SizedBox(width: 8),
                const Text(
                  'Other Rankings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...remaining.map((rankedUser) => _buildTableRow(rankedUser)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(RankedUser rankedUser) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Rank with background
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${rankedUser.rank}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.blue[700],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                rankedUser.user.imageUrl != null &&
                    rankedUser.user.imageUrl!.isNotEmpty
                ? NetworkImage(UrlUtils.transformUrl(rankedUser.user.imageUrl!))
                : null,
            child:
                rankedUser.user.imageUrl == null ||
                    rankedUser.user.imageUrl!.isEmpty
                ? Text(
                    rankedUser.initials,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),

          // Name - Expanded with overflow protection
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rankedUser.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (rankedUser.user.email != null)
                  Text(
                    rankedUser.user.email!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Score with better styling
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${rankedUser.user.score}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
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
