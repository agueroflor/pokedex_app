import 'package:flutter/material.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/theme/card_styles.dart';

class PokemonCard extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const PokemonCard({
    super.key,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: CardStyles.cardBorderRadius,
        child: Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: CardStyles.cardDecoration(context),
          child: child,
        ),
      ),
    );
  }
}
