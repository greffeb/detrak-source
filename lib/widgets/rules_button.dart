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
              fontSize: 25,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRuleSection(
                  theme,
                  "But du jeu",
                  "Lancez les dés et notez les symboles obtenus dans votre grille pour marquer le plus possible de points.",
                ),
                const SizedBox(height: 16),
                _buildRuleSection(
                  theme,
                  "Mise en place",
                  "Chaque joueur choisit un des six symboles possibles et le place dans la case en haut à gauche de sa grille. Veillez à ce que chaque joueur choisisse un symbole différent.",
                ),
                const SizedBox(height: 16),
                _buildRuleSection(
                  theme,
                  "Déroulement",
                  "À chaque tour, placez les deux symboles des dés sur des cases adjacentes (horizontalement ou verticalement) de votre grille.",
                ),
                const SizedBox(height: 16),
                _buildRuleSection(
                  theme,
                  "Score",
                  "• 2 symboles identiques adjacents = 2 points\n"
                  "• 3 symboles identiques adjacents = 3 points\n"
                  "• 4 symboles identiques adjacents = 8 points\n"
                  "• 5 symboles identiques adjacents = 10 points",
                ),
                const SizedBox(height: 16),
                _buildRuleSection(
                  theme,
                  "Règles avancées",
                  "• Les cases de la diagonale (grisées) comptent double\n"
                  "• Une ligne ou colonne sans points fait perdre 5 points\n\n"
                  "Note: Vous pouvez activer ou désactiver les règles avancées avec le commutateur dans la barre du haut (icône bébé pour règles simples, icône cerveau pour règles avancées).",
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

  Widget _buildRuleSection(ThemeData theme, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}