import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import '../models/league.dart';
import '../models/team.dart';
import '../models/match.dart';
import '../models/player.dart';
import '../models/league_doc.dart';
import 'basketball_matchmaker.dart';
import 'players_provider.dart';

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError();
});

final leaguesProvider = StateNotifierProvider<LeagueNotifier, List<League>>((ref) {
  final isar = ref.watch(isarProvider);
  return LeagueNotifier(isar, ref);
});

class LeagueNotifier extends StateNotifier<List<League>> {
  final Isar _isar;
  final Ref? _ref;
  final _uuid = const Uuid();

  LeagueNotifier(this._isar, [this._ref]) : super([]) {
    _loadLeagues();
  }

  void _loadLeagues() {
    final docs = _isar.leagueDocs.where().findAllSync();
    state = docs.map((doc) => League.fromJson(jsonDecode(doc.rawJson) as Map<String, dynamic>)).toList();
  }

  // Preset neon colors for team visual highlights
  static const List<String> _presetColors = [
    '#FF453A', // Neon Red
    '#FF9F0A', // Neon Orange
    '#FFD60A', // Neon Yellow
    '#30D158', // Neon Green
    '#0A84FF', // Neon Blue
    '#5E5CE6', // Neon Indigo
    '#BF5AF2', // Neon Purple
    '#FF6482', // Neon Pink
    '#64D2FF', // Neon Light Cyan
    '#00E676', // Light Green
  ];

  // Helper method to add pre-populated sample data for testing
  void loadSampleData() {
    if (state.isNotEmpty) return;

    // 1. Create a Round Robin soccer league
    createLeague(
      name: 'Champions Premier League',
      sportType: 'Soccer',
      format: 'round_robin',
      teamNames: ['Red Bulls', 'Blue Hawks', 'Green Eagles', 'Yellow Jacks'],
    );

    // 2. Create a Single Elimination basketball tournament (King of the Court)
    createLeague(
      name: 'Summer Basket Clash',
      sportType: 'Basketball',
      format: 'single_elimination',
      teamNames: ['Thunder', 'Lakers', 'Warriors', 'Celtics', 'Heat', 'Bulls'],
    );
  }

  // Create new league
  void createLeague({
    required String name,
    required String sportType,
    required String format,
    required List<String> teamNames,
    double? defaultMonthlyFee,
    Map<String, List<Player>>? teamRosters,
  }) {
    final leagueId = _uuid.v4();
    
    // Create Teams
    final teams = List<Team>.generate(teamNames.length, (index) {
      final nameStr = teamNames[index].trim();
      final words = nameStr.split(' ');
      final initials = words.length > 1
          ? '${words[0][0]}${words[1][0]}'.toUpperCase()
          : nameStr.substring(0, nameStr.length > 1 ? 2 : 1).toUpperCase();

      // Get custom roster or fallback to empty list
      final List<Player> roster = teamRosters?[nameStr] ?? const [];

      return Team(
        id: _uuid.v4(),
        name: nameStr,
        initials: initials,
        colorHex: _presetColors[index % _presetColors.length],
        players: roster,
      );
    });

    List<LeagueMatch> matches = [];
    if (sportType.toLowerCase() == 'basketball') {
      matches = _generateBasketballMatches(leagueId, teams);
    } else if (format == 'round_robin') {
      matches = _generateRoundRobinMatches(leagueId, teams);
    } else {
      matches = _generateSingleEliminationMatches(leagueId, teams, 0);
    }

    final league = League(
      id: leagueId,
      name: name,
      sportType: sportType,
      format: format,
      teams: teams,
      matches: matches,
      createdAt: DateTime.now(),
      status: 'active',
      defaultMonthlyFee: defaultMonthlyFee,
    );

    _saveLeague(league);
    state = [...state, league];
  }

  // Delete league
  void deleteLeague(String id) {
    state = state.where((league) => league.id != id).toList();
    _isar.writeTxnSync(() {
      _isar.leagueDocs.filter().leagueIdEqualTo(id).deleteFirstSync();
    });
  }

