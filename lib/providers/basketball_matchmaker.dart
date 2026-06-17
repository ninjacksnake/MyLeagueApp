import '../models/team.dart';
import '../models/match.dart';

class BasketballMatchmaker {
  static List<String> getNextMatchTeams(List<Team> teams, List<LeagueMatch> matches) {
    if (teams.length < 2) return [];

    // Initial queue:
    final List<String> queue = teams.map((t) => t.id).toList();

    // Map to track consecutive wins
    final Map<String, int> consecutiveWins = {for (var id in queue) id: 0};

    // Process completed matches in order to determine final queue and consecutive wins
    for (var match in matches) {
      if (match.status != 'completed') continue;

      final winnerId = match.winnerId;
      final homeId = match.homeTeamId;
      final awayId = match.awayTeamId;

      String actualWinnerId;
      String actualLoserId;

      if (winnerId != null) {
        actualWinnerId = winnerId;
        actualLoserId = (winnerId == homeId) ? awayId : homeId;
      } else {
        // Fallback for a draw: home team advances, away team rotates
        actualWinnerId = homeId;
        actualLoserId = awayId;
      }

      // Loser's streak is broken, loser goes to the back of the queue
      consecutiveWins[actualLoserId] = 0;
      queue.remove(actualLoserId);
      queue.add(actualLoserId);

      // Winner gets +1 consecutive win
      consecutiveWins[actualWinnerId] = (consecutiveWins[actualWinnerId] ?? 0) + 1;

      // If winner reaches 2 consecutive wins, they rotate out to the back of the queue!
      if (consecutiveWins[actualWinnerId] == 2) {
        consecutiveWins[actualWinnerId] = 0;
        queue.remove(actualWinnerId);
        queue.add(actualWinnerId);
      }
    }

    final completedMatches = matches.where((m) => m.status == 'completed').toList();
    if (completedMatches.isEmpty) {
      // Start of tournament: first two teams in the queue
      return [queue[0], queue[1]];
    }

    final lastMatch = completedMatches.last;
    final lastWinnerId = lastMatch.winnerId ?? lastMatch.homeTeamId;

    // Check consecutive wins of the last winner
    final lastWinnerWins = consecutiveWins[lastWinnerId] ?? 0;

    if (lastWinnerWins == 1) {
      // Winner has 1 win, so they stay.
      // Next opponent is the first team in the queue who is NOT the last winner.
      final nextOpponentId = queue.firstWhere((id) => id != lastWinnerId);
      return [lastWinnerId, nextOpponentId];
    } else {
      // Last winner rotated out (wins reset to 0), so we pick the first two teams in the queue!
      return [queue[0], queue[1]];
    }
  }
}
