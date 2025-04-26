import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../utils/constants.dart';
import 'draggable_symbol.dart';

class DiceSection extends StatelessWidget {
  const DiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final screenAspectRatio = screenSize.width / screenSize.height;
    
    final rollSize = screenAspectRatio < 0.657
        ? (screenSize.width - 20) / 5
        : (0.657 * screenSize.height - 20) / 5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () => gameState.rollDice(),
          child: FittedBox(
            child: Text(
              "Roll",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 50,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          height: rollSize,
          width: rollSize,
          child: Card(
            color: theme.colorScheme.secondaryContainer,
            child: Row(
              children: [
                DraggableSymbol(
                  symbol: GameSymbols.symbols[gameState.diceValue[0]],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: rollSize,
          width: rollSize,
          child: Card(
            color: theme.colorScheme.secondaryContainer,
            child: Row(
              children: [
                DraggableSymbol(
                  symbol: GameSymbols.symbols[gameState.diceValue[1]],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
