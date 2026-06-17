import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/player.dart';
import '../models/payment_record.dart';
import '../models/player_doc.dart';
import 'league_provider.dart';

final playersProvider = StateNotifierProvider<PlayersNotifier, List<Player>>((ref) {
  final isar = ref.watch(isarProvider);
  return PlayersNotifier(isar, ref);
});

class PlayersNotifier extends StateNotifier<List<Player>> {
  final Isar _isar;
  final Ref? _ref;

  PlayersNotifier(this._isar, [this._ref]) : super([]) {
    _loadPlayers();
  }

  void _loadPlayers() {
    final docs = _isar.playerDocs.where().findAllSync();
    state = docs.map((doc) => _toPlayer(doc)).toList();
  }

  void addPlayer(Player player) {
    final doc = _toDoc(player);
    _isar.writeTxnSync(() {
      _isar.playerDocs.putSync(doc);
    });
    state = [...state, player];
  }

  void updatePlayer(Player player) {
    final existingDoc = _isar.playerDocs.filter().playerIdEqualTo(player.id).findFirstSync();
    final doc = _toDoc(player, existingDoc?.id);
    _isar.writeTxnSync(() {
      _isar.playerDocs.putSync(doc);
    });
    state = state.map((p) => p.id == player.id ? player : p).toList();

    // Also update this player in all leagues/teams they are in
    if (_ref != null) {
      _ref.read(leaguesProvider.notifier).updatePlayerGlobalDetails(player);
    }
  }

  void deletePlayer(String playerId) {
    _isar.writeTxnSync(() {
      _isar.playerDocs.filter().playerIdEqualTo(playerId).deleteFirstSync();
    });
    state = state.where((p) => p.id != playerId).toList();

    // Also remove this player from all leagues/teams they are in
    if (_ref != null) {
      _ref.read(leaguesProvider.notifier).removePlayerGlobal(playerId);
    }
  }

  void clearState() {
    state = [];
  }


  void syncPlayerFromLeague(Player player) {
    final existingDoc = _isar.playerDocs.filter().playerIdEqualTo(player.id).findFirstSync();
    if (existingDoc != null) {
      final doc = _toDoc(player, existingDoc.id);
      _isar.writeTxnSync(() {
        _isar.playerDocs.putSync(doc);
      });
      state = state.map((p) => p.id == player.id ? player : p).toList();
    } else {
      addPlayer(player);
    }
  }

  Player _toPlayer(PlayerDoc doc) {
    List<PaymentRecord> payments = [];
    if (doc.rawPaymentsJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(doc.rawPaymentsJson) as List<dynamic>;
        payments = decoded.map((e) => PaymentRecord.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    return Player(
      id: doc.playerId,
      name: doc.name,
      jerseyNumber: doc.jerseyNumber,
      position: doc.position,
      age: doc.age,
      phone: doc.phone,
      email: doc.email,
      monthlyFee: doc.monthlyFee,
      payments: payments,
    );
  }

  PlayerDoc _toDoc(Player player, [int? isarId]) {
    final paymentsJson = jsonEncode(player.payments.map((e) => e.toJson()).toList());
    final doc = PlayerDoc()
      ..playerId = player.id
      ..name = player.name
      ..jerseyNumber = player.jerseyNumber
      ..position = player.position
      ..age = player.age
      ..phone = player.phone
      ..email = player.email
      ..monthlyFee = player.monthlyFee
      ..rawPaymentsJson = paymentsJson;
    if (isarId != null) {
      doc.id = isarId;
    }
    return doc;
  }
}