  // Add a new team to an existing league
  void addTeam(String leagueId, String teamName) {
    state = state.map((league) {
      if (league.id != leagueId) return league;

      final nameStr = teamName.trim();
      final words = nameStr.split(' ');
      final initials = words.length > 1
          ? '${words[0][0]}${words[1][0]}'.toUpperCase()
          : nameStr.substring(0, nameStr.length > 1 ? 2 : 1).toUpperCase();

      final colorIndex = league.teams.length % _presetColors.length;

      final newTeam = Team(
        id: _uuid.v4(),
        name: nameStr,
        initials: initials,
        colorHex: _presetColors[colorIndex],
        players: const [],
      );

      final updatedTeams = [...league.teams, newTeam];
      final nextLeague = league.copyWith(teams: updatedTeams);
      _saveLeague(nextLeague);
      return nextLeague;
    }).toList();
  }

  // Clear all leagues and database data
  void clearAllData() {
    _isar.writeTxnSync(() {
      _isar.clearSync();
    });
    state = [];
    if (_ref != null) {
      _ref.read(playersProvider.notifier).clearState();
    }
  }

  // Update team roster
  void updateTeamRoster(String leagueId, String teamId, List<Player> updatedPlayers) {
    state = state.map((league) {
      if (league.id != leagueId) return league;

      final updatedTeams = league.teams.map((team) {
        if (team.id != teamId) return team;
        return team.copyWith(players: updatedPlayers);
      }).toList();

      final nextLeague = league.copyWith(teams: updatedTeams);
      _saveLeague(nextLeague);
      return nextLeague;
    }).toList();
  }

  // Update details of a specific player in a league (from player list or profiles)
  void updatePlayerDetails(String leagueId, String playerId, Player updatedPlayer) {
    state = state.map((league) {
      if (league.id != leagueId) return league;

      final updatedTeams = league.teams.map((team) {
        final hasPlayer = team.players.any((p) => p.id == playerId);
        if (!hasPlayer) return team;

        final updatedPlayers = team.players.map((p) {
          if (p.id != playerId) return p;
          return updatedPlayer;
        }).toList();

        return team.copyWith(players: updatedPlayers);
      }).toList();

      final nextLeague = league.copyWith(teams: updatedTeams);
      _saveLeague(nextLeague);
      return nextLeague;
    }).toList();

    // Sync to global players provider
    if (_ref != null) {
      _ref.read(playersProvider.notifier).syncPlayerFromLeague(updatedPlayer);
    }
  }

  // Update default monthly fee for a league
  void updateLeagueDefaultMonthlyFee(String leagueId, double? defaultMonthlyFee) {
    state = state.map((league) {
      if (league.id != leagueId) return league;
      final nextLeague = league.copyWith(defaultMonthlyFee: defaultMonthlyFee);
      _saveLeague(nextLeague);
      return nextLeague;
    }).toList();
  }

  // Update status for a league
  void updateLeagueStatus(String leagueId, String status) {
    state = state.map((league) {
      if (league.id != leagueId) return league;
      final nextLeague = league.copyWith(status: status);
      _saveLeague(nextLeague);
      return nextLeague;
    }).toList();
  }

  // Update match score and progression
  void updateMatchScore(String leagueId, String matchId, int homeScore, int awayScore, {int? homeFaults, int? awayFaults}) {
    state = state.map((league) {
      if (league.id != leagueId) return league;

      final updatedMatches = league.matches.map((match) {
        if (match.id != matchId) return match;

        String? winnerId;
        if (homeScore > awayScore) {
          winnerId = match.homeTeamId;
        } else if (awayScore > homeScore) {
          winnerId = match.awayTeamId;
        } else {
          // Draw is valid in round robin.
          // For single elimination/basketball rotation, we fallback to homeTeamId
          winnerId = homeScore >= awayScore ? match.homeTeamId : match.awayTeamId;
        }

        return match.copyWith(
          homeScore: homeScore,
          awayScore: awayScore,
          homeFaults: homeFaults,
          awayFaults: awayFaults,
          status: 'completed',
          winnerId: winnerId,
        );
      }).toList();

      var nextLeagueState = league.copyWith(matches: updatedMatches);

      // If Basketball, check if we need to progress with rotation matchmaking
      if (league.sportType.toLowerCase() == 'basketball') {
        nextLeagueState = _progressBasketball(nextLeagueState);
      } else if (league.format == 'single_elimination') {
        nextLeagueState = _progressSingleElimination(nextLeagueState);
      } else {
        // Round robin: check if all matches are completed to complete the league
        final allCompleted = updatedMatches.every((m) => m.status == 'completed');
        if (allCompleted) {
          nextLeagueState = nextLeagueState.copyWith(status: 'completed');
        }
      }

      _saveLeague(nextLeagueState);
      return nextLeagueState;
    }).toList();
  }

