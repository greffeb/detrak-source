import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/game_state.dart';
import '../utils/constants.dart';
import 'draggable_symbol.dart';

class DiceSection extends StatefulWidget {
  const DiceSection({super.key});

  @override
  State<DiceSection> createState() => _DiceSectionState();
}

class _DiceSectionState extends State<DiceSection> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Timer _animationTimer;
  List<int> _currentAnimationValues = [1, 1];
  int _slowdownFactor = 1; // Starts fast, will increase to slow down
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _animationController.addListener(() {
      if (_animationController.isAnimating) {
        _updateAnimationSpeed();
      }
    });
    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopDiceAnimation();
      }
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    if (_animationTimer.isActive) {
      _animationTimer.cancel();
    }
    super.dispose();
  }
  
  void _startDiceAnimation() {
    _slowdownFactor = 1;
    _animationController.reset();
    _animationController.forward();
    
    // Start a timer that updates the dice values rapidly
    _animationTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          final gameState = Provider.of<GameState>(context, listen: false);
          _currentAnimationValues = gameState.getRandomDiceValues();
        });
      }
    });
  }
  
  void _updateAnimationSpeed() {
    // As animation progresses, update the timer interval to slow down
    double progress = _animationController.value;
    
    if (progress > 0.7 && _slowdownFactor < 4) {
      _slowdownFactor = 4; // Slow down a lot in the last 30%
      _updateTimerInterval();
    } else if (progress > 0.4 && _slowdownFactor < 2) {
      _slowdownFactor = 2; // Slow down a bit in the middle
      _updateTimerInterval();
    }
  }
  
  void _updateTimerInterval() {
    if (_animationTimer.isActive) {
      _animationTimer.cancel();
    }
    
    _animationTimer = Timer.periodic(Duration(milliseconds: 50 * _slowdownFactor), (timer) {
      if (mounted) {
        setState(() {
          final gameState = Provider.of<GameState>(context, listen: false);
          _currentAnimationValues = gameState.getRandomDiceValues();
        });
      }
    });
  }
  
  void _stopDiceAnimation() {
    if (_animationTimer.isActive) {
      _animationTimer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final screenAspectRatio = screenSize.width / screenSize.height;
    final brightness = theme.brightness;
    
    final rollSize = screenAspectRatio < 0.657
        ? (screenSize.width - 20) / 5
        : (0.657 * screenSize.height - 20) / 5;
    
    // Get theme-aware symbols
    final themeAwareSymbols = GameSymbols.getSymbols(brightness);
    
    // Listen for state changes to start animation
    if (gameState.isRolling && !_animationController.isAnimating) {
      _startDiceAnimation();
    }
    
    // Choose which values to display (animation or final)
    final displayValues = gameState.isRolling 
        ? _currentAnimationValues 
        : gameState.diceValue;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: gameState.isRolling ? null : () => gameState.rollDice(),
          child: FittedBox(
            child: Text(
              "Roll",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 50,
                color: gameState.isRolling 
                    ? theme.colorScheme.primary.withOpacity(0.5) 
                    : theme.colorScheme.primary,
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
                  symbol: themeAwareSymbols[displayValues[0]],
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
                  symbol: themeAwareSymbols[displayValues[1]],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}