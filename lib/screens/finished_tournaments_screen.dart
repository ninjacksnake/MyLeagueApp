import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/league_provider.dart';
import '../providers/locale_provider.dart';
import '../theme/theme.dart';
import '../widgets/glass_card.dart';
import 'league_detail_screen.dart';

class FinishedTournamentsScreen extends ConsumerWidget {
  const FinishedTournamentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagues = ref.watch(leaguesProvider);
    final finishedLeagues = leagues.where((l) => l.status == 'completed').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('finished_tournaments').toUpperCase()),
      ),
      body: SafeArea(
        child: finishedLeagues.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ref.tr('no_finished_tournaments'),
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: finishedLeagues.length,
                itemBuilder: (context, index) {
                  final league = finishedLeagues[index];
                  final isSoccer = league.sportType.toLowerCase() == 'soccer';
                  final isBasketball = league.sportType.toLowerCase() == 'basketball';
                  
                  IconData sportIcon;
                  if (isSoccer) {
                    sportIcon = Icons.sports_soccer;
                  } else if (isBasketball) {
                    sportIcon = Icons.sports_basketball;
                  } else {
                    sportIcon = Icons.sports_tennis;
                  }

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
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppTheme.surface,
                            title: Text(
                              ref.tr('delete_league_title'),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                            ),
                            content: Text(
                              ref.tr('delete_league_confirm').replaceFirst('{name}', league.name),
                              style: TextStyle(color: AppTheme.textPrimary),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text(ref.tr('cancel'), style: TextStyle(color: AppTheme.textSecondary)),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(true),
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
                      onDismissed: (direction) {
                        ref.read(leaguesProvider.notifier).deleteLeague(league.id);
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
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppTheme.highlight.withOpacity(0.15),
                              child: Icon(sportIcon, color: AppTheme.highlight, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    league.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${ref.tr(league.sportType.toLowerCase())} • ${ref.tr(league.format)}',
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
