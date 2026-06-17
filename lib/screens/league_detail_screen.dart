import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/league.dart';
import '../models/match.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/payment_record.dart';
import '../providers/league_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/players_provider.dart';
import '../theme/theme.dart';
import '../widgets/glass_card.dart';

class LeagueDetailScreen extends ConsumerStatefulWidget {
  final String leagueId;

  const LeagueDetailScreen({super.key, required this.leagueId});

  @override
  ConsumerState<LeagueDetailScreen> createState() => _LeagueDetailScreenState();
}

class _LeagueDetailScreenState extends ConsumerState<LeagueDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedRoundIndex = 0;
  String? _expandedTeamId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leagues = ref.watch(leaguesProvider);
    final leagueIndex = leagues.indexWhere((l) => l.id == widget.leagueId);

    if (leagueIndex == -1) {
      return Scaffold(
        body: Center(child: Text(ref.tr('league_not_found'))),
      );
    }

    final league = leagues[leagueIndex];
    final isRoundRobin = league.format == 'round_robin' || league.sportType.toLowerCase() == 'basketball';

    return Scaffold(
      appBar: AppBar(
        title: Text(league.name.toUpperCase()),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showLeagueSettingsDialog(context, league),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: [
            Tab(text: isRoundRobin ? ref.tr('standings') : ref.tr('bracket')),
            Tab(text: ref.tr('matches')),
            Tab(text: ref.tr('teams')),
            Tab(text: ref.tr('players')),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            isRoundRobin ? _buildStandingsTab(league) : _buildBracketTab(league),
            _buildMatchesTab(league),
            _buildTeamsTab(league),
            _buildPlayersTab(league),
          ],
        ),
      ),
    );
  }

  // Helper to resolve team names/details by ID
  Team? _getTeamById(League league, String id) {
    try {
      return league.teams.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  // --- 1. STANDINGS TAB (Round Robin) ---
  Widget _buildStandingsTab(League league) {
    // Generate standings records
    final records = <String, _StandingRecord>{};
    for (var team in league.teams) {
      records[team.id] = _StandingRecord(team: team);
    }

    for (var match in league.matches) {
      if (match.status != 'completed') continue;

      final home = records[match.homeTeamId];
      final away = records[match.awayTeamId];
      if (home == null || away == null) continue;

      final hs = match.homeScore ?? 0;
      final as = match.awayScore ?? 0;

      home.played++;
      away.played++;
      home.goalsFor += hs;
      home.goalsAgainst += as;
      away.goalsFor += as;
      away.goalsAgainst += hs;

      if (hs > as) {
        home.wins++;
        home.points += 3;
        away.losses++;
      } else if (as > hs) {
        away.wins++;
        away.points += 3;
        home.losses++;
      } else {
        home.draws++;
        home.points += 1;
        away.draws++;
        away.points += 1;
      }
    }

    final sortedRecords = records.values.toList()
      ..sort((a, b) {
        if (b.points != a.points) {
          return b.points.compareTo(a.points);
        }
        final aGD = a.goalsFor - a.goalsAgainst;
        final bGD = b.goalsFor - b.goalsAgainst;
        if (bGD != aGD) {
          return bGD.compareTo(aGD);
        }
        return b.wins.compareTo(a.wins);
      });

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ref.tr('league_standings'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (league.status == 'completed')
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppTheme.accent, size: 18),
                    const SizedBox(width: 4),
                    Text(ref.tr('season_finished'), style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Standings Table Card
          GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      columnSpacing: 24,
                      headingTextStyle: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                      horizontalMargin: 12,
                      columns: [
                        const DataColumn(label: SizedBox(width: 24, child: Text('#'))),
                        DataColumn(label: Text(ref.tr('teams'))),
                        DataColumn(label: Text(ref.tr('played_header')), tooltip: ref.tr('played_tooltip')),
                        DataColumn(label: Text(ref.tr('wins_header')), tooltip: ref.tr('wins_tooltip')),
                        DataColumn(label: Text(ref.tr('draws_header')), tooltip: ref.tr('draws_tooltip')),
                        DataColumn(label: Text(ref.tr('losses_header')), tooltip: ref.tr('losses_tooltip')),
                        DataColumn(label: Text(ref.tr('goal_diff_header')), tooltip: ref.tr('goal_diff_tooltip')),
                        DataColumn(label: Text(ref.tr('points_header')), tooltip: ref.tr('points_tooltip')),
                      ],
                      rows: List.generate(sortedRecords.length, (index) {
                        final record = sortedRecords[index];
                        final gd = record.goalsFor - record.goalsAgainst;
                        final gdStr = gd > 0 ? '+$gd' : '$gd';
                        final teamColorHex = record.team.colorHex.replaceAll('#', '0xFF');
                        final teamColor = Color(int.parse(teamColorHex));

                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                                  color: index == 0 ? AppTheme.primary : AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: teamColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    record.team.name,
                                    style: TextStyle(
                                        fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                                        color: index == 0 ? AppTheme.primary : AppTheme.textPrimary),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text('${record.played}')),
                            DataCell(Text('${record.wins}')),
                            DataCell(Text('${record.draws}')),
                            DataCell(Text('${record.losses}')),
                            DataCell(
                              Text(
                                gdStr,
                                style: TextStyle(
                                  color: gd > 0
                                      ? Colors.greenAccent
                                      : gd < 0
                                          ? Colors.redAccent
                                          : AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${record.points}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _buildLegendItem(ref.tr('played_header'), ref.tr('played_tooltip')),
                _buildLegendItem(ref.tr('wins_header'), ref.tr('wins_tooltip')),
                _buildLegendItem(ref.tr('draws_header'), ref.tr('draws_tooltip')),
                _buildLegendItem(ref.tr('losses_header'), ref.tr('losses_tooltip')),
                _buildLegendItem(ref.tr('goal_diff_header'), ref.tr('goal_diff_tooltip')),
                _buildLegendItem(ref.tr('points_header'), ref.tr('points_tooltip')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String abbr, String full) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          abbr,
          style: const TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          full,
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }


  // --- 2. BRACKET TAB (Single Elimination) ---
  Widget _buildBracketTab(League league) {
    // Group matches by round
    final matchesByRound = <int, List<LeagueMatch>>{};
    for (var match in league.matches) {
      matchesByRound.putIfAbsent(match.roundIndex, () => []).add(match);
    }

    final totalRounds = matchesByRound.keys.isEmpty ? 1 : matchesByRound.keys.reduce((a, b) => a > b ? a : b) + 1;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(totalRounds, (roundIndex) {
          final matches = matchesByRound[roundIndex] ?? [];
          final roundName = _getRoundName(roundIndex, totalRounds, ref);

          return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Round Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roundName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.highlight,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        matches.length == 1
                            ? ref.tr('match_count').replaceFirst('{count}', '1')
                            : ref.tr('matches_count').replaceFirst('{count}', matches.length.toString()),
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Matches for this round
                if (matches.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(ref.tr('tbd_pending'), style: TextStyle(color: AppTheme.textMuted, fontStyle: FontStyle.italic, fontSize: 13)),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        final match = matches[index];
                        final home = _getTeamById(league, match.homeTeamId);
                        final away = _getTeamById(league, match.awayTeamId);

                        // Spacer offset for tree connections visual effect
                        final topPadding = roundIndex > 0 ? (roundIndex * 32.0) : 0.0;
                        final bottomPadding = roundIndex > 0 ? (roundIndex * 48.0) : 12.0;

                        return Padding(
                          padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
                          child: GlassCard(
                            padding: const EdgeInsets.all(12),
                            onTap: () => _showScoreEditDialog(league.id, match, home, away),
                            child: Column(
                              children: [
                                 _buildBracketTeamRow(
                                  home,
                                  match.homeScore,
                                  match.winnerId == match.homeTeamId,
                                  match.status == 'completed',
                                  match.homeFaults,
                                ),
                                const Divider(color: Color(0xFF222F47), height: 16),
                                _buildBracketTeamRow(
                                  away,
                                  match.awayScore,
                                  match.winnerId == match.awayTeamId,
                                  match.status == 'completed',
                                  match.awayFaults,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBracketTeamRow(Team? team, int? score, bool isWinner, bool isCompleted, int? faults) {
    if (team == null) {
      return SizedBox(
        height: 28,
        child: Text(ref.tr('tbd'), style: TextStyle(color: AppTheme.textMuted, fontStyle: FontStyle.italic)),
      );
    }

    final teamColorHex = team.colorHex.replaceAll('#', '0xFF');
    final teamColor = Color(int.parse(teamColorHex));

    return SizedBox(
      height: 28,
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: teamColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              team.name,
              style: TextStyle(
                fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
                color: isCompleted
                    ? (isWinner ? AppTheme.textPrimary : AppTheme.textMuted)
                    : AppTheme.textPrimary,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (score != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (faults != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Text(
                      '($faults ${ref.tr('faults_short')})',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                Text(
                  '$score',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isWinner ? AppTheme.primary : AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            )
          else
            Text('-', style: TextStyle(color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  String _getRoundName(int roundIndex, int totalRounds, WidgetRef ref) {
    if (roundIndex == totalRounds - 1) {
      return ref.tr('finals');
    } else if (roundIndex == totalRounds - 2) {
      return ref.tr('semifinals');
    } else if (roundIndex == totalRounds - 3) {
      return ref.tr('quarterfinals');
    }
    return ref.tr('round_n').replaceFirst('{n}', (roundIndex + 1).toString());
  }

  // --- 3. MATCHES TAB (General list of rounds) ---
  Widget _buildMatchesTab(League league) {
    // Find all distinct round indices
    final roundIndices = league.matches.map((m) => m.roundIndex).toSet().toList()..sort();
    
    // Set default selected round index if out of bounds
    if (roundIndices.isNotEmpty && _selectedRoundIndex >= roundIndices.length) {
      _selectedRoundIndex = 0;
    }

    final currentRound = roundIndices.isNotEmpty ? roundIndices[_selectedRoundIndex] : 0;
    final matchesInRound = roundIndices.isNotEmpty
        ? league.matches.where((m) => m.roundIndex == currentRound).toList()
        : <LeagueMatch>[];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ref.tr('fixtures'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddMatchDialog(league),
                icon: Icon(Icons.add, size: 18, color: AppTheme.highlight),
                label: Text(
                  ref.tr('add_match'),
                  style: TextStyle(
                    color: AppTheme.highlight,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (roundIndices.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  ref.read(localeProvider) == AppLanguage.en
                      ? 'No matches generated.'
                      : 'No se generaron partidos.',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            )
          else ...[
            // Round select chips
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: roundIndices.length,
                itemBuilder: (context, index) {
                  final roundIdx = roundIndices[index];
                  final isSelected = _selectedRoundIndex == index;
                  final roundNameStr = league.sportType.toLowerCase() == 'basketball'
                      ? (ref.read(localeProvider) == AppLanguage.en ? 'Match ${roundIdx + 1}' : 'Partido ${roundIdx + 1}')
                      : (league.format == 'single_elimination'
                          ? _getRoundName(roundIdx, roundIndices.length, ref)
                          : ref.tr('round_n').replaceFirst('{n}', (roundIdx + 1).toString()));

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(roundNameStr),
                      selected: isSelected,
                      selectedColor: AppTheme.highlight.withOpacity(0.18),
                      backgroundColor: AppTheme.surface,
                      checkmarkColor: AppTheme.highlight,
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.highlight : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppTheme.highlight : (AppTheme.isDarkMode ? const Color(0xFF222F47) : const Color(0xFFCBD5E1)),
                          width: 1,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedRoundIndex = index;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Matches list for the selected round
            Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: matchesInRound.length,
              itemBuilder: (context, index) {
                final match = matchesInRound[index];
                final home = _getTeamById(league, match.homeTeamId);
                final away = _getTeamById(league, match.awayTeamId);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GlassCard(
                    onTap: () => _showScoreEditDialog(league.id, match, home, away),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        // Home Team
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  home?.name ?? ref.tr('tbd'),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontWeight: match.winnerId == match.homeTeamId ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 14,
                                    color: match.status == 'completed' && match.winnerId != match.homeTeamId
                                        ? AppTheme.textSecondary
                                        : AppTheme.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                              _buildTeamBadge(home),
                            ],
                          ),
                        ),

                        // Score / vs Indicator
                        Container(
                          width: 90,
                          alignment: Alignment.center,
                          child: match.status == 'completed'
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${match.homeScore} - ${match.awayScore}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primary,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    if (match.homeFaults != null || match.awayFaults != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        '(${match.homeFaults ?? 0} - ${match.awayFaults ?? 0} ${ref.tr('faults_short')})',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppTheme.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppTheme.surfaceLight,
                                  ),
                                  child: Text(
                                    ref.tr('vs'),
                                    style: TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),

                        // Away Team
                        Expanded(
                          child: Row(
                            children: [
                              _buildTeamBadge(away),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  away?.name ?? ref.tr('tbd'),
                                  style: TextStyle(
                                    fontWeight: match.winnerId == match.awayTeamId ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 14,
                                    color: match.status == 'completed' && match.winnerId != match.awayTeamId
                                        ? AppTheme.textSecondary
                                        : AppTheme.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    ),
  );
}

  Widget _buildTeamBadge(Team? team) {
    if (team == null) {
      return CircleAvatar(
        radius: 16,
        backgroundColor: AppTheme.surfaceLight,
        child: Icon(Icons.help_outline, color: AppTheme.textSecondary, size: 16),
      );
    }
    final teamColorHex = team.colorHex.replaceAll('#', '0xFF');
    final teamColor = Color(int.parse(teamColorHex));

    return CircleAvatar(
      radius: 16,
      backgroundColor: teamColor.withOpacity(0.15),
      child: Text(
        team.initials,
        style: TextStyle(
          color: teamColor,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  // --- 4. TEAMS TAB ---
  Widget _buildTeamsTab(League league) {
    return Column(
      children: [
        // Header row with Add Team button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ref.tr('teams'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddTeamDialog(league.id),
                icon: Icon(Icons.add, size: 18, color: AppTheme.highlight),
                label: Text(
                  ref.read(localeProvider) == AppLanguage.en ? 'Add Team' : 'Agregar Equipo',
                  style: TextStyle(
                    color: AppTheme.highlight,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemCount: league.teams.length,
            itemBuilder: (context, index) {
              final team = league.teams[index];
              final isExpanded = _expandedTeamId == team.id;

              // Basic team performance calculation
              int played = 0;
              int wins = 0;
              for (var m in league.matches) {
                if (m.status != 'completed') continue;
                if (m.homeTeamId == team.id || m.awayTeamId == team.id) {
                  played++;
                  if (m.winnerId == team.id) wins++;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GlassCard(
                  onTap: () {
                    setState(() {
                      _expandedTeamId = isExpanded ? null : team.id;
                    });
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildTeamBadge(team),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  team.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ref.tr('roster_initials').replaceFirst('{initials}', team.initials),
                                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                wins == 1
                                    ? ref.tr('win_stats').replaceFirst('{count}', '1')
                                    : ref.tr('wins_stats').replaceFirst('{count}', wins.toString()),
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accent, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ref.tr('played_stats').replaceFirst('{count}', played.toString()),
                                style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        const Divider(color: Color(0xFF222F47), height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ref.tr('roster'),
                              style: const TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _openRosterEditor(league.id, team),
                              icon: const Icon(Icons.edit_outlined, size: 14, color: AppTheme.primary),
                              label: Text(
                                ref.tr('save').toLowerCase() == 'guardar' ? 'Editar' : 'Edit',
                                style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (team.players.isEmpty)
                          Text(
                            ref.tr('no_players'),
                            style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                          )
                        else
                          ...team.players.map((player) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.surfaceLight,
                                    ),
                                    child: Text(
                                      player.jerseyNumber != null ? '${player.jerseyNumber}' : '-',
                                      style: const TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      player.name,
                                      style: TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                                    ),
                                  ),
                                  if (player.position != null)
                                    Text(
                                      player.position!,
                                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                    ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Dialog to add a new team to the league
  void _showAddTeamDialog(String leagueId) {
    final nameController = TextEditingController();
    final isEn = ref.read(localeProvider) == AppLanguage.en;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: Text(
            isEn ? 'Add Team' : 'Agregar Equipo',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: isEn ? 'Team Name' : 'Nombre del Equipo',
              hintText: isEn ? 'e.g., Red Tigers' : 'ej., Tigres Rojos',
              prefixIcon: Icon(Icons.group, color: AppTheme.highlight),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(ref.tr('cancel'), style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                ref.read(leaguesProvider.notifier).addTeam(leagueId, name);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEn ? '"$name" added!' : '¡"$name" agregado!'),
                    backgroundColor: AppTheme.accent,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
              child: Text(
                ref.tr('save'),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // Bottom Sheet to manage player roster post-creation
  void _openRosterEditor(String leagueId, Team team) {
    final List<Player> currentRoster = List.from(team.players);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ref.tr('manage_roster'),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  team.name,
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline, color: AppTheme.highlightAccent, size: 28),
                            onPressed: () {
                              _showPlayerSelectionDialog(context, ref, currentRoster, (selectedPlayer) {
                                setModalState(() {
                                  currentRoster.add(selectedPlayer);
                                });
                              });
                            },
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFF222F47), height: 32),

                      // Player List
                      Expanded(
                        child: currentRoster.isEmpty
                            ? Center(
                                child: Text(
                                  ref.tr('no_players'),
                                  style: TextStyle(color: AppTheme.textMuted),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: currentRoster.length,
                                itemBuilder: (context, pIdx) {
                                  final player = currentRoster[pIdx];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: GlassCard(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: AppTheme.surfaceLight,
                                            child: Text(
                                              player.jerseyNumber != null ? '${player.jerseyNumber}' : '-',
                                              style: const TextStyle(
                                                color: AppTheme.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  player.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.textPrimary,
                                                  ),
                                                ),
                                                if (player.position != null && player.position!.isNotEmpty)
                                                  Text(
                                                    player.position!,
                                                    style: TextStyle(
                                                      color: AppTheme.textSecondary,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.edit_outlined, color: AppTheme.primary, size: 20),
                                            onPressed: () {
                                              _showPlayerDialog(context, player, (updatedPlayer) {
                                                setModalState(() {
                                                  currentRoster[pIdx] = updatedPlayer;
                                                });
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                            onPressed: () {
                                              setModalState(() {
                                                currentRoster.removeAt(pIdx);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),

                      // Save button
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(leaguesProvider.notifier).updateTeamRoster(leagueId, team.id, currentRoster);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            ref.tr('save_roster'),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  List<String> _getPositionsForSport(String sport) {
    switch (sport.toLowerCase()) {
      case 'soccer':
        return ['Goalkeeper', 'Defender', 'Midfielder', 'Forward'];
      case 'basketball':
        return ['Point Guard', 'Shooting Guard', 'Small Forward', 'Power Forward', 'Center'];
      case 'tennis':
        return ['Singles', 'Doubles'];
      default:
        return ['Forward', 'Defender', 'Guard', 'Center', 'Player'];
    }
  }

  void _showPlayerSelectionDialog(
    BuildContext context,
    WidgetRef ref,
    List<Player> currentRoster,
    Function(Player) onPlayerSelected,
  ) {
    final globalPlayers = ref.read(playersProvider);
    final rosterIds = currentRoster.map((p) => p.id).toSet();
    final availablePlayers = globalPlayers.where((p) => !rosterIds.contains(p.id)).toList();

    String filterQuery = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filtered = availablePlayers.where((p) {
              final query = filterQuery.toLowerCase();
              return p.name.toLowerCase().contains(query) ||
                  (p.position?.toLowerCase().contains(query) ?? false);
            }).toList();

            filtered.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

            return AlertDialog(
              backgroundColor: AppTheme.surface,
              title: Text(
                ref.tr('select_player'),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: '${ref.tr('search')}...',
                        prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
                      ),
                      onChanged: (val) {
                        setDialogState(() {
                          filterQuery = val;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                ref.tr('no_players_available'),
                                style: TextStyle(color: AppTheme.textMuted),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final player = filtered[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: GlassCard(
                                    onTap: () {
                                      onPlayerSelected(player);
                                      Navigator.of(context).pop();
                                    },
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: AppTheme.surfaceLight,
                                          child: Text(
                                            player.jerseyNumber != null ? '${player.jerseyNumber}' : '-',
                                            style: TextStyle(
                                              color: AppTheme.highlight,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                player.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.textPrimary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              if (player.position != null && player.position!.isNotEmpty)
                                                Text(
                                                  player.position!,
                                                  style: TextStyle(
                                                    color: AppTheme.textSecondary,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.add_circle, color: AppTheme.primary, size: 22),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(ref.tr('cancel'), style: TextStyle(color: AppTheme.textSecondary)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPlayerDialog(BuildContext context, Player? player, Function(Player) onSave) {
    final nameController = TextEditingController(text: player?.name ?? '');
    final jerseyController = TextEditingController(text: player?.jerseyNumber?.toString() ?? '');
    final ageController = TextEditingController(text: player?.age?.toString() ?? '');
    final phoneController = TextEditingController(text: player?.phone ?? '');
    final emailController = TextEditingController(text: player?.email ?? '');
    final feeController = TextEditingController(text: player?.monthlyFee?.toString() ?? '');

    final FocusNode feeFocusNode = FocusNode();
    feeFocusNode.addListener(() {
      if (feeFocusNode.hasFocus) {
        if (feeController.text == '0.0' || feeController.text == '0') {
          feeController.clear();
        }
      }
    });

    final league = ref.read(leaguesProvider).firstWhere((l) => l.id == widget.leagueId);
    final hintFee = league.defaultMonthlyFee != null ? '\$${league.defaultMonthlyFee}' : null;

    final positions = _getPositionsForSport(league.sportType);
    String? selectedPosition = player?.position;
    if (selectedPosition == null || selectedPosition.isEmpty) {
      selectedPosition = positions.first;
    } else if (!positions.contains(selectedPosition)) {
      positions.add(selectedPosition);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              title: Text(
                player == null ? ref.tr('add_player') : ref.tr('edit_player'),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: ref.tr('player_name'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: jerseyController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: ref.tr('jersey_number'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            dropdownColor: AppTheme.surface,
                            value: selectedPosition,
                            decoration: InputDecoration(
                              labelText: ref.tr('position'),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            items: positions.map((pos) {
                              return DropdownMenuItem<String>(
                                value: pos,
                                child: Text(pos, style: const TextStyle(fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setDialogState(() {
                                selectedPosition = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: ref.tr('age'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: feeController,
                            focusNode: feeFocusNode,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: ref.tr('monthly_fee'),
                              hintText: hintFee,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: ref.tr('phone'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: ref.tr('email'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    feeFocusNode.dispose();
                    Navigator.of(context).pop();
                  },
                  child: Text(ref.tr('cancel'), style: TextStyle(color: AppTheme.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    final jersey = int.tryParse(jerseyController.text);
                    final age = int.tryParse(ageController.text);
                    final fee = double.tryParse(feeController.text);

                    final updatedPlayer = Player(
                      id: player?.id ?? const Uuid().v4(),
                      name: name,
                      jerseyNumber: jersey,
                      position: selectedPosition != null && selectedPosition!.isNotEmpty ? selectedPosition : null,
                      age: age,
                      phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                      email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                      monthlyFee: fee,
                      payments: player?.payments ?? const [],
                    );

                    onSave(updatedPlayer);
                    feeFocusNode.dispose();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                  child: Text(
                    ref.tr('save'),
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Dialog to update Scores
  void _showScoreEditDialog(String leagueId, LeagueMatch match, Team? home, Team? away) {
    if (home == null || away == null) return;

    final homeController = TextEditingController(text: match.homeScore?.toString() ?? '0');
    final awayController = TextEditingController(text: match.awayScore?.toString() ?? '0');
    final homeFaultsController = TextEditingController(text: match.homeFaults?.toString() ?? '0');
    final awayFaultsController = TextEditingController(text: match.awayFaults?.toString() ?? '0');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(ref.tr('update_match_score'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildTeamBadge(home),
                        const SizedBox(height: 8),
                        Text(home.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 12),
                        TextField(
                          controller: homeController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
                          onTap: () {
                            if (homeController.text == '0') {
                              homeController.clear();
                            } else {
                              homeController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: homeController.text.length,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('-', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _buildTeamBadge(away),
                        const SizedBox(height: 8),
                        Text(away.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 12),
                        TextField(
                          controller: awayController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
                          onTap: () {
                            if (awayController.text == '0') {
                              awayController.clear();
                            } else {
                              awayController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: awayController.text.length,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFF222F47), endIndent: 8)),
                  Text(
                    ref.tr('faults').toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMuted,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Expanded(child: Divider(color: Color(0xFF222F47), indent: 8)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: homeFaultsController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        hintText: '0',
                        labelText: ref.tr('home_faults'),
                        labelStyle: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onTap: () {
                        if (homeFaultsController.text == '0') {
                          homeFaultsController.clear();
                        } else {
                          homeFaultsController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: homeFaultsController.text.length,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: TextField(
                      controller: awayFaultsController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        hintText: '0',
                        labelText: ref.tr('away_faults'),
                        labelStyle: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onTap: () {
                        if (awayFaultsController.text == '0') {
                          awayFaultsController.clear();
                        } else {
                          awayFaultsController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: awayFaultsController.text.length,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(ref.tr('cancel'), style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final hs = int.tryParse(homeController.text) ?? 0;
              final as = int.tryParse(awayController.text) ?? 0;
              final hf = int.tryParse(homeFaultsController.text) ?? 0;
              final af = int.tryParse(awayFaultsController.text) ?? 0;

              ref.read(leaguesProvider.notifier).updateMatchScore(
                    leagueId,
                    match.id,
                    hs,
                    as,
                    homeFaults: hf,
                    awayFaults: af,
                  );
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ref.tr('scores_updated')),
                  backgroundColor: AppTheme.accent,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            child: Text(ref.tr('save_score'), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Dialog to Schedule/Add a manual Match
  void _showAddMatchDialog(League league) {
    String? selectedHomeTeamId;
    String? selectedAwayTeamId;

    // Find default round number
    final maxRound = league.matches.isNotEmpty
        ? league.matches.map((m) => m.roundIndex).reduce((a, b) => a > b ? a : b) + 1
        : 1;
    final roundController = TextEditingController(text: maxRound.toString());

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final awayTeams = league.teams.where((t) => t.id != selectedHomeTeamId).toList();

            return AlertDialog(
              backgroundColor: AppTheme.surface,
              title: Text(ref.tr('add_match'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Home Team Dropdown
                    DropdownButtonFormField<String>(
                      dropdownColor: AppTheme.surface,
                      value: selectedHomeTeamId,
                      decoration: InputDecoration(
                        labelText: ref.tr('home_team'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: league.teams.map((team) {
                        final color = Color(int.parse(team.colorHex.replaceAll('#', '0xFF')));
                        return DropdownMenuItem<String>(
                          value: team.id,
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Text(team.name, style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setDialogState(() {
                          selectedHomeTeamId = val;
                          if (selectedAwayTeamId == val) {
                            selectedAwayTeamId = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Away Team Dropdown
                    DropdownButtonFormField<String>(
                      dropdownColor: AppTheme.surface,
                      value: selectedAwayTeamId,
                      decoration: InputDecoration(
                        labelText: ref.tr('away_team'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: awayTeams.map((team) {
                        final color = Color(int.parse(team.colorHex.replaceAll('#', '0xFF')));
                        return DropdownMenuItem<String>(
                          value: team.id,
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Text(team.name, style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setDialogState(() {
                          selectedAwayTeamId = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Round Number Input
                    TextField(
                      controller: roundController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: ref.tr('round'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(ref.tr('cancel'), style: TextStyle(color: AppTheme.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedHomeTeamId == null || selectedAwayTeamId == null) return;
                    if (selectedHomeTeamId == selectedAwayTeamId) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(ref.tr('select_different_teams'))),
                      );
                      return;
                    }

                    final rNum = int.tryParse(roundController.text) ?? maxRound;
                    final rIndex = (rNum - 1).clamp(0, 100);

                    ref.read(leaguesProvider.notifier).addCustomMatch(
                          league.id,
                          selectedHomeTeamId!,
                          selectedAwayTeamId!,
                          roundIndex: rIndex,
                        );

                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ref.tr('match_added')),
                        backgroundColor: AppTheme.accent,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                  child: Text(ref.tr('save'), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPlayersTab(League league) {
    final List<_PlayerWithTeam> allPlayers = [];
    for (var team in league.teams) {
      for (var player in team.players) {
        allPlayers.add(_PlayerWithTeam(player: player, team: team));
      }
    }

    allPlayers.sort((a, b) => a.player.name.toLowerCase().compareTo(b.player.name.toLowerCase()));

    if (allPlayers.isEmpty) {
      return Center(
        child: Text(
          ref.tr('no_players'),
          style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: allPlayers.length,
      itemBuilder: (context, index) {
        final item = allPlayers[index];
        final player = item.player;
        final team = item.team;

        final now = DateTime.now();
        final currentMonthPayments = player.payments.where((p) => p.date.month == now.month && p.date.year == now.year);
        final totalPaidThisMonth = currentMonthPayments.fold<double>(0.0, (sum, p) => sum + p.amount);

        final fee = player.monthlyFee ?? league.defaultMonthlyFee ?? 0.0;
        String statusKey;
        Color statusColor;
        if (fee <= 0.0) {
          statusKey = 'no_fee';
          statusColor = AppTheme.textMuted;
        } else if (totalPaidThisMonth >= fee) {
          statusKey = 'paid';
          statusColor = AppTheme.highlightAccent;
        } else {
          statusKey = 'pending';
          statusColor = AppTheme.statusRed;
        }

        final teamColorHex = team.colorHex.replaceAll('#', '0xFF');
        final teamColor = Color(int.parse(teamColorHex));

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GlassCard(
            onTap: () => _showPlayerDetailsBottomSheet(context, league, team, player),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.surfaceLight,
                  ),
                  child: Text(
                    player.jerseyNumber != null ? '${player.jerseyNumber}' : '-',
                    style: const TextStyle(color: AppTheme.primary, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: teamColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: team.name,
                                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                  ),
                                  if (player.position != null && player.position!.isNotEmpty) ...[
                                    TextSpan(
                                      text: '  •  ${player.position}',
                                      style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                                    ),
                                  ],
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.4), width: 1),
                  ),
                  child: Text(
                    ref.tr(statusKey).toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPlayerDetailsBottomSheet(BuildContext context, League league, Team team, Player initialPlayer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final leagues = ref.watch(leaguesProvider);
            final currentLeagueIndex = leagues.indexWhere((l) => l.id == league.id);
            if (currentLeagueIndex == -1) return const SizedBox.shrink();
            final currentLeague = leagues[currentLeagueIndex];

            final currentTeamIndex = currentLeague.teams.indexWhere((t) => t.id == team.id);
            if (currentTeamIndex == -1) return const SizedBox.shrink();
            final currentTeam = currentLeague.teams[currentTeamIndex];

            final playerIndex = currentTeam.players.indexWhere((p) => p.id == initialPlayer.id);
            if (playerIndex == -1) return const SizedBox.shrink();
            final player = currentTeam.players[playerIndex];

            final fee = player.monthlyFee ?? currentLeague.defaultMonthlyFee ?? 0.0;
            final now = DateTime.now();
            final currentMonthPayments = player.payments.where((p) => p.date.month == now.month && p.date.year == now.year);
            final totalPaidThisMonth = currentMonthPayments.fold<double>(0.0, (sum, p) => sum + p.amount);

            String statusKey;
            Color statusColor;
            if (fee <= 0.0) {
              statusKey = 'no_fee';
              statusColor = AppTheme.textMuted;
            } else if (totalPaidThisMonth >= fee) {
              statusKey = 'paid';
              statusColor = AppTheme.highlightAccent;
            } else {
              statusKey = 'pending';
              statusColor = AppTheme.statusRed;
            }

            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.textMuted.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(currentTeam.colorHex.replaceAll('#', '0xFF'))),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      currentTeam.name,
                                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor.withOpacity(0.4)),
                            ),
                            child: Text(
                              ref.tr(statusKey).toUpperCase(),
                              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFF222F47), height: 32),
                      Text(
                        ref.tr('roster').toUpperCase(),
                        style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.0),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(ref.tr('jersey_number'), player.jerseyNumber != null ? '#${player.jerseyNumber}' : '-'),
                      _buildInfoRow(ref.tr('position'), player.position ?? '-'),
                      _buildInfoRow(ref.tr('age'), player.age != null ? '${player.age}' : '-'),
                      _buildInfoRow(ref.tr('phone'), player.phone ?? '-'),
                      _buildInfoRow(ref.tr('email'), player.email ?? '-'),
                      _buildInfoRow(ref.tr('monthly_fee'), '\$${fee.toStringAsFixed(2)}'),

                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ref.tr('payment_history').toUpperCase(),
                            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.0),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showRecordPaymentDialog(context, currentLeague.id, player),
                            icon: const Icon(Icons.add, size: 16, color: Colors.black),
                            label: Text(
                              ref.tr('record_payment'),
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: player.payments.isEmpty
                            ? Center(
                                child: Text(
                                  ref.tr('no_fee').toLowerCase() == 'sin cuota' ? 'Sin historial de pagos.' : 'No payment history.',
                                  style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                physics: const BouncingScrollPhysics(),
                                itemCount: player.payments.length,
                                itemBuilder: (context, pIndex) {
                                  final p = player.payments[player.payments.length - 1 - pIndex];
                                  final dateStr = '${p.date.year}-${p.date.month.toString().padLeft(2, '0')}-${p.date.day.toString().padLeft(2, '0')}';
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: GlassCard(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '\$${p.amount.toStringAsFixed(2)}',
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accent),
                                              ),
                                              if (p.notes.isNotEmpty) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  p.notes,
                                                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                                ),
                                              ],
                                            ],
                                          ),
                                          Text(
                                            dateStr,
                                            style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showEditPlayerProfileDialog(context, currentLeague, currentTeam, player),
                          icon: const Icon(Icons.edit, color: AppTheme.primary, size: 18),
                          label: Text(
                            ref.tr('edit_player'),
                            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.primary),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          Text(value, style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  void _showEditPlayerProfileDialog(BuildContext context, League league, Team team, Player player) {
    final nameController = TextEditingController(text: player.name);
    final jerseyController = TextEditingController(text: player.jerseyNumber?.toString() ?? '');
    final ageController = TextEditingController(text: player.age?.toString() ?? '');
    final phoneController = TextEditingController(text: player.phone ?? '');
    final emailController = TextEditingController(text: player.email ?? '');
    final feeController = TextEditingController(text: player.monthlyFee?.toString() ?? '');

    final positions = _getPositionsForSport(league.sportType);
    String? selectedPosition = player.position;
    if (selectedPosition == null || selectedPosition.isEmpty) {
      selectedPosition = positions.first;
    } else if (!positions.contains(selectedPosition)) {
      positions.add(selectedPosition);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              title: Text(
                ref.tr('edit_player'),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: ref.tr('player_name'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: jerseyController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: ref.tr('jersey_number'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            dropdownColor: AppTheme.surface,
                            value: selectedPosition,
                            decoration: InputDecoration(
                              labelText: ref.tr('position'),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            items: positions.map((pos) {
                              return DropdownMenuItem<String>(
                                value: pos,
                                child: Text(pos, style: const TextStyle(fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setDialogState(() {
                                selectedPosition = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: ref.tr('age'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: feeController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: ref.tr('monthly_fee'),
                              hintText: league.defaultMonthlyFee != null ? '\$${league.defaultMonthlyFee}' : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: ref.tr('phone'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: ref.tr('email'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(ref.tr('cancel'), style: TextStyle(color: AppTheme.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    final jersey = int.tryParse(jerseyController.text);
                    final age = int.tryParse(ageController.text);
                    final fee = double.tryParse(feeController.text);

                    final updatedPlayer = player.copyWith(
                      name: name,
                      jerseyNumber: jersey,
                      position: selectedPosition != null && selectedPosition!.isNotEmpty ? selectedPosition : null,
                      age: age,
                      phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                      email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                      monthlyFee: fee,
                    );

                    ref.read(leaguesProvider.notifier).updatePlayerDetails(
                          league.id,
                          player.id,
                          updatedPlayer,
                        );

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ref.tr('player_updated')),
                        backgroundColor: AppTheme.accent,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                  child: Text(
                    ref.tr('save'),
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRecordPaymentDialog(BuildContext context, String leagueId, Player player) {
    final league = ref.read(leaguesProvider).firstWhere((l) => l.id == leagueId);
    final amountController = TextEditingController(text: (player.monthlyFee ?? league.defaultMonthlyFee ?? 0.0).toString());
    final notesController = TextEditingController();
    int selectedMonth = DateTime.now().month;

    final FocusNode amountFocusNode = FocusNode();
    amountFocusNode.addListener(() {
      if (amountFocusNode.hasFocus) {
        if (amountController.text == '0.0' || amountController.text == '0') {
          amountController.clear();
        }
      }
    });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              title: Text(
                ref.tr('record_payment'),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      dropdownColor: AppTheme.surface,
                      value: selectedMonth,
                      decoration: InputDecoration(
                        labelText: ref.tr('month'),
                      ),
                      items: List.generate(12, (index) {
                        final monthNum = index + 1;
                        return DropdownMenuItem<int>(
                          value: monthNum,
                          child: Text(ref.tr('month_$monthNum')),
                        );
                      }),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedMonth = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      focusNode: amountFocusNode,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: ref.tr('amount'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(
                        labelText: ref.tr('notes'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(ref.tr('cancel'), style: TextStyle(color: AppTheme.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final amountText = amountController.text.trim();
                    final amount = double.tryParse(amountText);
                    if (amount == null || amount <= 0.0) return;

                    final now = DateTime.now();
                    final maxDay = DateTime(now.year, selectedMonth + 1, 0).day;
                    final day = now.day.clamp(1, maxDay);
                    final paymentDate = DateTime(
                      now.year,
                      selectedMonth,
                      day,
                      now.hour,
                      now.minute,
                      now.second,
                    );

                    final newPayment = PaymentRecord(
                      id: const Uuid().v4(),
                      amount: amount,
                      date: paymentDate,
                      notes: notesController.text.trim(),
                    );

                    final updatedPlayer = player.copyWith(
                      payments: [...player.payments, newPayment],
                    );

                    ref.read(leaguesProvider.notifier).updatePlayerDetails(
                          leagueId,
                          player.id,
                          updatedPlayer,
                        );

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ref.tr('payment_recorded')),
                        backgroundColor: AppTheme.accent,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                  child: Text(
                    ref.tr('save'),
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLeagueSettingsDialog(BuildContext context, League league) {
    final defaultFeeController = TextEditingController(text: league.defaultMonthlyFee?.toString() ?? '');
    final FocusNode feeFocusNode = FocusNode();

    feeFocusNode.addListener(() {
      if (feeFocusNode.hasFocus) {
        if (defaultFeeController.text == '0.0' || defaultFeeController.text == '0') {
          defaultFeeController.clear();
        }
      }
    });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              title: Text(
                ref.tr('tournament_settings'),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: defaultFeeController,
                      focusNode: feeFocusNode,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: ref.tr('default_monthly_fee'),
                        hintText: 'e.g., 50.0',
                        prefixIcon: const Icon(Icons.monetization_on_outlined, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFF222F47)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          feeFocusNode.unfocus();
                          _confirmToggleLeagueStatus(context, league);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: league.status == 'completed'
                                ? AppTheme.accent
                                : Colors.redAccent,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          league.status == 'completed'
                              ? ref.tr('reactivate_tournament')
                              : ref.tr('finish_tournament'),
                          style: TextStyle(
                            color: league.status == 'completed'
                                ? AppTheme.accent
                                : Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    feeFocusNode.dispose();
                    Navigator.of(context).pop();
                  },
                  child: Text(ref.tr('cancel'), style: TextStyle(color: AppTheme.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final fee = double.tryParse(defaultFeeController.text);
                    ref.read(leaguesProvider.notifier).updateLeagueDefaultMonthlyFee(league.id, fee);
                    feeFocusNode.dispose();
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ref.tr('default_fee_updated')),
                        backgroundColor: AppTheme.accent,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                  child: Text(
                    ref.tr('save'),
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmToggleLeagueStatus(BuildContext parentContext, League league) {
    final isCompleted = league.status == 'completed';
    final confirmKey = isCompleted ? 'reactivate_tournament_confirm' : 'finish_tournament_confirm';
    final actionKey = isCompleted ? 'reactivate_tournament' : 'finish_tournament';
    final successKey = isCompleted ? 'tournament_reactivated' : 'tournament_finished';

    showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: Text(
            ref.tr(actionKey),
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
          ),
          content: Text(
            ref.tr(confirmKey),
            style: TextStyle(color: AppTheme.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(ref.tr('no'), style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final newStatus = isCompleted ? 'active' : 'completed';
                ref.read(leaguesProvider.notifier).updateLeagueStatus(league.id, newStatus);
                
                // Pop confirmation dialog
                Navigator.of(context).pop();
                // Pop settings dialog
                Navigator.of(parentContext).pop();

                ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(
                    content: Text(ref.tr(successKey)),
                    backgroundColor: AppTheme.accent,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? AppTheme.primary : Colors.redAccent,
              ),
              child: Text(
                ref.tr('yes'),
                style: TextStyle(
                  color: isCompleted ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Helper class for standings computations
class _StandingRecord {
  final Team team;
  int played = 0;
  int wins = 0;
  int draws = 0;
  int losses = 0;
  int goalsFor = 0;
  int goalsAgainst = 0;
  int points = 0;

  _StandingRecord({required this.team});
}

class _PlayerWithTeam {
  final Player player;
  final Team team;
  _PlayerWithTeam({required this.player, required this.team});
}
