import 'package:flutter/material.dart';
import '../models/symbol.dart';
import '../models/symbol_data.dart';
import '../utils/constants.dart';

class DraggableSymbol extends StatelessWidget {
  final GameSymbol symbol;

  const DraggableSymbol({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final themeAwareSymbols = GameSymbols.getSymbols(brightness);
    
    return Expanded(
      child: FittedBox(
        child: Draggable<SymbolData>(
          dragAnchorStrategy: (draggable, context, position) {
            return Offset(draggable.feedbackOffset.dx + 70, draggable.feedbackOffset.dy + 85);
          },
          // Use -1 for sourcePosition to indicate it's from the symbol panel
          data: SymbolData(symbolId: symbol.id, sourcePosition: -1),
          feedback: Center(
            child: Transform.scale(
              scale: 0.5,
              alignment: Alignment.center,
              child: Image(image: symbol.image),
            ),
          ),
          childWhenDragging: Center(
            child: Image(
              // Use theme-aware symbols for the grey versions
              image: themeAwareSymbols[symbol.id + 6].image,
            ),
          ),
          child: Center(
            child: Image(image: symbol.image),
          ),
        ),
      ),
    );
  }
}