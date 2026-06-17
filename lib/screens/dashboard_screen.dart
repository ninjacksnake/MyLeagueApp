import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/league.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/payment_record.dart';
import '../providers/league_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/players_provider.dart';
import '../theme/theme.dart';
import '../widgets/glass_card.dart';
import 'create_league_screen.dart';
import 'league_detail_screen.dart';
import 'settings_screen.dart';
import 'finished_tournaments_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;
  String _searchQuery = '';
  
  // Finance tab state
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  int _financeSubTab = 0; // 0: Paid, 1: Unpaid/Pending

  @override
  Widget build(BuildContext context) {
    final leagues = ref.watch(leaguesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('app_title')),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppTheme.textSecondary),
            tooltip: ref.tr('settings'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: AppTheme.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateLeagueScreen()),
                  );
                },
                label: Text(
                  ref.tr('new_league'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Colors.black,
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.black),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            )
          : (_currentIndex == 1
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: AppTheme.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      _showAddPlayerDialog(context, ref);
                    },
                    label: Text(
                      ref.tr('add_player'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Colors.black,
                      ),
                    ),
                    icon: const Icon(Icons.person_add, color: Colors.black),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                )
              : null),
      body: SafeArea(
        child: _buildTabBody(leagues),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppTheme.highlight,
        unselectedItemColor: AppTheme.textSecondary,
        backgroundColor: AppTheme.background,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.emoji_events),
            label: ref.tr('tournaments'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: ref.tr('players'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.monetization_on),
            label: ref.tr('finances'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBody(List<League> leagues) {
    switch (_currentIndex) {
      case 0:
        return _buildTournamentsTab(leagues);
      case 1:
        return _buildGlobalPlayersTab(context, ref, leagues, _searchQuery, (val) {
          setState(() {
            _searchQuery = val;
          });
        });
      case 2:
        return _buildGlobalFinancesTab(leagues);
      default:
        return _buildTournamentsTab(leagues);
    }
  }

  Widget _buildTournamentsTab(List<League> leagues) {
    final activeLeagues = leagues.where((l) => l.status != 'completed').toList();
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Quick Statistics Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ref.tr('dashboard'),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 28,
                      ),
                ),
                const SizedBox(height: 16),
                _buildStatsRow(context, ref, leagues),
              ],
            ),
          ),
        ),

        // Leagues section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              ref.tr('your_tournaments'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    color: AppTheme.textSecondary,
                  ),
            ),
          ),
        ),

        // Leagues List or Empty State
        activeLeagues.isEmpty
            ? SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(context, ref),
              )
            : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final league = activeLeagues[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Dismissible(
                          key: Key(league.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                            ),
                            child: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          ),
                          confirmDismiss: (direction) async {
                            final String? result = await showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppTheme.surface,
                                title: Text(
                                  ref.tr('remove_tournament'),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                                ),
                                content: Text(
                                  ref.tr('remove_tournament_desc'),
                                  style: TextStyle(color: AppTheme.textPrimary),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(null),
                                    child: Text(ref.tr('cancel'), style: TextStyle(color: AppTheme.textSecondary)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop('finish'),
                                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
                                    child: Text(
                                      ref.tr('mark_as_finished'),
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop('delete'),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                    child: Text(
                                      ref.tr('delete_permanently'),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (result == 'finish') {
                              ref.read(leaguesProvider.notifier).updateLeagueStatus(league.id, 'completed');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(ref.tr('tournament_finished')),
                                    backgroundColor: AppTheme.accent,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                              return true;
                            } else if (result == 'delete') {
                              ref.read(leaguesProvider.notifier).deleteLeague(league.id);
                              return true;
                            }
                            return false;
                          },
                          onDismissed: (direction) {
                            // Handled in confirmDismiss
                          },
                          child: GlassCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LeagueDetailScreen(leagueId: league.id),
                                ),
                              );
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
                            child: Row(
                              children: [
                                // Sport Icon Badge
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppTheme.surfaceLight,
                                    border: Border.all(
                                      color: AppTheme.highlight.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Icon(
                                    _getSportIcon(league.sportType),
                                    color: AppTheme.highlight,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Title & Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        league.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 0.2,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            league.format == 'round_robin'
                                                ? ref.tr('round_robin')
                                                : ref.tr('single_elimination'),
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 1),
                                          Container(
                                            width: 4,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: AppTheme.textMuted,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            ref.tr('teams_count').replaceFirst('{count}', league.teams.length.toString()),
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Status Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: league.status == 'completed'
                                        ? AppTheme.highlightAccent.withOpacity(0.15)
                                        : AppTheme.highlight.withOpacity(0.15),
                                    border: Border.all(
                                      color: league.status == 'completed'
                                          ? AppTheme.highlightAccent.withOpacity(0.4)
                                          : AppTheme.highlight.withOpacity(0.4),
                                    ),
                                  ),
                                  child: Text(
                                    league.status == 'completed'
                                        ? ref.tr('finished')
                                        : ref.tr('active'),
                                    style: TextStyle(
                                      color: league.status == 'completed'
                                          ? AppTheme.highlightAccent
                                          : AppTheme.highlight,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: activeLeagues.length,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildGlobalPlayersTab(BuildContext context, WidgetRef ref, List<League> leagues, String searchQuery, Function(String) onSearchChanged) {
    final globalPlayers = ref.watch(playersProvider);
    final List<_GlobalPlayerItem> allPlayers = [];
    for (var player in globalPlayers) {
      Team? team;
      League? league;
      for (var l in leagues) {
        for (var t in l.teams) {
          if (t.players.any((p) => p.id == player.id)) {
            team = t;
            league = l;
            break;
          }
        }
        if (team != null) break;
      }
      allPlayers.add(_GlobalPlayerItem(player: player, team: team, league: league));
    }

    allPlayers.sort((a, b) => a.player.name.toLowerCase().compareTo(b.player.name.toLowerCase()));

    final filteredPlayers = allPlayers.where((item) {
      final query = searchQuery.toLowerCase();
      return item.player.name.toLowerCase().contains(query) ||
          (item.team?.name.toLowerCase().contains(query) ?? false) ||
          (item.league?.name.toLowerCase().contains(query) ?? false) ||
          (item.player.position?.toLowerCase().contains(query) ?? false);
    }).toList();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: '${ref.tr('players')}...',
              prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
              filled: true,
              fillColor: AppTheme.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.highlight.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.highlight),
              ),
            ),
          ),
        ),
        Expanded(
          child: filteredPlayers.isEmpty
              ? Center(
                  child: Text(
                    ref.tr('no_players'),
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredPlayers.length,
                  itemBuilder: (context, index) {
                    final item = filteredPlayers[index];
                    final player = item.player;
                    final team = item.team;
                    final league = item.league;

                    final now = DateTime.now();
                    final currentMonthPayments = player.payments.where((p) => p.date.month == now.month && p.date.year == now.year);
                    final totalPaidThisMonth = currentMonthPayments.fold<double>(0.0, (sum, p) => sum + p.amount);

                    final fee = player.monthlyFee ?? league?.defaultMonthlyFee ?? 0.0;
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

                    final teamColorHex = team?.colorHex.replaceAll('#', '0xFF') ?? '0xFF8E8E93';
                    final teamColor = Color(int.parse(teamColorHex));

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GlassCard(
                        onTap: () => _showGlobalPlayerBottomSheet(context, ref, league, team, player),
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
                                style: TextStyle(color: AppTheme.highlight, fontSize: 13, fontWeight: FontWeight.bold),
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
                                      if (team != null) ...[
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: teamColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                      ],
                                      Expanded(
                                        child: Text(
                                          team != null && league != null
                                              ? '${team.name} • ${league.name}'
                                              : ref.tr('no_team'),
                                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
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
                            if (league != null) ...[
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => _showGlobalRecordPaymentDialog(context, ref, league.id, player),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppTheme.highlightAccent.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.highlightAccent.withOpacity(0.5)),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 16,
                                    color: AppTheme.highlightAccent,
                                  ),
                                ),
                              ),
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

  Widget _buildGlobalFinancesTab(List<League> leagues) {
    double totalCollected = 0.0;
    double totalPending = 0.0;
    final List<_GlobalPlayerItem> paidPlayers = [];
    final List<_GlobalPlayerItem> unpaidPlayers = [];

    final globalPlayers = ref.watch(playersProvider);
    for (var player in globalPlayers) {
      Team? team;
      League? league;
      for (var l in leagues) {
        for (var t in l.teams) {
          if (t.players.any((p) => p.id == player.id)) {
            team = t;
            league = l;
            break;
          }
        }
        if (team != null) break;
      }

      final fee = player.monthlyFee ?? league?.defaultMonthlyFee ?? 0.0;

      final monthPayments = player.payments
          .where((p) => p.date.month == _selectedMonth && p.date.year == _selectedYear)
          .toList();
      final paidThisMonth = monthPayments.fold<double>(0.0, (sum, p) => sum + p.amount);

      totalCollected += paidThisMonth;

      if (fee > 0.0 || paidThisMonth > 0.0) {
        if (paidThisMonth >= fee) {
          paidPlayers.add(_GlobalPlayerItem(player: player, team: team, league: league));
        } else {
          totalPending += (fee - paidThisMonth);
          unpaidPlayers.add(_GlobalPlayerItem(player: player, team: team, league: league));
        }
      }
    }

    final activeList = _financeSubTab == 0 ? paidPlayers : unpaidPlayers;

    return Column(
      children: [
        // Month Picker Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 18, color: AppTheme.highlight),
                onPressed: () {
                  setState(() {
                    if (_selectedMonth == 1) {
                      _selectedMonth = 12;
                      _selectedYear--;
                    } else {
                      _selectedMonth--;
                    }
                  });
                },
              ),
              Text(
                '${ref.tr('month_$_selectedMonth').toUpperCase()} $_selectedYear',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textPrimary, letterSpacing: 0.5),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, size: 18, color: AppTheme.highlight),
                onPressed: () {
                  setState(() {
                    if (_selectedMonth == 12) {
                      _selectedMonth = 1;
                      _selectedYear++;
                    } else {
                      _selectedMonth++;
                    }
                  });
                },
              ),
            ],
          ),
        ),

        // Finances Summary Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ref.tr('total_collected'), style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text(
                        '\$${totalCollected.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.highlightAccent),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ref.tr('total_pending'), style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text(
                        '\$${totalPending.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.statusRed),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Custom segment sub-tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _financeSubTab = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _financeSubTab == 0 ? AppTheme.highlight : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      '${ref.tr('paid_players')} (${paidPlayers.length})',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _financeSubTab == 0 ? AppTheme.highlight : AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _financeSubTab = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _financeSubTab == 1 ? AppTheme.highlight : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      '${ref.tr('unpaid_players')} (${unpaidPlayers.length})',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _financeSubTab == 1 ? AppTheme.highlight : AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // List View of Paid or Unpaid Players
        Expanded(
          child: activeList.isEmpty
              ? Center(
                  child: Text(
                    ref.tr('no_records_for_month'),
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 15),
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: activeList.length,
                  itemBuilder: (context, index) {
                    final item = activeList[index];
                    final player = item.player;
                    final team = item.team;
                    final league = item.league;

                    final monthPayments = player.payments
                        .where((p) => p.date.month == _selectedMonth && p.date.year == _selectedYear)
                        .toList();
                    final paidThisMonth = monthPayments.fold<double>(0.0, (sum, p) => sum + p.amount);
                    final fee = player.monthlyFee ?? league?.defaultMonthlyFee ?? 0.0;

                    final teamColorHex = team?.colorHex.replaceAll('#', '0xFF') ?? '0xFF8E8E93';
                    final teamColor = Color(int.parse(teamColorHex));

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GlassCard(
                        onTap: () => _showGlobalPlayerBottomSheet(context, ref, league, team, player),
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
                                style: TextStyle(color: AppTheme.highlight, fontSize: 13, fontWeight: FontWeight.bold),
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
                                      if (team != null) ...[
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: teamColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                      ],
                                      Expanded(
                                        child: Text(
                                          team != null && league != null
                                              ? '${team.name} • ${league.name}'
                                              : ref.tr('no_team'),
                                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Price Badge
                            _financeSubTab == 0
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.highlightAccent.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppTheme.highlightAccent.withOpacity(0.4)),
                                    ),
                                    child: Text(
                                      '+\$${paidThisMonth.toStringAsFixed(0)}',
                                      style: TextStyle(color: AppTheme.highlightAccent, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.statusRed.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppTheme.statusRed.withOpacity(0.4)),
                                    ),
                                    child: Text(
                                      '\$${paidThisMonth.toStringAsFixed(0)} / \$${fee.toStringAsFixed(0)}',
                                      style: TextStyle(color: AppTheme.statusRed, fontWeight: FontWeight.bold, fontSize: 11),
                                    ),
                                  ),
                            if (league != null) ...[
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => _showGlobalRecordPaymentDialog(context, ref, league.id, player),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppTheme.highlightAccent.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.highlightAccent.withOpacity(0.5)),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 16,
                                    color: AppTheme.highlightAccent,
                                  ),
                                ),
                              ),
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

  void _showGlobalPlayerBottomSheet(BuildContext context, WidgetRef ref, League? league, Team? team, Player initialPlayer) {
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
            final players = ref.watch(playersProvider);
            final playerIndex = players.indexWhere((p) => p.id == initialPlayer.id);
            if (playerIndex == -1) return const SizedBox.shrink();
            final player = players[playerIndex];

            final leagues = ref.watch(leaguesProvider);
            Team? currentTeam;
            League? currentLeague;
            for (var l in leagues) {
              for (var t in l.teams) {
                if (t.players.any((p) => p.id == player.id)) {
                  currentTeam = t;
                  currentLeague = l;
                  break;
                }
              }
              if (currentTeam != null) break;
            }

            final fee = player.monthlyFee ?? currentLeague?.defaultMonthlyFee ?? 0.0;
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
              statusColor = Colors.greenAccent;
            } else {
              statusKey = 'pending';
              statusColor = Colors.redAccent;
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
                                    if (currentTeam != null) ...[
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(currentTeam.colorHex.replaceAll('#', '0xFF'))),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Text(
                                      currentTeam != null && currentLeague != null
                                          ? '${currentTeam.name} • ${currentLeague.name}'
                                          : ref.tr('no_team'),
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
                      _buildGlobalInfoRow(ref, ref.tr('jersey_number'), player.jerseyNumber != null ? '#${player.jerseyNumber}' : '-'),
                      _buildGlobalInfoRow(ref, ref.tr('position'), player.position ?? '-'),
                      _buildGlobalInfoRow(ref, ref.tr('age'), player.age != null ? '${player.age}' : '-'),
                      _buildGlobalInfoRow(ref, ref.tr('phone'), player.phone ?? '-'),
                      _buildGlobalInfoRow(ref, ref.tr('email'), player.email ?? '-'),
                      _buildGlobalInfoRow(ref, ref.tr('monthly_fee'), '\$${fee.toStringAsFixed(2)}'),

                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ref.tr('payment_history').toUpperCase(),
                            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.0),
                          ),
                          if (currentLeague != null)
                            ElevatedButton.icon(
                              onPressed: () => _showGlobalRecordPaymentDialog(context, ref, currentLeague!.id, player),
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
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showGlobalEditPlayerProfileDialog(context, ref, currentLeague, currentTeam, player),
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
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppTheme.surface,
                                  title: Text(
                                    ref.tr('delete_player'),
                                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(
                                    ref.tr('delete_player_confirm'),
                                    style: TextStyle(color: AppTheme.textPrimary),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text(ref.tr('cancel'), style: TextStyle(color: AppTheme.textSecondary)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        ref.read(playersProvider.notifier).deletePlayer(player.id);
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                      child: Text(
                                        ref.tr('delete'),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            style: IconButton.styleFrom(
                              side: const BorderSide(color: Colors.redAccent),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
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

  Widget _buildGlobalInfoRow(WidgetRef ref, String label, String value) {
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

  void _showGlobalEditPlayerProfileDialog(BuildContext context, WidgetRef ref, League? league, Team? team, Player player) {
    final nameController = TextEditingController(text: player.name);
    final jerseyController = TextEditingController(text: player.jerseyNumber?.toString() ?? '');
    final ageController = TextEditingController(text: player.age?.toString() ?? '');
    final phoneController = TextEditingController(text: player.phone ?? '');
    final emailController = TextEditingController(text: player.email ?? '');
    final feeController = TextEditingController(text: player.monthlyFee?.toString() ?? '');

    final positions = _getPositionsForSport(league?.sportType ?? 'Basketball');
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
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            ),
                            items: positions.map((pos) {
                              return DropdownMenuItem<String>(
                                value: pos,
                                child: Text(pos, style: const TextStyle(fontSize: 10)),
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
                              hintText: league?.defaultMonthlyFee != null ? '\$${league!.defaultMonthlyFee}' : null,
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

                    ref.read(playersProvider.notifier).updatePlayer(updatedPlayer);

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

  void _showAddPlayerDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final jerseyController = TextEditingController();
    final ageController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final feeController = TextEditingController();

    final positions = _getPositionsForSport('Basketball');
    String selectedPosition = positions.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              title: Text(
                ref.tr('add_player'),
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
                                if (val != null) selectedPosition = val;
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

                    final newPlayer = Player(
                      id: const Uuid().v4(),
                      name: name,
                      jerseyNumber: jersey,
                      position: selectedPosition.isNotEmpty ? selectedPosition : null,
                      age: age,
                      phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                      email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                      monthlyFee: fee,
                      payments: const [],
                    );

                    ref.read(playersProvider.notifier).addPlayer(newPlayer);

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ref.tr('player_created')),
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

  void _showGlobalRecordPaymentDialog(BuildContext context, WidgetRef ref, String leagueId, Player player) {
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

  Widget _buildStatsRow(BuildContext context, WidgetRef ref, List<dynamic> leagues) {
    final totalLeagues = leagues.length;
    final finishedLeagues = leagues.where((l) => l.status == 'completed').length;
    final activeLeagues = totalLeagues - finishedLeagues;

    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ref.tr('total'), style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text('$totalLeagues', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.highlight)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ref.tr('active_stats'), style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text('$activeLeagues', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.highlightAccent)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GlassCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FinishedTournamentsScreen(),
                ),
              );
            },
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ref.tr('finished_stats'), style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text('$finishedLeagues', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.secondary)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surface,
                border: Border.all(color: AppTheme.primary.withOpacity(0.2), width: 1.5),
              ),
              child: const Icon(
                Icons.emoji_events_outlined,
                size: 64,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              ref.tr('no_leagues_yet'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              ref.tr('no_leagues_desc'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSportIcon(String sportType) {
    switch (sportType.toLowerCase()) {
      case 'soccer':
        return Icons.sports_soccer;
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
        return Icons.sports_tennis;
      default:
        return Icons.emoji_events;
    }
  }
}

class _GlobalPlayerItem {
  final Player player;
  final Team? team;
  final League? league;

  _GlobalPlayerItem({
    required this.player,
    this.team,
    this.league,
  });
}