  // Add custom match to a league
  void addCustomMatch(String leagueId, String homeTeamId, String awayTeamId, {int? roundIndex}) {
    state = state.map((league) {
      if (league.id != leagueId) return league;

      final defaultRoundIndex = league.matches.isNotEmpty
          ? league.matches.map((m) => m.roundIndex).reduce((a, b) => a > b ? a : b)
          : 0;

      final newMatch = LeagueMatch(
        id: _uuid.v4(),
        leagueId: leagueId,
        homeTeamId: homeTeamId,
        awayTeamId: awayTeamId,
        roundIndex: roundIndex ?? defaultRoundIndex,
        status: 'scheduled',
      );

      final updatedMatches = [...league.matches, newMatch];

      // Update league status to active if it was completed or setup (reactivating is useful)
      String newStatus = league.status;
      if (newStatus == 'completed') {
        newStatus = 'active';
      }

      final nextLeague = league.copyWith(
        matches: updatedMatches,
        status: newStatus,
      );
      _saveLeague(nextLeague);
      return nextLeague;
    }).toList();
  }

  // Helper method to write a league to Isar
  void _saveLeague(League league) {
    _isar.writeTxnSync(() {
      final existing = _isar.leagueDocs.filter().leagueIdEqualTo(league.id).findFirstSync();
      final doc = LeagueDoc()
        ..id = existing?.id ?? Isar.autoIncrement
        ..leagueId = league.id
        ..name = league.name
        ..sportType = league.sportType
        ..format = league.format
        ..status = league.status
        ..rawJson = jsonEncode(league.toJson());
      _isar.leagueDocs.putSync(doc);
    });
  }

  // Basketball initial match generator
  List<LeagueMatch> _generateBasketballMatches(String leagueId, List<Team> teams) {
    final nextTeams = BasketballMatchmaker.getNextMatchTeams(teams, []);
    if (nextTeams.length < 2) return [];

    return [
      LeagueMatch(
        id: _uuid.v4(),
        leagueId: leagueId,
        homeTeamId: nextTeams[0],
        awayTeamId: nextTeams[1],
        roundIndex: 0,
        status: 'scheduled',
      ),
    ];
  }

  // Basketball rotation progressor
  League _progressBasketball(League league) {
    if (league.matches.isEmpty) return league;
    final lastMatch = league.matches.last;
    if (lastMatch.status != 'completed') {
      return league;
    }

    // Check if any team has reached the target wins to finish the tournament
    final Map<String, int> totalWins = {};
    for (var match in league.matches) {
      if (match.status != 'completed') continue;
      final winnerId = match.winnerId ?? match.homeTeamId;
      totalWins[winnerId] = (totalWins[winnerId] ?? 0) + 1;
    }

    final targetWins = league.teams.length <= 4 ? 3 : 4;
    bool hasWinner = false;
    for (var entry in totalWins.entries) {
      if (entry.value >= targetWins) {
        hasWinner = true;
        break;
      }
    }

    if (hasWinner) {
      return league.copyWith(status: 'completed');
    }

    // Generate the next match
    final nextTeams = BasketballMatchmaker.getNextMatchTeams(league.teams, league.matches);
    if (nextTeams.length < 2) {
      return league.copyWith(status: 'completed');
    }

    final nextMatch = LeagueMatch(
      id: _uuid.v4(),
      leagueId: league.id,
      homeTeamId: nextTeams[0],
      awayTeamId: nextTeams[1],
      roundIndex: league.matches.length, // roundIndex tracks sequential match index
      status: 'scheduled',
    );

    return league.copyWith(
      matches: [...league.matches, nextMatch],
    );
  }

