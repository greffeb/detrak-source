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

    // Hide diagonal score cells in beginner mode
    if (!gameState.advancedRulesEnabled && (scoreItemNo == 0 || scoreItemNo == 6)) {
      return SizedBox(
        height: gridSize,
        width: gridSize,
        child: const SizedBox.shrink(),
      );
    }

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

    // Determine what to display
    Widget contentWidget;
    
    if (gameState.gameScore[scoreItemNo] != 0) {
      // If there's a non-zero score, show it
      contentWidget = Text(
        gameState.gameScore[scoreItemNo].toString(),
        style: theme.textTheme.headlineMedium?.copyWith(
          fontSize: 25,
          color: scoreItemNo == 12
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (scoreItemNo < 12 && // Don't apply to total score
              !gameState.advancedRulesEnabled && 
              gameState.filledLinesWithZeroScore[scoreItemNo]) {
      // In beginner mode, if a line is filled but has no matches, show "0"
      contentWidget = Text(
        "0",
        style: theme.textTheme.headlineMedium?.copyWith(
          fontSize: 25,
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      // Otherwise show blank
      contentWidget = const Text(" ");
    }

    return SizedBox(
      height: gridSize,
      width: gridSize,
      child: Card(
        margin: const EdgeInsets.all(2),
        color: backgroundColor,
        child: FittedBox(
          child: contentWidget,
        ),
      ),
    );
  }
}