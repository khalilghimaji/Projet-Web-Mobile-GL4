import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/fixture_models.dart';

/// Chip for filtering by league
class LeagueFilterChip extends StatelessWidget {
  final League? league;
  final bool isSelected;
  final VoidCallback? onTap;

  const LeagueFilterChip({
    super.key,
    this.league,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAllLeagues = league == null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.grey.shade800.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isAllLeagues && league?.leagueLogo != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: league!.leagueLogo!,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => const SizedBox(width: 20, height: 20),
                  errorWidget: (_, __, ___) => const Icon(Icons.sports_soccer, size: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              isAllLeagues ? 'All Leagues' : (league?.leagueName ?? ''),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade300,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Search bar for leagues
class LeagueSearchBar extends StatefulWidget {
  final List<League> leagues;
  final String currentLeagueId;
  final Function(League) onLeagueSelected;
  final Function(String) onSearchChanged;
  final VoidCallback? onClearFilter;

  const LeagueSearchBar({
    super.key,
    required this.leagues,
    required this.currentLeagueId,
    required this.onLeagueSelected,
    required this.onSearchChanged,
    this.onClearFilter,
  });

  @override
  State<LeagueSearchBar> createState() => _LeagueSearchBarState();
}

class _LeagueSearchBarState extends State<LeagueSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _showDropdown = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<League> get _filteredLeagues {
    if (_searchQuery.isEmpty) return widget.leagues.take(10).toList();
    return widget.leagues.where((league) {
      return league.leagueName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (league.countryName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade800.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(Icons.search, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search leagues...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _showDropdown = value.isNotEmpty;
                    });
                    widget.onSearchChanged(value);
                  },
                  onTap: () {
                    setState(() {
                      _showDropdown = true;
                    });
                  },
                ),
              ),
              if (widget.currentLeagueId != 'all') ...[
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    setState(() {
                      _searchQuery = '';
                      _showDropdown = false;
                    });
                    widget.onClearFilter?.call();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.close, color: Colors.grey.shade400, size: 20),
                  ),
                ),
              ],
              const SizedBox(width: 8),
            ],
          ),
        ),
        if (_showDropdown && _filteredLeagues.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _filteredLeagues.length,
              itemBuilder: (context, index) {
                final league = _filteredLeagues[index];
                final isSelected = league.leagueKey == widget.currentLeagueId;

                return ListTile(
                  dense: true,
                  leading: league.leagueLogo != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: league.leagueLogo!,
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                            placeholder: (_, __) => const SizedBox(width: 32, height: 32),
                            errorWidget: (_, __, ___) => const Icon(Icons.sports_soccer, size: 24),
                          ),
                        )
                      : const Icon(Icons.sports_soccer, size: 24),
                  title: Text(
                    league.leagueName,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF6366F1) : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: league.countryName != null
                      ? Text(
                          league.countryName!,
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        )
                      : null,
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Color(0xFF6366F1))
                      : null,
                  onTap: () {
                    widget.onLeagueSelected(league);
                    _controller.text = league.leagueName;
                    setState(() {
                      _showDropdown = false;
                    });
                    _focusNode.unfocus();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Date tab selector
class DateTabSelector extends StatelessWidget {
  final List<DateTab> tabs;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateTabSelector({
    super.key,
    required this.tabs,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = tab.date.year == selectedDate.year &&
              tab.date.month == selectedDate.month &&
              tab.date.day == selectedDate.day;

          return GestureDetector(
            onTap: () => onDateSelected(tab.date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 65,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.grey.shade800.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tab.isToday ? 'Today' : tab.dayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade400,
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${tab.dayNumber}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade300,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

