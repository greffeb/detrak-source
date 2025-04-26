// lib/utils/constants.dart
import 'package:flutter/material.dart';
import '../models/symbol.dart';

// Game symbols
class GameSymbols {
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
