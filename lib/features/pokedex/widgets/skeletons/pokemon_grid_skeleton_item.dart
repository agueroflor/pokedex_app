import 'package:flutter/material.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/card_styles.dart';
import '../../../../core/widgets/widgets.dart';
import 'pokemon_card_skeleton.dart';

class PokemonGridSkeletonItem extends StatelessWidget {
  const PokemonGridSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return PokemonCardSkeleton(
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: AppSkeleton(
                width: double.infinity,
                height: double.infinity,
                borderRadius: CardStyles.imageRadius,
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          const AppSkeleton(width: 80, height: 18, borderRadius: 4),
          const SizedBox(height: Spacing.xs),
          const AppSkeleton(width: 50, height: 22, borderRadius: 4),
        ],
      ),
    );
  }
}
