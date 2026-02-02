import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/fixtures_provider.dart';
import '../providers/api_providers.dart';
import '../models/match_models.dart';
import '../widgets/match/match_header_widget.dart';
import '../widgets/match/match_sections_widgets.dart';
import '../widgets/match/prediction_widget.dart';
import '../screens/score_prediction_page.dart';

class MatchDetailScreen extends ConsumerStatefulWidget {
  final String matchId;

  const MatchDetailScreen({super.key, required this.matchId});

  @override
  ConsumerState<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends ConsumerState<MatchDetailScreen> {
  bool _showPredictionPopup = false;
  PredictionData _prediction = PredictionData.empty();

  @override
  void initState() {
    super.initState();
    _loadPrediction();
  }

  Future<void> _loadPrediction() async {
    try {
      final dio = ref.read(dioProvider);

      // Try to get user prediction
      try {
        final userPredictionResponse = await dio.get('/matches/prediction/${widget.matchId}');
        if (userPredictionResponse.statusCode == 200 && userPredictionResponse.data != null) {
          final data = userPredictionResponse.data;
          final homeScore = data['scoreFirstEquipe'] ?? 0;
          final awayScore = data['scoreSecondEquipe'] ?? 0;

          VoteOption option;
          if (homeScore > awayScore) {
            option = VoteOption.home;
          } else if (homeScore < awayScore) {
            option = VoteOption.away;
          } else {
            option = VoteOption.draw;
          }

          setState(() {
            _prediction = _prediction.copyWith(
              userVote: UserVote(
                option: option,
                homeScore: homeScore,
                awayScore: awayScore,
                diamonds: data['numberOfDiamondsBet'] ?? 1,
              ),
            );
          });
        }
      } catch (e) {
        // No prediction yet, that's fine
      }

      // Try to get prediction stats
      try {
        final statsResponse = await dio.get('/matches/predictions-stats/${widget.matchId}');
        if (statsResponse.statusCode == 200 && statsResponse.data != null) {
          final stats = statsResponse.data;
          setState(() {
            _prediction = _prediction.copyWith(
              totalVotes: stats['totalVotes'] ?? 0,
              homePercentage: (stats['homePercentage'] ?? 0).toDouble(),
              drawPercentage: (stats['drawPercentage'] ?? 0).toDouble(),
              awayPercentage: (stats['awayPercentage'] ?? 0).toDouble(),
              voteEnabled: stats['voteEnabled'] ?? true,
            );
          });
        }
      } catch (e) {
        // Stats not available
      }
    } catch (e) {
      print('Error loading prediction: $e');
    }
  }

  void _onPredictionSubmitted(int homeScore, int awayScore, int diamonds) {
    VoteOption option;
    if (homeScore > awayScore) {
      option = VoteOption.home;
    } else if (homeScore < awayScore) {
      option = VoteOption.away;
    } else {
      option = VoteOption.draw;
    }

    setState(() {
      final previousVote = _prediction.userVote;
      int newTotalVotes = _prediction.totalVotes;

      // Increment total votes if this is a new prediction
      if (previousVote == null) {
        newTotalVotes += 1;
      }

      // Recalculate percentages
      double homePercentage = _prediction.homePercentage;
      double drawPercentage = _prediction.drawPercentage;
      double awayPercentage = _prediction.awayPercentage;

      if (newTotalVotes > 0) {
        int homeVotes = ((_prediction.homePercentage / 100) * _prediction.totalVotes).round();
        int drawVotes = ((_prediction.drawPercentage / 100) * _prediction.totalVotes).round();
        int awayVotes = ((_prediction.awayPercentage / 100) * _prediction.totalVotes).round();

        // Remove previous vote if exists
        if (previousVote != null) {
          if (previousVote.option == VoteOption.home) homeVotes--;
          else if (previousVote.option == VoteOption.draw) drawVotes--;
          else awayVotes--;
        }

        // Add new vote
        if (option == VoteOption.home) homeVotes++;
        else if (option == VoteOption.draw) drawVotes++;
        else awayVotes++;

        homePercentage = (homeVotes / newTotalVotes) * 100;
        drawPercentage = (drawVotes / newTotalVotes) * 100;
        awayPercentage = (awayVotes / newTotalVotes) * 100;
      }

      _prediction = PredictionData(
        totalVotes: newTotalVotes,
        homePercentage: homePercentage,
        drawPercentage: drawPercentage,
        awayPercentage: awayPercentage,
        userVote: UserVote(
          option: option,
          homeScore: homeScore,
          awayScore: awayScore,
          diamonds: diamonds,
        ),
        voteEnabled: _prediction.voteEnabled,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(matchDetailProvider(widget.matchId));

    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      body: SafeArea(
        child: state.isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF6366F1)),
                    SizedBox(height: 16),
                    Text(
                      'Loading match details...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : state.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          state.error!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(matchDetailProvider(widget.matchId).notifier).loadMatchData();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : CustomScrollView(
                    slivers: [
                      // App Bar
                      SliverAppBar(
                        backgroundColor: const Color(0xFF0F1419),
                        floating: true,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                        title: const Text(
                          'Match Detail',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        centerTitle: true,
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.white),
                            onPressed: () {
                              // Share functionality
                            },
                          ),
                        ],
                      ),

                      // Match Header
                      SliverToBoxAdapter(
                        child: MatchHeaderWidget(header: state.matchData.header),
                      ),

                      // Prediction Widget
                      SliverToBoxAdapter(
                        child: PredictionWidget(
                          prediction: _prediction,
                          onPredict: () {
                            _showScorePredictionDialog(context, state.matchData.header);
                          },
                        ),
                      ),

                      // Tabs Navigation
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _TabsHeaderDelegate(
                          activeTab: state.activeTab,
                          onTabChanged: (tab) {
                            ref.read(matchDetailProvider(widget.matchId).notifier).setActiveTab(tab);
                          },
                        ),
                      ),

                      // Content based on active tab
                      SliverToBoxAdapter(
                        child: _buildTabContent(state),
                      ),

                      // Bottom padding
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 100),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildTabContent(MatchDetailState state) {
    switch (state.activeTab) {
      case 'OVERVIEW':
        return MatchTimelineWidget(events: state.matchData.timeline);
      case 'LINEUPS':
        return LineupsPitchWidget(lineups: state.matchData.lineups);
      case 'STATS':
        return TeamStatsWidget(stats: state.matchData.stats);
      case 'H2H':
        return HeadToHeadWidget(h2h: state.matchData.h2h);
      case 'MEDIA':
        return HighlightsWidget(highlights: state.matchData.highlights);
      default:
        return MatchTimelineWidget(events: state.matchData.timeline);
    }
  }

  void _showScorePredictionDialog(BuildContext context, MatchHeader header) {
    showDialog(
      context: context,
      builder: (context) => ScorePredictionDialog(
        team1Name: header.homeTeam.name,
        team2Name: header.awayTeam.name,
        team1Flag: header.homeTeam.logo,
        team2Flag: header.awayTeam.logo,
        score1: _prediction.userVote?.homeScore,
        score2: _prediction.userVote?.awayScore,
        matchId: widget.matchId,
      ),
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        _onPredictionSubmitted(
          result['team1Score'] ?? 0,
          result['team2Score'] ?? 0,
          result['diamonds'] ?? 1,
        );
      }
    });
  }
}

class _TabsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String activeTab;
  final Function(String) onTabChanged;

  _TabsHeaderDelegate({
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF0F1419),
      child: MatchTabsNavigation(
        activeTab: activeTab,
        onTabChanged: onTabChanged,
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant _TabsHeaderDelegate oldDelegate) {
    return oldDelegate.activeTab != activeTab;
  }
}

extension PredictionDataCopyWith on PredictionData {
  PredictionData copyWith({
    int? totalVotes,
    double? homePercentage,
    double? drawPercentage,
    double? awayPercentage,
    UserVote? userVote,
    bool? voteEnabled,
  }) {
    return PredictionData(
      totalVotes: totalVotes ?? this.totalVotes,
      homePercentage: homePercentage ?? this.homePercentage,
      drawPercentage: drawPercentage ?? this.drawPercentage,
      awayPercentage: awayPercentage ?? this.awayPercentage,
      userVote: userVote ?? this.userVote,
      voteEnabled: voteEnabled ?? this.voteEnabled,
    );
  }
}
