import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import 'score_cell.dart';

class ScoreColumnDisplay extends StatelessWidget {
  const ScoreColumnDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < 6; i++)
          ScoreCell(scoreItemNo: i),
      ],
    );
  }
}

class ScoreRowDisplay extends StatelessWidget {
  const ScoreRowDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 6; i < 13; i++)
          ScoreCell(scoreItemNo: i),
      ],
    );
  }
}

