// lib/utils/constants.dart
import 'package:flutter/material.dart';
import '../models/symbol.dart';

// Game symbols
class GameSymbols {
  static List<GameSymbol> getSymbols(Brightness brightness) {
    final bool isDarkMode = brightness == Brightness.dark;
    
    return [
      const GameSymbol(image: AssetImage('assets/blank.png'), id: 0),
      GameSymbol(
        image: AssetImage(isDarkMode ? 'assets/rondWhite.png' : 'assets/rondBlack.png'), 
        id: 1
      ),
      GameSymbol(
        image: AssetImage(isDarkMode ? 'assets/griffeWhite.png' : 'assets/griffeBlack.png'), 
        id: 2
      ),
      GameSymbol(
        image: AssetImage(isDarkMode ? 'assets/triangleWhite.png' : 'assets/triangleBlack.png'), 
        id: 3
      ),
      GameSymbol(
        image: AssetImage(isDarkMode ? 'assets/barreWhite.png' : 'assets/barreBlack.png'), 
        id: 4
      ),
      GameSymbol(
        image: AssetImage(isDarkMode ? 'assets/croixWhite.png' : 'assets/croixBlack.png'), 
        id: 5
      ),
      GameSymbol(
        image: AssetImage(isDarkMode ? 'assets/diezeWhite.png' : 'assets/diezeBlack.png'), 
        id: 6
      ),
      const GameSymbol(image: AssetImage('assets/rondGrey.png'), id: 7),
      const GameSymbol(image: AssetImage('assets/griffeGrey.png'), id: 8),
      const GameSymbol(image: AssetImage('assets/triangleGrey.png'), id: 9),
      const GameSymbol(image: AssetImage('assets/barreGrey.png'), id: 10),
      const GameSymbol(image: AssetImage('assets/croixGrey.png'), id: 11),
      const GameSymbol(image: AssetImage('assets/diezeGrey.png'), id: 12),
    ];
  }
  
  // Keeping this for backward compatibility with existing code
  static const List<GameSymbol> symbols = [
    GameSymbol(image: AssetImage('assets/blank.png'), id: 0),
    GameSymbol(image: AssetImage('assets/rondBlack.png'), id: 1),
    GameSymbol(image: AssetImage('assets/griffeBlack.png'), id: 2),
    GameSymbol(image: AssetImage('assets/triangleBlack.png'), id: 3),
    GameSymbol(image: AssetImage('assets/barreBlack.png'), id: 4),
    GameSymbol(image: AssetImage('assets/croixBlack.png'), id: 5),
    GameSymbol(image: AssetImage('assets/diezeBlack.png'), id: 6),
    GameSymbol(image: AssetImage('assets/rondGrey.png'), id: 7),
    GameSymbol(image: AssetImage('assets/griffeGrey.png'), id: 8),
    GameSymbol(image: AssetImage('assets/triangleGrey.png'), id: 9),
    GameSymbol(image: AssetImage('assets/barreGrey.png'), id: 10),
    GameSymbol(image: AssetImage('assets/croixGrey.png'), id: 11),
    GameSymbol(image: AssetImage('assets/diezeGrey.png'), id: 12),
  ];
}