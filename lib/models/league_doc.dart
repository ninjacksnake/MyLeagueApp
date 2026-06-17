import 'package:isar/isar.dart';

part 'league_doc.g.dart';

@collection
class LeagueDoc {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String leagueId;

  late String name;
  late String sportType;
  late String format;
  late String status;
  late String rawJson;
}
