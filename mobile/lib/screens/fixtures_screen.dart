import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/fixtures_provider.dart';
import '../models/fixture_models.dart';
import '../widgets/match/fixture_card.dart';
import '../widgets/match/league_filter_widgets.dart';
import '../widgets/app_drawer.dart';

/// Fixtures screen showing matches by date and league
class FixturesScreen extends ConsumerWidget {
  const FixturesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fixturesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1419),
        elevation: 0,
        title: const Text(
          'Fixtures',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(fixturesProvider.notifier).loadFixtures();
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(fixturesProvider.notifier).loadFixtures();
        },
        child: CustomScrollView(
          slivers: [
            // Search and filter section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey.shade400),
                              const SizedBox(width: 8),
                              const Text(
                                'Search & Filter Leagues',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LeagueSearchBar(
                            leagues: state.allLeagues,
                            currentLeagueId: state.selectedLeagueId,
                            onLeagueSelected: (league) {
                              ref.read(fixturesProvider.notifier).selectLeague(league.leagueKey);
                            },
                            onSearchChanged: (query) {
                              ref.read(fixturesProvider.notifier).setSearchQuery(query);
                            },
                            onClearFilter: () {
                              ref.read(fixturesProvider.notifier).clearFilter();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Date selector
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Date',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DateTabSelector(
                        tabs: state.dateTabs,
                        selectedDate: state.selectedDate,
                        onDateSelected: (date) {
                          ref.read(fixturesProvider.notifier).selectDate(date);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Featured leagues filter chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      LeagueFilterChip(
                        league: null,
                        isSelected: state.selectedLeagueId == 'all',
                        onTap: () {
                          ref.read(fixturesProvider.notifier).selectLeague('all');
                        },
                      ),
                      const SizedBox(width: 8),
                      ...state.featuredLeagues.map((league) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: LeagueFilterChip(
                          league: league,
                          isSelected: state.selectedLeagueId == league.leagueKey,
                          onTap: () {
                            ref.read(fixturesProvider.notifier).selectLeague(league.leagueKey);
                          },
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),

            // Loading state
            if (state.isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF6366F1)),
                      SizedBox(height: 16),
                      Text(
                        'Loading fixtures...',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

            // Error state
            if (state.error != null && !state.isLoading)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      const Text(
                        'Failed to load fixtures',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.error!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(fixturesProvider.notifier).loadFixtures();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),

            // Empty state
            if (!state.isLoading && state.error == null && state.fixturesByLeague.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.event_busy, color: Colors.grey, size: 40),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No matches scheduled',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'There are no fixtures for this date.\nTry selecting a different date.',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

            // Fixtures by league
            if (!state.isLoading && state.error == null && state.fixturesByLeague.isNotEmpty)
              ...state.fixturesByLeague.map((group) => _buildLeagueSection(context, group)),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeagueSection(BuildContext context, FixturesByLeague group) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // League header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: group.league.leagueLogo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: group.league.leagueLogo!,
                              fit: BoxFit.contain,
                              placeholder: (_, __) => const Icon(Icons.sports_soccer, color: Colors.grey),
                              errorWidget: (_, __, ___) => const Icon(Icons.sports_soccer, color: Colors.grey),
                            ),
                          )
                        : const Icon(Icons.sports_soccer, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.league.leagueName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (group.league.countryName != null)
                          Text(
                            group.league.countryName!,
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/standings/${group.league.leagueKey}');
                    },
                    child: Row(
                      children: [
                        Text(
                          'Standings',
                          style: TextStyle(
                            color: const Color(0xFF6366F1),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, color: Color(0xFF6366F1), size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Fixtures
            ...group.fixtures.map((fixture) => FixtureCard(
              fixture: fixture,
              onTap: () {
                context.push('/match/${fixture.eventKey}');
              },
            )),
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

