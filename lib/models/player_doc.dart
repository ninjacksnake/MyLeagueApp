import 'package:isar/isar.dart';

part 'player_doc.g.dart';

@collection
class PlayerDoc {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String playerId;

  late String name;
  int? jerseyNumber;
  String? position;
  int? age;
  String? phone;
  String? email;
  double? monthlyFee;
  late String rawPaymentsJson;
}
