import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../models/game_state.dart';
import '../widgets/game_board.dart';
import '../widgets/dice_section.dart';
import '../widgets/symbols_panel.dart';
import '../widgets/clear_button.dart';
import '../widgets/rules_button.dart';
import '../widgets/rules_switch.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant,
      appBar: _buildAppBar(context),
      body: Center(
        child: const GameBoard(),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.background, // Match the symbols panel background color
      centerTitle: false, // Align title to the left
      automaticallyImplyLeading: false, // Remove the back button
      title: Text(
        'DÉTRAK',
        style: theme.textTheme.headlineMedium?.copyWith(
          fontSize: 36,
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: RulesButton(),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SlidingSwitch(
            value: true,
            width: 100,
            onChanged: (bool value) {
              if (value == false) {
                AdaptiveTheme.of(context).setDark();
              } else {
                AdaptiveTheme.of(context).setLight();
              }
            },
            height: 35,
            animationDuration: const Duration(milliseconds: 400),
            onTap: () {},
            onDoubleTap: () {},
            onSwipe: () {},
            iconOff: Icons.dark_mode,
            iconOn: Icons.light_mode,
            contentSize: 20,
            colorOn: theme.colorScheme.onPrimary,
            colorOff: theme.colorScheme.onPrimary,
            background: theme.colorScheme.primaryContainer,
            buttonColor: theme.colorScheme.primary,
            inactiveColor: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: RulesSwitch(),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ClearButton(),
        ),
      ],
    );
  }
}