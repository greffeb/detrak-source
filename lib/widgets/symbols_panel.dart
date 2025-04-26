import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'draggable_symbol.dart';

class SymbolsPanel extends StatelessWidget {
  const SymbolsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenAspectRatio = screenSize.width / screenSize.height;
    final brightness = Theme.of(context).brightness;
    
    final symbolSize = screenAspectRatio < 0.657
        ? (screenSize.width - 20) / 6
        : (0.657 * screenSize.height - 20) / 6;
        
    // Get theme-aware symbols
    final themeAwareSymbols = GameSymbols.getSymbols(brightness);

    return SizedBox(
      height: symbolSize,
      child: Card(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 1; i < 7; i++)
              DraggableSymbol(symbol: themeAwareSymbols[i]),
          ],
        ),
      ),
    );
  }
}