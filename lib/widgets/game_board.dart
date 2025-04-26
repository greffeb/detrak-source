import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import 'game_grid.dart';
import 'score_display.dart';
import 'dice_section.dart';
import 'symbols_panel.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final screenAspectRatio = screenSize.width / screenSize.height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final gridSize = screenAspectRatio < 0.657
        ? (screenSize.width - 20) / 7
        : (0.657 * screenSize.height - 20) / 7;

    return ColoredBox(
      color: colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: gridSize * 5,
                      width: gridSize,
                      child: FittedBox(
                        child: Center(
                          child: Image(
                            image: AssetImage(isDarkMode ? 'assets/titreWhite.png' : 'assets/titre.png'),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: gridSize,
                          width: gridSize * 5,
                          child: FittedBox(
                            child: Center(
                              child: Image(
                                image: AssetImage(isDarkMode ? 'assets/scoreWhite.png' : 'assets/score.png'),
                              ),
                            ),
                          ),
                        ),
                        const GameGrid(),
                      ],
                    ),
                    const ScoreColumnDisplay(),
                  ],
                ),
                const ScoreRowDisplay(),
              ],
            ),
            const SymbolsPanel(),
            const DiceSection(),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}