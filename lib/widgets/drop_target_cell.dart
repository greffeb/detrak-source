import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../models/symbol_data.dart';
import '../utils/constants.dart';

class DropTargetCell extends StatelessWidget {
  final int position;

  const DropTargetCell({
    super.key,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final screenSize = MediaQuery.of(context).size;
    final screenAspectRatio = screenSize.width / screenSize.height;
    final brightness = Theme.of(context).brightness;
    
    // Get theme-aware symbols
    final themeAwareSymbols = GameSymbols.getSymbols(brightness);
    
    final gridSize = screenAspectRatio < 0.657
        ? (screenSize.width - 20) / 7
        : (0.657 * screenSize.height - 20) / 7;

    final isDarkMode = brightness == Brightness.dark;
    final darkerBackground = isDarkMode
        ? Color.alphaBlend(Colors.white.withAlpha(0x11), Theme.of(context).colorScheme.surface)
        : Color.alphaBlend(Colors.black.withAlpha(0x11), Theme.of(context).colorScheme.surface);

    // Check if this is a diagonal cell
    final isDiagonalCell = (position == 4 || position == 8 || position == 12 || position == 16 || position == 20);
    
    // Determine cell background color
    Color cellBackgroundColor;
    
    // Always make the top-left cell (position 0) grey
    if (position == 0) {
      cellBackgroundColor = darkerBackground;
    } 
    // Only apply grey background to diagonal cells when advanced rules are enabled
    else if (isDiagonalCell && gameState.advancedRulesEnabled) {
      cellBackgroundColor = darkerBackground;
    } 
    // All other cells use default background
    else {
      cellBackgroundColor = Theme.of(context).colorScheme.surface;
    }

    // If the cell is empty, just show a DragTarget
    if (gameState.gameGrid[position] == 0) {
      return DragTarget<SymbolData>(
        builder: (context, accepted, rejected) {
          return SizedBox(
            height: gridSize,
            width: gridSize,
            child: Card(
              margin: const EdgeInsets.all(2.0),
              color: cellBackgroundColor,
              child: const FittedBox(
                child: Center(
                  child: Image(
                    image: AssetImage('assets/blank.png'),
                  ),
                ),
              ),
            ),
          );
        },
        onWillAccept: (data) => true,
        onAccept: (SymbolData data) {
          // Add haptic feedback when dropping
          HapticFeedback.lightImpact();
          
          if (data.sourcePosition == position) return; // No change if same position
          
          // If it's a symbol from another cell on the grid, move it
          if (data.sourcePosition >= 0 && data.sourcePosition < 25) {
            gameState.moveSymbol(data.sourcePosition, position);
          } else {
            // It's a new symbol from the panel
            gameState.updateScore(position, data.symbolId);
          }
        },
      );
    }
    
    // If the cell has a symbol, make it draggable on long press and add double tap to remove
    return GestureDetector(
      onDoubleTap: () {
        // Add haptic feedback when removing a symbol
        HapticFeedback.mediumImpact();
        
        // Clear the cell by setting its value to 0
        gameState.updateScore(position, 0);
      },
      child: LongPressDraggable<SymbolData>(
        data: SymbolData(
          symbolId: gameState.gameGrid[position],
          sourcePosition: position,
        ),
        delay: const Duration(milliseconds: 250),
        dragAnchorStrategy: (draggable, context, position) {
          return Offset(draggable.feedbackOffset.dx + 70, draggable.feedbackOffset.dy + 85);
        },
        feedback: Center(
          child: Transform.scale(
            scale: 0.5,
            alignment: Alignment.center,
            child: Image(
              // Use theme-aware symbols for the dragged feedback
              image: themeAwareSymbols[gameState.gameGrid[position]].image,
            ),
          ),
        ),
        // Show grey icon at the original location during drag
        childWhenDragging: SizedBox(
          height: gridSize,
          width: gridSize,
          child: Card(
            margin: const EdgeInsets.all(2.0),
            color: cellBackgroundColor,
            child: FittedBox(
              child: Center(
                child: Image(
                  // Show grey version (ID + 6) of the same symbol
                  image: themeAwareSymbols[gameState.gameGrid[position] + 6].image,
                ),
              ),
            ),
          ),
        ),
        onDragCompleted: () {
          // This is called when the drag is completed and accepted by a DragTarget
          // The target cell will handle updating the game state
        },
        onDraggableCanceled: (velocity, offset) {
          // Check if the drag was released outside of the game grid
          final gridRect = _calculateGridRect(context);
          if (!gridRect.contains(offset)) {
            // Add haptic feedback when dropping outside
            HapticFeedback.mediumImpact();
            
            // Delete the symbol if dropped outside the grid
            gameState.updateScore(position, 0);
          }
        },
        child: DragTarget<SymbolData>(
          builder: (context, accepted, rejected) {
            return SizedBox(
              height: gridSize,
              width: gridSize,
              child: Card(
                margin: const EdgeInsets.all(2.0),
                color: cellBackgroundColor,
                child: FittedBox(
                  child: Center(
                    child: Image(
                      // Use theme-aware symbols for the main display
                      image: themeAwareSymbols[gameState.gameGrid[position]].image,
                    ),
                  ),
                ),
              ),
            );
          },
          onWillAccept: (data) => true,
          onAccept: (SymbolData data) {
            // Add haptic feedback when accepting a dropped item
            HapticFeedback.lightImpact();
            
            // If being dropped on itself, do nothing
            if (data.sourcePosition == position) return;
            
            // If it's from another cell, move it here (replacing what's here)
            if (data.sourcePosition >= 0 && data.sourcePosition < 25) {
              // Clear the source cell
              final int currentSymbol = gameState.gameGrid[position];
              gameState.updateScore(position, data.symbolId);
              gameState.updateScore(data.sourcePosition, 0);
            } else {
              // It's a new symbol from the panel
              gameState.updateScore(position, data.symbolId);
            }
          },
        ),
      ),
    );
  }
  
  // Helper method to calculate the approximate game grid boundaries
  Rect _calculateGridRect(BuildContext context) {
    // Get screen size for calculations
    final screenSize = MediaQuery.of(context).size;
    
    // Create a generous rectangle that represents the game grid area
    return Rect.fromLTWH(
      screenSize.width * 0.125,  // 12.5% from left
      screenSize.height * 0.125, // 12.5% from top
      screenSize.width * 0.75,   // 75% of screen width
      screenSize.height * 0.5    // 50% of screen height (grid is usually in top half)
    );
  }
}