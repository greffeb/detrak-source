import 'package:flutter/material.dart';

class RulesButton extends StatelessWidget {
  const RulesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showRulesDialog(context),
      child: Icon(
        Icons.help_outline,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _showRulesDialog(BuildContext context) async {
    final theme = Theme.of(context);

    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "Règles du jeu",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 22,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRuleIcon(
                  theme,
                  Icons.flag,
                  "But du jeu: Marquer un maximum de points en plaçant des symboles dans la grille.",
                ),
                const Divider(),
                _buildRuleIcon(
                  theme,
                  Icons.grid_on,
                  "Départ: Chaque joueur choisit un symbole différent et le place en haut à gauche.",
                ),
                const Divider(),
                _buildRuleIcon(
                  theme,
                  Icons.casino,
                  "À chaque tour, placez les deux symboles des dés sur des cases adjacentes.",
                ),
                const Divider(),
                _buildRuleIcon(
                  theme,
                  Icons.calculate,
                  "Scores: symboles identiques adjacents rapportent des points: 2 = 2pts, 3 = 3pts, 4 = 8pts, 5 = 10pts",
                ),
                const Divider(),
                _buildRuleIcon(
                  theme,
                  Icons.psychology,
                  "Mode avancé: Cases diagonales = score double, Ligne/colonne sans points = -5pts",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                "Fermer",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        );
      },
    );
  }

  Widget _buildRuleIcon(ThemeData theme, IconData icon, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              content,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}