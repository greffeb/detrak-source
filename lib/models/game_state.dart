import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  // Game grid with 25 cells (5x5)
  final List<int> _gameGrid = List<int>.generate(25, (int index) => 0, growable: false);
  // Score for each row, column, diagonal and total
  final List<int> _gameScore = List<int>.generate(13, (int index) => 0, growable: false);
  // Current dice values
  final List<int> _diceValue = List<int>.generate(2, (int index) => Random().nextInt(6) + 1, growable: false);
  // Animation state
  bool _isRolling = false;
  
  // Getters to expose state
  List<int> get gameGrid => List.unmodifiable(_gameGrid);
  List<int> get gameScore => List.unmodifiable(_gameScore);
  List<int> get diceValue => List.unmodifiable(_diceValue);
  bool get isRolling => _isRolling;

  // Update score when a cell is filled
  void updateScore(int caseId, int caseValue) {
    // If we're just clearing the cell (caseValue == 0)
    if (caseValue == 0) {
      _gameGrid[caseId] = 0;
      _calculateAllScores();
      notifyListeners();
      return;
    }
    
    // If the cell is already filled
    if (_gameGrid[caseId] != 0) {
      // We're replacing a symbol with another symbol
      _gameGrid[caseId] = caseValue;
      _calculateAllScores();
      notifyListeners();
      return;
    }
    
    // Normal case - placing a new symbol in an empty cell
    _gameScore[12] = 0; // Reset total score
    _gameGrid[caseId] = caseValue;
    
    // Recalculate all scores
    _calculateAllScores();
    
    notifyListeners();
  }

  // Calculate all row, column, and diagonal scores
  void _calculateAllScores() {
    // Diagonal score
    _gameScore[0] = _computeScore(_gameGrid[4], _gameGrid[8], _gameGrid[12], _gameGrid[16], _gameGrid[20]);
    
    // Rows scores
    _gameScore[1] = _computeScore(_gameGrid[0], _gameGrid[1], _gameGrid[2], _gameGrid[3], _gameGrid[4]);
    _gameScore[2] = _computeScore(_gameGrid[5], _gameGrid[6], _gameGrid[7], _gameGrid[8], _gameGrid[9]);
    _gameScore[3] = _computeScore(_gameGrid[10], _gameGrid[11], _gameGrid[12], _gameGrid[13], _gameGrid[14]);
    _gameScore[4] = _computeScore(_gameGrid[15], _gameGrid[16], _gameGrid[17], _gameGrid[18], _gameGrid[19]);
    _gameScore[5] = _computeScore(_gameGrid[20], _gameGrid[21], _gameGrid[22], _gameGrid[23], _gameGrid[24]);
    
    // Diagonal score is copied to position 6
    _gameScore[6] = _gameScore[0];
    
    // Columns scores
    _gameScore[7] = _computeScore(_gameGrid[0], _gameGrid[5], _gameGrid[10], _gameGrid[15], _gameGrid[20]);
    _gameScore[8] = _computeScore(_gameGrid[1], _gameGrid[6], _gameGrid[11], _gameGrid[16], _gameGrid[21]);
    _gameScore[9] = _computeScore(_gameGrid[2], _gameGrid[7], _gameGrid[12], _gameGrid[17], _gameGrid[22]);
    _gameScore[10] = _computeScore(_gameGrid[3], _gameGrid[8], _gameGrid[13], _gameGrid[18], _gameGrid[23]);
    _gameScore[11] = _computeScore(_gameGrid[4], _gameGrid[9], _gameGrid[14], _gameGrid[19], _gameGrid[24]);
    
    // Calculate total score
    _gameScore[12] = _gameScore.sublist(0, 12).fold(0, (sum, score) => sum + score);
  }

  // Compute score for a line (row, column or diagonal)
  int _computeScore(int a, int b, int c, int d, int e) {
    // If any cell is empty, return 0
    if (a == 0 || b == 0 || c == 0 || d == 0 || e == 0) return 0;
    
    int score = 0;
    bool scored = false;
    
    // 5 identical symbols
    if (a == b && b == c && c == d && d == e) {
      return 10;
    }
    
    // 4 identical symbols
    if ((a == b && b == c && c == d) || (b == c && c == d && d == e)) {
      return 8;
    }
    
    // 3 identical symbols in the middle
    if (b == c && c == d) {
      return 3;
    }
    
    // 3 identical symbols at the beginning
    if (a == b && b == c) {
      score += 3;
      scored = true;
      // Plus 2 identical symbols at the end
      if (d == e) {
        score += 2;
      }
      return score;
    }
    
    // 3 identical symbols at the end
    if (c == d && d == e) {
      score += 3;
      scored = true;
      // Plus 2 identical symbols at the beginning
      if (a == b) {
        score += 2;
      }
      return score;
    }
    
    // Check for pairs
    if (a == b) {
      score += 2;
      scored = true;
    }
    if (b == c) {
      score += 2;
      scored = true;
    }
    if (c == d) {
      score += 2;
      scored = true;
    }
    if (d == e) {
      score += 2;
      scored = true;
    }
    
    // If no matches found, return -5
    return scored ? score : -5;
  }

  // Move a symbol from one cell to another
  void moveSymbol(int fromPosition, int toPosition) {
    if (fromPosition == toPosition) return; // No change needed
    
    // Get the symbol at the source position
    final symbol = _gameGrid[fromPosition];
    if (symbol == 0) return; // Nothing to move
    
    // Clear the source position
    _gameGrid[fromPosition] = 0;
    
    // Place the symbol at the target position
    _gameGrid[toPosition] = symbol;
    
    // Recalculate scores
    _calculateAllScores();
    
    notifyListeners();
  }

  // Start the dice rolling animation
  void startRolling() {
    _isRolling = true;
    notifyListeners();
  }
  
  // Stop the dice rolling animation and set final values
  void stopRolling(List<int> finalValues) {
    _diceValue[0] = finalValues[0];
    _diceValue[1] = finalValues[1];
    _isRolling = false;
    notifyListeners();
  }
  
  // Generate random dice values during animation
  List<int> getRandomDiceValues() {
    return [
      Random().nextInt(6) + 1,
      Random().nextInt(6) + 1
    ];
  }

  // Roll the dice with animation
  void rollDice() {
    startRolling();
    
    // Generate final values
    final finalValues = [
      Random().nextInt(6) + 1,
      Random().nextInt(6) + 1
    ];
    
    // We'll handle the actual animation in the DiceSection widget
    // but we generate and store the final values here
    Future.delayed(const Duration(milliseconds: 1500), () {
      stopRolling(finalValues);
    });
  }

  // Clear the game grid and scores
  void clearGrid() {
    for (int i = 0; i < _gameScore.length; i++) {
      _gameScore[i] = 0;
    }
    for (int i = 0; i < _gameGrid.length; i++) {
      _gameGrid[i] = 0;
    }
    notifyListeners();
  }

  // Check if a position has adjacent empty cells to place both dice
  bool hasValidPlacement(int position) {
    if (_gameGrid[position] != 0) return false;
    
    // Check neighbors (up, down, left, right)
    final List<int> neighbors = [];
    
    // Left neighbor
    if (position % 5 != 0) {
      neighbors.add(position - 1);
    }
    
    // Right neighbor
    if (position % 5 != 4) {
      neighbors.add(position + 1);
    }
    
    // Top neighbor
    if (position >= 5) {
      neighbors.add(position - 5);
    }
    
    // Bottom neighbor
    if (position < 20) {
      neighbors.add(position + 5);
    }
    
    // Check if any neighbor is empty
    return neighbors.any((pos) => _gameGrid[pos] == 0);
  }
}