  // Round Robin Berger scheduling algorithm
  List<LeagueMatch> _generateRoundRobinMatches(String leagueId, List<Team> teams) {
    final List<LeagueMatch> list = [];
    final List<Team?> listTeams = List.from(teams);
    if (listTeams.length % 2 != 0) {
      listTeams.add(null); // Bye indicator
    }

    final int numTeams = listTeams.length;
    final int numRounds = numTeams - 1;
    final int matchesPerRound = numTeams ~/ 2;

    for (int round = 0; round < numRounds; round++) {
      for (int matchIdx = 0; matchIdx < matchesPerRound; matchIdx++) {
        final homeIdx = (round + matchIdx) % (numTeams - 1);
        final awayIdx = (numTeams - 1 - matchIdx + round) % (numTeams - 1);

        // Keep the last team constant in position N-1
        final home = matchIdx == 0 ? listTeams[numTeams - 1] : listTeams[homeIdx];
        final away = listTeams[awayIdx];

        if (home != null && away != null) {
          // Alternate home/away to keep scheduling fair
          final isHomeFirst = round % 2 == 0;
          list.add(
            LeagueMatch(
              id: _uuid.v4(),
              leagueId: leagueId,
              homeTeamId: isHomeFirst ? home.id : away.id,
              awayTeamId: isHomeFirst ? away.id : home.id,
              roundIndex: round,
              status: 'scheduled',
            ),
          );
        }
      }
    }
    return list;
  }

  // Single Elimination first round generator
  List<LeagueMatch> _generateSingleEliminationMatches(
    String leagueId,
    List<Team> activeTeams,
    int roundIndex,
  ) {
    final List<LeagueMatch> matches = [];
    
    // We pair active teams. If activeTeams length is odd, the last team gets a bye
    // and advances directly to the next round when we progress.
    for (int i = 0; i < activeTeams.length ~/ 2; i++) {
      matches.add(
        LeagueMatch(
          id: _uuid.v4(),
          leagueId: leagueId,
          homeTeamId: activeTeams[i * 2].id,
          awayTeamId: activeTeams[i * 2 + 1].id,
          roundIndex: roundIndex,
          status: 'scheduled',
        ),
      );
    }
    return matches;
  }

