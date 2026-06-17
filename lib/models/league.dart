import 'team.dart';
import 'match.dart';

class League {
  final String id;
  final String name;
  final String sportType; // 'Soccer', 'Basketball', 'Tennis', 'Custom'
  final String format; // 'round_robin', 'single_elimination'
  final List<Team> teams;
  final List<LeagueMatch> matches;
  final DateTime createdAt;
  final String status; // 'setup', 'active', 'completed'
  final double? defaultMonthlyFee;

  League({
    required this.id,
    required this.name,
    required this.sportType,
    required this.format,
    required this.teams,
    required this.matches,
    required this.createdAt,
    required this.status,
    this.defaultMonthlyFee,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] as String,
      name: json['name'] as String,
      sportType: json['sportType'] as String,
      format: json['format'] as String,
      teams: (json['teams'] as List<dynamic>)
          .map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList(),
      matches: (json['matches'] as List<dynamic>)
          .map((e) => LeagueMatch.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
      defaultMonthlyFee: json['defaultMonthlyFee'] != null
          ? (json['defaultMonthlyFee'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sportType': sportType,
      'format': format,
      'teams': teams.map((e) => e.toJson()).toList(),
      'matches': matches.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'defaultMonthlyFee': defaultMonthlyFee,
    };
  }

  League copyWith({
    String? id,
    String? name,
    String? sportType,
    String? format,
    List<Team>? teams,
    List<LeagueMatch>? matches,
    DateTime? createdAt,
    String? status,
    double? defaultMonthlyFee,
  }) {
    return League(
      id: id ?? this.id,
      name: name ?? this.name,
      sportType: sportType ?? this.sportType,
      format: format ?? this.format,
      teams: teams ?? this.teams,
      matches: matches ?? this.matches,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      defaultMonthlyFee: defaultMonthlyFee ?? this.defaultMonthlyFee,
    );
  }
}
