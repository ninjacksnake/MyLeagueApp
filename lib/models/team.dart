import 'player.dart';

class Team {
  final String id;
  final String name;
  final String initials;
  final String colorHex;
  final List<Player> players;

  Team({
    required this.id,
    required this.name,
    required this.initials,
    required this.colorHex,
    required this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as String,
      name: json['name'] as String,
      initials: json['initials'] as String,
      colorHex: json['colorHex'] as String,
      players: json['players'] != null
          ? (json['players'] as List<dynamic>)
              .map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'initials': initials,
      'colorHex': colorHex,
      'players': players.map((e) => e.toJson()).toList(),
    };
  }

  Team copyWith({
    String? id,
    String? name,
    String? initials,
    String? colorHex,
    List<Player>? players,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      colorHex: colorHex ?? this.colorHex,
      players: players ?? this.players,
    );
  }
}
