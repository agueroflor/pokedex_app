import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'pokemon_card_skeleton.dart';

class PokemonListSkeletonItem extends StatelessWidget {
  const PokemonListSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      child: PokemonCardSkeleton(
        child: Row(
          children: [
            AppSkeleton(
              width: Sizes.listItemImage,
              height: Sizes.listItemImage,
              borderRadius: CardStyles.imageRadius,
            ),
            const SizedBox(width: Spacing.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSkeleton(width: 100, height: 18, borderRadius: 4),
                  SizedBox(height: Spacing.xs),
                  AppSkeleton(width: 50, height: 22, borderRadius: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
