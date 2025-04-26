import 'package:flutter/material.dart';
import '../models/symbol.dart';
import '../utils/constants.dart';

class DraggableSymbol extends StatelessWidget {
  final GameSymbol symbol;

  const DraggableSymbol({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        child: Draggable<int>(
          dragAnchorStrategy: (draggable, context, position) {
            return Offset(draggable.feedbackOffset.dx + 70, draggable.feedbackOffset.dy + 85);
          },
          data: symbol.id,
          feedback: Center(
            child: Transform.scale(
              scale: 0.5,
              alignment: Alignment.center,
              child: Image(image: symbol.image),
            ),
          ),
          childWhenDragging: Center(
            child: Image(
              image: GameSymbols.symbols[symbol.id + 6].image,
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
