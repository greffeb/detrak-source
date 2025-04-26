import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../utils/constants.dart';

class DropTargetCell extends StatelessWidget {
  final int position;

  const DropTargetCell({
    super.key,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final screenSize = MediaQuery.of(context).size;
    final screenAspectRatio = screenSize.width / screenSize.height;
    
    final gridSize = screenAspectRatio < 0.657
        ? (screenSize.width - 20) / 7
        : (0.657 * screenSize.height - 20) / 7;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final darkerBackground = isDarkMode
        ? Color.alphaBlend(Colors.white.withAlpha(0x11), Theme.of(context).colorScheme.surface)
        : Color.alphaBlend(Colors.black.withAlpha(0x11), Theme.of(context).colorScheme.surface);

    // Check if this is a diagonal cell
    final isDiagonalCell = (position == 4 || position == 8 || position == 12 || position == 16 || position == 20);

    return GestureDetector(
      onLongPress: () {
        if (gameState.gameGrid[position] != 0) {
          gameState.updateScore(position, 0);
        }
      },
      child: DragTarget<int>(
        builder: (context, accepted, rejected) {
          return SizedBox(
            height: gridSize,
            width: gridSize,
            child: Card(
              margin: const EdgeInsets.all(2.0),
              color: isDiagonalCell
                  ? darkerBackground
                  : Theme.of(context).colorScheme.surface,
              child: FittedBox(
                child: Center(
                  child: Image(
                    image: GameSymbols.symbols[
                      GameSymbols.symbols.indexWhere(
                        (symbol) => symbol.id == gameState.gameGrid[position],
                      )
                    ].image,
                  ),
                ),
              ),
            ),
          );
        },
        onAccept: (int data) {
          if (gameState.gameGrid[position] == 0) {
            gameState.updateScore(position, data);
          }
        },
      ),
    );
  }
}
