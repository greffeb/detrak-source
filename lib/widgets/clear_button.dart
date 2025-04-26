import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openAlertBox(context),
      child: Icon(
        Icons.delete,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _openAlertBox(BuildContext context) async {
    final theme = Theme.of(context);
    final gameState = Provider.of<GameState>(context, listen: false);

    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          contentPadding: const EdgeInsets.all(10.0),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tout Effacer ?",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 25,
                  color: theme.colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset("assets/nils.gif"),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  gameState.clearGrid();
                },
                child: Text(
                  "Oui",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 25,
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}