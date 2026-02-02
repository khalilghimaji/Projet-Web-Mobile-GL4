import '../models/match_models.dart';

/// Utility functions for calculating player positions based on formation

/// Parse formation string into array of line counts
/// Example: "4-3-3" => [4, 3, 3]
List<int> parseFormation(String formation) {
  if (formation.isEmpty) {
    return [4, 4, 2]; // Default formation
  }

  try {
    return formation.split('-').map((e) => int.parse(e)).toList();
  } catch (e) {
    return [4, 4, 2]; // Fallback to default
  }
}

/// Calculate player positions for a given formation
/// Returns list of positions as (x%, y%) for each player excluding goalkeeper
List<Map<String, double>> calculateFormationPositions(
  String formation,
  bool isHome,
) {
  final lines = parseFormation(formation);
  final positions = <Map<String, double>>[];

  // Home team: start at 10%, max at 46%
  // Away team: start at 90%, min at 54%
  final baseY = isHome ? 10.0 : 90.0;
  final yDirection = isHome ? 1 : -1;
  final maxLines = lines.length;

  // Calculate dynamic spacing to fit everything
  // Maximum 36% of the field per team with less space in the middle
  const maxSpace = 36.0;
  final ySpacing = maxLines > 0 ? (maxSpace / maxLines).clamp(0.0, 14.0) : 14.0;

  for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
    final playerCount = lines[lineIndex];
    final y = baseY + (yDirection * ySpacing * lineIndex);
    final xPositions = calculateXPositions(playerCount);

    for (final x in xPositions) {
      positions.add({'x': x, 'y': y});
    }
  }

  return positions;
}

/// Calculate horizontal positions for players in a line
List<double> calculateXPositions(int playerCount) {
  if (playerCount == 1) {
    return [50.0]; // Center
  }

  final positions = <double>[];
  // Use 70% of width (15% margins on each side)
  const margin = 15.0;
  const usableWidth = 70.0;
  final spacing = usableWidth / (playerCount - 1);

  for (var i = 0; i < playerCount; i++) {
    positions.add(margin + (spacing * i));
  }

  return positions;
}

/// Get goalkeeper position
Map<String, double> getGoalkeeperPosition(bool isHome) {
  return {
    'x': 50.0,
    'y': isHome ? 5.0 : 95.0,
  };
}

/// Map formation positions to players
List<PlayerPosition> mapPlayersToFormation(
  List<PlayerPosition> players,
  String formation,
  bool isHome,
) {
  if (players.isEmpty) {
    return [];
  }

  final positions = calculateFormationPositions(formation, isHome);
  final result = <PlayerPosition>[];

  // Separate goalkeeper and outfield players
  final goalkeeper = players.firstWhere(
    (p) => p.position.toLowerCase() == 'gk' || p.position.toLowerCase() == 'goalkeeper',
    orElse: () => players.first, // Use first player as fallback
  );

  final outfieldPlayers = players.where(
    (p) => p.position.toLowerCase() != 'gk' && p.position.toLowerCase() != 'goalkeeper',
  ).toList();

  // Add goalkeeper with proper position
  final gkPos = getGoalkeeperPosition(isHome);
  result.add(PlayerPosition(
    playerId: goalkeeper.playerId,
    playerName: goalkeeper.playerName,
    playerNumber: goalkeeper.playerNumber,
    position: goalkeeper.position,
    row: gkPos['y']!.toInt(),
    col: gkPos['x']!.toInt(),
  ));

  // Map outfield players to formation positions (limit to available positions)
  final maxPlayers = outfieldPlayers.length < positions.length
      ? outfieldPlayers.length
      : positions.length;

  for (var i = 0; i < maxPlayers; i++) {
    final player = outfieldPlayers[i];
    final pos = positions[i];

    result.add(PlayerPosition(
      playerId: player.playerId,
      playerName: player.playerName,
      playerNumber: player.playerNumber,
      position: player.position,
      row: pos['y']!.toInt(),
      col: pos['x']!.toInt(),
    ));
  }

  return result;
}

/// Get formation description
String getFormationDescription(String formation) {
  final descriptions = {
    '4-3-3': 'Attacking formation with wingers',
    '4-4-2': 'Classic balanced formation',
    '4-2-3-1': 'Defensive midfield with attacking three',
    '3-5-2': 'Wing-backs providing width',
    '3-4-3': 'Attacking with three center-backs',
    '5-3-2': 'Defensive formation with wing-backs',
    '4-1-4-1': 'Holding midfielder anchoring',
    '4-5-1': 'Defensive with lone striker',
  };

  return descriptions[formation] ?? 'Custom formation';
}

