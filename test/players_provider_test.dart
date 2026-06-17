import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:my_league/providers/players_provider.dart';
import 'package:my_league/models/player.dart';
import 'package:my_league/models/player_doc.dart';
import 'package:my_league/models/league_doc.dart';
import 'package:my_league/models/payment_record.dart';

void main() {
  group('PlayersNotifier Tests', () {
    late PlayersNotifier notifier;
    late Isar isar;
    late Directory tempDir;

    setUpAll(() async {
      await Isar.initializeIsarCore(download: true);
    });

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('isar_players_test');
      isar = await Isar.open([LeagueDocSchema, PlayerDocSchema], directory: tempDir.path);
      notifier = PlayersNotifier(isar);
    });

    tearDown(() async {
      await isar.close(deleteFromDisk: true);
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('Initial state is empty', () {
      expect(notifier.state, isEmpty);
    });

    test('addPlayer persists and updates state', () {
      final player = Player(
        id: 'player-1',
        name: 'John Doe',
        jerseyNumber: 10,
        position: 'Forward',
        age: 25,
        phone: '123-456-7890',
        email: 'john@example.com',
        monthlyFee: 50.0,
        payments: [],
      );

      notifier.addPlayer(player);

      expect(notifier.state.length, 1);
      expect(notifier.state.first.name, 'John Doe');
      expect(notifier.state.first.id, 'player-1');

      // Verify DB persistence
      final doc = isar.playerDocs.where().playerIdEqualTo('player-1').findFirstSync();
      expect(doc, isNotNull);
      expect(doc!.name, 'John Doe');
    });

    test('updatePlayer modifies record and state', () {
      final player = Player(
        id: 'player-2',
        name: 'Jane Smith',
        jerseyNumber: 7,
      );
      notifier.addPlayer(player);

      final updated = player.copyWith(name: 'Jane Doe', jerseyNumber: 8);
      notifier.updatePlayer(updated);

      expect(notifier.state.first.name, 'Jane Doe');
      expect(notifier.state.first.jerseyNumber, 8);

      final doc = isar.playerDocs.where().playerIdEqualTo('player-2').findFirstSync();
      expect(doc, isNotNull);
      expect(doc!.name, 'Jane Doe');
      expect(doc.jerseyNumber, 8);
    });

    test('deletePlayer removes record and state', () {
      final player = Player(
        id: 'player-3',
        name: 'Bob Johnson',
      );
      notifier.addPlayer(player);
      expect(notifier.state, isNotEmpty);

      notifier.deletePlayer('player-3');
      expect(notifier.state, isEmpty);

      final doc = isar.playerDocs.where().playerIdEqualTo('player-3').findFirstSync();
      expect(doc, isNull);
    });

    test('syncPlayerFromLeague inserts new player if not present', () {
      final player = Player(
        id: 'player-4',
        name: 'Alice Cooper',
      );

      notifier.syncPlayerFromLeague(player);

      expect(notifier.state.length, 1);
      expect(notifier.state.first.name, 'Alice Cooper');

      final doc = isar.playerDocs.where().playerIdEqualTo('player-4').findFirstSync();
      expect(doc, isNotNull);
    });

    test('syncPlayerFromLeague updates player if already present', () {
      final player = Player(
        id: 'player-5',
        name: 'Charlie Brown',
      );
      notifier.addPlayer(player);

      final updated = player.copyWith(name: 'Charlie Brown Jr.', payments: [
        PaymentRecord(id: 'pay-1', amount: 30.0, date: DateTime.now(), notes: 'Jan Fee')
      ]);

      notifier.syncPlayerFromLeague(updated);

      expect(notifier.state.first.name, 'Charlie Brown Jr.');
      expect(notifier.state.first.payments.length, 1);

      final doc = isar.playerDocs.where().playerIdEqualTo('player-5').findFirstSync();
      expect(doc, isNotNull);
      expect(doc!.name, 'Charlie Brown Jr.');
    });

    test('clearState resets memory state', () {
      notifier.addPlayer(Player(id: 'player-6', name: 'David'));
      expect(notifier.state, isNotEmpty);

      notifier.clearState();
      expect(notifier.state, isEmpty);
    });
  });
}
