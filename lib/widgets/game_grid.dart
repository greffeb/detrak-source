import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import 'drop_target_cell.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int row = 0; row < 5; row++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int col = 0; col < 5; col++)
                DropTargetCell(position: row * 5 + col),
            ],
          ),
      ],
    );
  }
}
