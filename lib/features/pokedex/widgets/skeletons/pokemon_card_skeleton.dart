import 'package:flutter/material.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/card_styles.dart';

class PokemonCardSkeleton extends StatelessWidget {
  final Widget child;

  const PokemonCardSkeleton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: CardStyles.cardDecoration(context),
      child: child,
    );
  }
}