  // Single Elimination bracket progression
  League _progressSingleElimination(League league) {
    // Group matches by round
    final matchesByRound = <int, List<LeagueMatch>>{};
    for (var match in league.matches) {
      matchesByRound.putIfAbsent(match.roundIndex, () => []).add(match);
    }

    final currentRoundIndex = matchesByRound.keys.reduce((a, b) => a > b ? a : b);
    final currentRoundMatches = matchesByRound[currentRoundIndex]!;

    // Check if all matches in the current round are completed
    final allCompleted = currentRoundMatches.every((m) => m.status == 'completed');
    if (!allCompleted) {
      return league;
    }

    // Collect winners from the current round
    final List<String> roundWinners = [];
    for (var m in currentRoundMatches) {
      if (m.winnerId != null) {
        roundWinners.add(m.winnerId!);
      } else {
        // Fallback for draws: winner is team with higher score, if equal, home team advances
        final homeScore = m.homeScore ?? 0;
        final awayScore = m.awayScore ?? 0;
        roundWinners.add(homeScore >= awayScore ? m.homeTeamId : m.awayTeamId);
      }
    }

    // Track active team IDs in current round to identify byes
    final Set<String> activeInRoundIds = {};
    for (var m in currentRoundMatches) {
      activeInRoundIds.add(m.homeTeamId);
      activeInRoundIds.add(m.awayTeamId);
    }

    // Find all advancing teams (which includes winners of previous round or all teams at start)
    List<String> advancingTeamIds = [];
    if (currentRoundIndex == 0) {
      advancingTeamIds = league.teams.map((t) => t.id).toList();
    } else {
      // Winners from previous round matches
      final prevRoundMatches = matchesByRound[currentRoundIndex - 1]!;
      for (var m in prevRoundMatches) {
        if (m.winnerId != null) {
          advancingTeamIds.add(m.winnerId!);
        } else {
          final homeScore = m.homeScore ?? 0;
          final awayScore = m.awayScore ?? 0;
          advancingTeamIds.add(homeScore >= awayScore ? m.homeTeamId : m.awayTeamId);
        }
      }

      // Also include any bye teams from the previous round (teams that advanced but didn't play in previous round)
      final Set<String> prevActiveIds = {};
      for (var m in prevRoundMatches) {
        prevActiveIds.add(m.homeTeamId);
        prevActiveIds.add(m.awayTeamId);
      }

      // Find teams that were eligible to play in the previous round
      List<String> prevEligibleIds = [];
      if (currentRoundIndex - 1 == 0) {
        prevEligibleIds = league.teams.map((t) => t.id).toList();
      } else {
        final doublePrevRoundMatches = matchesByRound[currentRoundIndex - 2]!;
        for (var m in doublePrevRoundMatches) {
          if (m.winnerId != null) {
            prevEligibleIds.add(m.winnerId!);
          } else {
            final homeScore = m.homeScore ?? 0;
            final awayScore = m.awayScore ?? 0;
            prevEligibleIds.add(homeScore >= awayScore ? m.homeTeamId : m.awayTeamId);
          }
        }
        // Add double prev bye teams
        final Set<String> doublePrevActiveIds = {};
        for (var m in doublePrevRoundMatches) {
          doublePrevActiveIds.add(m.homeTeamId);
          doublePrevActiveIds.add(m.awayTeamId);
        }
        List<String> doublePrevEligibleIds = [];
        if (currentRoundIndex - 2 == 0) {
          doublePrevEligibleIds = league.teams.map((t) => t.id).toList();
        } else {
          doublePrevEligibleIds = matchesByRound[currentRoundIndex - 3]!.map((m) => m.winnerId ?? m.homeTeamId).toList(); // Simple approximation
        }
        final doublePrevByes = doublePrevEligibleIds.where((id) => !doublePrevActiveIds.contains(id));
        prevEligibleIds.addAll(doublePrevByes);
      }

      final prevByes = prevEligibleIds.where((id) => !prevActiveIds.contains(id)).toList();
      advancingTeamIds.addAll(prevByes);
    }

    // Teams in current round that had a bye (eligible to play but not paired in any match)
    final byeTeamIds = advancingTeamIds.where((id) => !activeInRoundIds.contains(id)).toList();
    final nextRoundTeamIds = [...roundWinners, ...byeTeamIds];

    // If only 1 team remains, the tournament is finished!
    if (nextRoundTeamIds.length <= 1) {
      return league.copyWith(status: 'completed');
    }

    // Generate matches for the next round
    final nextRoundIndex = currentRoundIndex + 1;
    final List<LeagueMatch> nextMatches = [];

    for (int i = 0; i < nextRoundTeamIds.length ~/ 2; i++) {
      nextMatches.add(
        LeagueMatch(
          id: _uuid.v4(),
          leagueId: league.id,
          homeTeamId: nextRoundTeamIds[i * 2],
          awayTeamId: nextRoundTeamIds[i * 2 + 1],
          roundIndex: nextRoundIndex,
          status: 'scheduled',
        ),
      );
    }

    return league.copyWith(
      matches: [...league.matches, ...nextMatches],
    );
  }

  // Update details of a player globally in all teams/leagues they are in
  void updatePlayerGlobalDetails(Player updatedPlayer) {
    state = state.map((league) {
      bool changed = false;
      final updatedTeams = league.teams.map((team) {
        final hasPlayer = team.players.any((p) => p.id == updatedPlayer.id);
        if (!hasPlayer) return team;

        changed = true;
        final updatedPlayers = team.players.map((p) {
          if (p.id != updatedPlayer.id) return p;
          return updatedPlayer;
        }).toList();

        return team.copyWith(players: updatedPlayers);
      }).toList();

      if (!changed) return league;

      final nextLeague = league.copyWith(teams: updatedTeams);
      _saveLeague(nextLeague);
      return nextLeague;
    }).toList();
  }

  // Remove a player globally from all teams/leagues they are in
  void removePlayerGlobal(String playerId) {
    state = state.map((league) {
      bool changed = false;
      final updatedTeams = league.teams.map((team) {
        final hasPlayer = team.players.any((p) => p.id == playerId);
        if (!hasPlayer) return team;

        changed = true;
        final updatedPlayers = team.players.where((p) => p.id != playerId).toList();
        return team.copyWith(players: updatedPlayers);
      }).toList();

      if (!changed) return league;

      final nextLeague = league.copyWith(teams: updatedTeams);
      _saveLeague(nextLeague);
      return nextLeague;
    }).toList();
  }
}
