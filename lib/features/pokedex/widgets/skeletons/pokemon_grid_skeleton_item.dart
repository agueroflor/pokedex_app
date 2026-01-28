import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'pokemon_card_skeleton.dart';

class PokemonGridSkeletonItem extends StatelessWidget {
  const PokemonGridSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return PokemonCardSkeleton(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Center(
                  child: AppSkeleton(
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: CardStyles.imageRadius,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              const AppSkeleton(width: 80, height: 18, borderRadius: 4),
              const SizedBox(height: Spacing.xs),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: AppSkeleton(
              width: 45,
              height: 22,
              borderRadius: Spacing.sm,
            ),
          ),
        ],
      ),
    );
  }
}
