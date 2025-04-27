import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../models/game_state.dart';

class RulesSwitch extends StatelessWidget {
  const RulesSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final theme = Theme.of(context);

    return SlidingSwitch(
      value: gameState.advancedRulesEnabled,
      width: 90,
      onChanged: (bool value) {
        gameState.toggleAdvancedRules(value);
      },
      height: 35,
      animationDuration: const Duration(milliseconds: 400),
      onTap: () {},
      onDoubleTap: () {},
      onSwipe: () {},
      iconOff: Icons.child_care,
      iconOn: Icons.psychology,
      contentSize: 20,
      colorOn: theme.colorScheme.onPrimary,
      colorOff: theme.colorScheme.onPrimary,
      background: theme.colorScheme.primaryContainer,
      buttonColor: theme.colorScheme.primary,
      inactiveColor: theme.colorScheme.onPrimaryContainer,
    );
  }
}