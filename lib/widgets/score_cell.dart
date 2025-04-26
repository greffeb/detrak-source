import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';

class ScoreCell extends StatelessWidget {
  final int scoreItemNo;

  const ScoreCell({
    super.key,
    required this.scoreItemNo,
  });

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final screenAspectRatio = screenSize.width / screenSize.height;
    
    final gridSize = screenAspectRatio < 0.657
        ? (screenSize.width - 20) / 7
        : (0.657 * screenSize.height - 20) / 7;

    final isDarkMode = theme.brightness == Brightness.dark;
    final darkerBackground = isDarkMode
        ? Color.alphaBlend(Colors.white.withAlpha(0x15), theme.colorScheme.primaryContainer)
        : Color.alphaBlend(Colors.black.withAlpha(0x15), theme.colorScheme.primaryContainer);

    Color backgroundColor;
    if (scoreItemNo == 12) {
      backgroundColor = theme.colorScheme.primary;
    } else if (scoreItemNo == 0 || scoreItemNo == 6) {
      backgroundColor = darkerBackground;
    } else {
      backgroundColor = theme.colorScheme.primaryContainer;
    }

    return SizedBox(
      height: gridSize,
      width: gridSize,
      child: Card(
        margin: const EdgeInsets.all(2),
        color: backgroundColor,
        child: FittedBox(
          child: gameState.gameScore[scoreItemNo] != 0
              ? Text(
                  gameState.gameScore[scoreItemNo].toString(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 25,
                    color: scoreItemNo == 12
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const Text(" "),
        ),
      ),
    );
  }
}
