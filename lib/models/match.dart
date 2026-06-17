class LeagueMatch {
  final String id;
  final String leagueId;
  final String homeTeamId;
  final String awayTeamId;
  final int? homeScore;
  final int? awayScore;
  final int? homeFaults;
  final int? awayFaults;
  final int roundIndex;
  final DateTime? scheduledTime;
  final String status; // 'scheduled', 'live', 'completed'
  final String? winnerId;

  LeagueMatch({
    required this.id,
    required this.leagueId,
    required this.homeTeamId,
    required this.awayTeamId,
    this.homeScore,
    this.awayScore,
    this.homeFaults,
    this.awayFaults,
    required this.roundIndex,
    this.scheduledTime,
    required this.status,
    this.winnerId,
  });

  factory LeagueMatch.fromJson(Map<String, dynamic> json) {
    return LeagueMatch(
      id: json['id'] as String,
      leagueId: json['leagueId'] as String,
      homeTeamId: json['homeTeamId'] as String,
      awayTeamId: json['awayTeamId'] as String,
      homeScore: json['homeScore'] as int?,
      awayScore: json['awayScore'] as int?,
      homeFaults: json['homeFaults'] as int?,
      awayFaults: json['awayFaults'] as int?,
      roundIndex: json['roundIndex'] as int,
      scheduledTime: json['scheduledTime'] != null
          ? DateTime.parse(json['scheduledTime'] as String)
          : null,
      status: json['status'] as String,
      winnerId: json['winnerId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leagueId': leagueId,
      'homeTeamId': homeTeamId,
      'awayTeamId': awayTeamId,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'homeFaults': homeFaults,
      'awayFaults': awayFaults,
      'roundIndex': roundIndex,
      'scheduledTime': scheduledTime?.toIso8601String(),
      'status': status,
      'winnerId': winnerId,
    };
  }

  LeagueMatch copyWith({
    String? id,
    String? leagueId,
    String? homeTeamId,
    String? awayTeamId,
    int? homeScore,
    int? awayScore,
    int? homeFaults,
    int? awayFaults,
    int? roundIndex,
    DateTime? scheduledTime,
    String? status,
    String? winnerId,
  }) {
    return LeagueMatch(
      id: id ?? this.id,
      leagueId: leagueId ?? this.leagueId,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      homeFaults: homeFaults ?? this.homeFaults,
      awayFaults: awayFaults ?? this.awayFaults,
      roundIndex: roundIndex ?? this.roundIndex,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      winnerId: winnerId ?? this.winnerId,
    );
  }
}
