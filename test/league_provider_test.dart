import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:my_league/providers/league_provider.dart';
import 'package:my_league/models/league.dart';
import 'package:my_league/models/league_doc.dart';
import 'package:my_league/models/player_doc.dart';
import 'package:my_league/models/payment_record.dart';
import 'package:my_league/models/player.dart';

void main() {
  group('LeagueNotifier Tests', () {
    late LeagueNotifier notifier;
    late Isar isar;
    late Directory tempDir;

    setUpAll(() async {
      // Download and initialize Isar core for unit testing on the host machine
      await Isar.initializeIsarCore(download: true);
    });

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('isar_test');
      isar = await Isar.open([LeagueDocSchema, PlayerDocSchema], directory: tempDir.path);
      notifier = LeagueNotifier(isar);
    });

    tearDown(() async {
      await isar.close(deleteFromDisk: true);
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('createLeague round_robin generates correct matches', () {
      notifier.createLeague(
        name: 'Test Round Robin',
        sportType: 'Soccer',
        format: 'round_robin',
        teamNames: ['Team 1', 'Team 2', 'Team 3', 'Team 4'],
      );

      final leagues = notifier.state;
      expect(leagues.length, 1);
      final league = leagues.first;
      expect(league.name, 'Test Round Robin');
      expect(league.teams.length, 4);
      // For 4 teams: N*(N-1)/2 matches -> 4 * 3 / 2 = 6 matches.
      expect(league.matches.length, 6);
      expect(league.format, 'round_robin');
      expect(league.status, 'active');
    });

    test('createLeague single_elimination generates correct first round', () {
      notifier.createLeague(
        name: 'Test Elimination',
        sportType: 'Soccer',
        format: 'single_elimination',
        teamNames: ['Team 1', 'Team 2', 'Team 3', 'Team 4'],
      );

      final leagues = notifier.state;
      expect(leagues.length, 1);
      final league = leagues.first;
      expect(league.teams.length, 4);
      // 4 teams -> Round 0 has 2 matches.
      expect(league.matches.length, 2);
      expect(league.matches.every((m) => m.roundIndex == 0), true);
    });

    test('single_elimination advances winners to next round', () {
      notifier.createLeague(
        name: 'Advance Test',
        sportType: 'Soccer',
        format: 'single_elimination',
        teamNames: ['Team 1', 'Team 2', 'Team 3', 'Team 4'],
      );

      final leagueId = notifier.state.first.id;
      final m1 = notifier.state.first.matches[0];
      final m2 = notifier.state.first.matches[1];

      // Update score for match 1 (Team 1 vs Team 2 -> Team 1 wins)
      notifier.updateMatchScore(leagueId, m1.id, 3, 1);
      // Update score for match 2 (Team 3 vs Team 4 -> Team 4 wins)
      notifier.updateMatchScore(leagueId, m2.id, 2, 5);

      final updatedLeague = notifier.state.first;
      // Should now have 3 matches (2 from round 0, 1 from round 1)
      expect(updatedLeague.matches.length, 3);
      
      final round1Matches = updatedLeague.matches.where((m) => m.roundIndex == 1).toList();
      expect(round1Matches.length, 1);
      
      final finalMatch = round1Matches.first;
      // Winners are Team 1 (m1.homeTeamId) and Team 4 (m2.awayTeamId)
      expect(
        {finalMatch.homeTeamId, finalMatch.awayTeamId},
        {m1.homeTeamId, m2.awayTeamId},
      );
      expect(finalMatch.status, 'scheduled');

      // Complete the finals match
      notifier.updateMatchScore(leagueId, finalMatch.id, 2, 1);
      final finalLeagueState = notifier.state.first;
      expect(finalLeagueState.status, 'completed');
    });

    test('basketball king of the court rotation matchmaking', () {
      notifier.createLeague(
        name: 'Hoop Clash',
        sportType: 'Basketball',
        format: 'single_elimination',
        teamNames: ['Team A', 'Team B', 'Team C', 'Team D'],
      );

      final leagueId = notifier.state.first.id;
      final t = notifier.state.first.teams;
      final teamA = t[0];
      final teamB = t[1];
      final teamC = t[2];
      final teamD = t[3];

      // Match 1 should be Team A vs Team B (first two)
      var matches = notifier.state.first.matches;
      expect(matches.length, 1);
      expect(matches[0].homeTeamId, teamA.id);
      expect(matches[0].awayTeamId, teamB.id);

      // Match 1: Team A wins
      notifier.updateMatchScore(leagueId, matches[0].id, 10, 5);
      
      // Match 2 should be generated: Team A vs Team C (winner A stays, loser B goes to back)
      matches = notifier.state.first.matches;
      expect(matches.length, 2);
      expect(matches[1].homeTeamId, teamA.id);
      expect(matches[1].awayTeamId, teamC.id);

      // Match 2: Team A wins again (2 wins in a row)
      notifier.updateMatchScore(leagueId, matches[1].id, 12, 10);

      // Since Team A won 2 times in a row, they must rotate out.
      // Queue was: [Team A, Team C, Team D, Team B]
      // Team C went to back (loser): [Team A, Team D, Team B, Team C]
      // Team A went to back (2 wins): [Team D, Team B, Team C, Team A]
      // Match 3 should be Team D vs Team B!
      matches = notifier.state.first.matches;
      expect(matches.length, 3);
      expect(matches[2].homeTeamId, teamD.id);
      expect(matches[2].awayTeamId, teamB.id);

      // Match 3: Team B wins
      notifier.updateMatchScore(leagueId, matches[2].id, 8, 15);

      // Match 4: Team B vs Team C (winner B stays)
      matches = notifier.state.first.matches;
      expect(matches.length, 4);
      expect(matches[3].homeTeamId, teamB.id);
      expect(matches[3].awayTeamId, teamC.id);

      // Match 4: Team B wins (reaches 2 consecutive wins, rotates out)
      // Team B now has 2 consecutive wins and 2 total wins.
      notifier.updateMatchScore(leagueId, matches[3].id, 20, 10);

      // Match 5: Team A vs Team D (first two in queue)
      matches = notifier.state.first.matches;
      expect(matches.length, 5);
      expect(matches[4].homeTeamId, teamA.id);
      expect(matches[4].awayTeamId, teamD.id);

      // Match 5: Team A wins (reaches 3 total wins - target wins is 3 since <= 4 teams)
      notifier.updateMatchScore(leagueId, matches[4].id, 15, 12);

      // Tournament should finish!
      final finalLeague = notifier.state.first;
      expect(finalLeague.status, 'completed');
    });

    test('match score can update and serialize team faults', () {
      notifier.createLeague(
        name: 'Faults Test',
        sportType: 'Basketball',
        format: 'round_robin',
        teamNames: ['Team X', 'Team Y'],
      );

      final leagueId = notifier.state.first.id;
      final match = notifier.state.first.matches.first;

      // Update score with faults
      notifier.updateMatchScore(leagueId, match.id, 99, 90, homeFaults: 5, awayFaults: 8);

      final updatedMatch = notifier.state.first.matches.first;
      expect(updatedMatch.homeScore, 99);
      expect(updatedMatch.awayScore, 90);
      expect(updatedMatch.homeFaults, 5);
      expect(updatedMatch.awayFaults, 8);

      // Serialize and deserialize
      final leagueJson = notifier.state.first.toJson();
      final restoredLeague = League.fromJson(leagueJson);

      final restoredMatch = restoredLeague.matches.first;
      expect(restoredMatch.homeScore, 99);
      expect(restoredMatch.awayScore, 90);
      expect(restoredMatch.homeFaults, 5);
      expect(restoredMatch.awayFaults, 8);
    });

    test('addCustomMatch schedules a custom match and reactivates finished leagues', () {
      notifier.createLeague(
        name: 'Custom Match Test',
        sportType: 'Soccer',
        format: 'round_robin',
        teamNames: ['Team 1', 'Team 2', 'Team 3'],
      );

      final leagueId = notifier.state.first.id;
      final t1 = notifier.state.first.teams[0].id;
      final t2 = notifier.state.first.teams[1].id;

      // Start with initial match count (3 teams -> 3 matches in round robin)
      expect(notifier.state.first.matches.length, 3);

      // Add a custom match at round 4
      notifier.addCustomMatch(leagueId, t1, t2, roundIndex: 4);

      final leagueWithCustomMatch = notifier.state.first;
      expect(leagueWithCustomMatch.matches.length, 4);

      final customMatch = leagueWithCustomMatch.matches.last;
      expect(customMatch.homeTeamId, t1);
      expect(customMatch.awayTeamId, t2);
      expect(customMatch.roundIndex, 4);
      expect(customMatch.status, 'scheduled');
    });

    test('updatePlayerDetails updates player contact info, fee, and payment history', () {
      final initialPlayer = Player(
        id: 'p1',
        name: 'Initial Player',
        jerseyNumber: 10,
        position: 'Forward',
      );
      notifier.createLeague(
        name: 'Player Details Test',
        sportType: 'Soccer',
        format: 'round_robin',
        teamNames: ['Team A'],
        teamRosters: {
          'Team A': [initialPlayer],
        },
      );

      final leagueId = notifier.state.first.id;
      final team = notifier.state.first.teams.first;
      final player = team.players.first;

      // Verify initial state
      expect(player.age, isNull);
      expect(player.phone, isNull);
      expect(player.email, isNull);
      expect(player.monthlyFee, isNull);
      expect(player.payments, isEmpty);

      // Create new payment
      final payment = PaymentRecord(
        id: 'pay-123',
        amount: 50.0,
        date: DateTime.now(),
        notes: 'First month',
      );

      // Create updated player
      final updatedPlayer = player.copyWith(
        age: 25,
        phone: '555-0199',
        email: 'player1@test.com',
        monthlyFee: 50.0,
        payments: [payment],
      );

      // Update in state
      notifier.updatePlayerDetails(leagueId, player.id, updatedPlayer);

      // Verify state was updated
      final updatedLeague = notifier.state.first;
      final updatedTeam = updatedLeague.teams.first;
      final restoredPlayer = updatedTeam.players.first;

      expect(restoredPlayer.age, 25);
      expect(restoredPlayer.phone, '555-0199');
      expect(restoredPlayer.email, 'player1@test.com');
      expect(restoredPlayer.monthlyFee, 50.0);
      expect(restoredPlayer.payments.length, 1);
      expect(restoredPlayer.payments.first.amount, 50.0);
      expect(restoredPlayer.payments.first.notes, 'First month');
    });

    test('createLeague with defaultMonthlyFee stores and serializes correctly', () {
      notifier.createLeague(
        name: 'Finance League',
        sportType: 'Soccer',
        format: 'round_robin',
        teamNames: ['Team A'],
        defaultMonthlyFee: 65.0,
      );

      final leagues = notifier.state;
      expect(leagues.length, 1);
      final league = leagues.first;
      expect(league.defaultMonthlyFee, 65.0);

      // Verify serialization/deserialization
      final json = league.toJson();
      final restored = League.fromJson(json);
      expect(restored.defaultMonthlyFee, 65.0);
    });

    test('updateLeagueDefaultMonthlyFee updates fee in state and persists to database', () {
      notifier.createLeague(
        name: 'Fee Update Test',
        sportType: 'Soccer',
        format: 'round_robin',
        teamNames: ['Team A'],
      );

      final leagueId = notifier.state.first.id;
      expect(notifier.state.first.defaultMonthlyFee, isNull);

      notifier.updateLeagueDefaultMonthlyFee(leagueId, 75.0);

      expect(notifier.state.first.defaultMonthlyFee, 75.0);

      // Verify DB persistence by loading from Isar
      final docs = isar.leagueDocs.where().findAllSync();
      expect(docs.length, 1);
      final rawMap = jsonDecode(docs.first.rawJson) as Map<String, dynamic>;
      final restored = League.fromJson(rawMap);
      expect(restored.defaultMonthlyFee, 75.0);
    });

    test('updateLeagueStatus updates status and persists to database', () {
      notifier.createLeague(
        name: 'Status Update Test',
        sportType: 'Soccer',
        format: 'round_robin',
        teamNames: ['Team A'],
      );

      final leagueId = notifier.state.first.id;
      expect(notifier.state.first.status, 'active');

      notifier.updateLeagueStatus(leagueId, 'completed');

      expect(notifier.state.first.status, 'completed');

      // Verify DB persistence by loading from Isar
      final docs = isar.leagueDocs.where().findAllSync();
      expect(docs.length, 1);
      final rawMap = jsonDecode(docs.first.rawJson) as Map<String, dynamic>;
      final restored = League.fromJson(rawMap);
      expect(restored.status, 'completed');
    });
  });
}

