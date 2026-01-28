import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'pokemon_card_skeleton.dart';

class PokemonDetailSkeleton extends StatelessWidget {
  const PokemonDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        children: [
          AppSkeleton(
            width: Sizes.detailImage,
            height: Sizes.detailImage,
            borderRadius: CardStyles.borderRadius,
          ),
          const SizedBox(height: Spacing.lg),
          const AppSkeleton(width: 160, height: 28, borderRadius: 6),
          const SizedBox(height: Spacing.sm),
          const AppSkeleton(width: 80, height: 20, borderRadius: 4),
          const SizedBox(height: Spacing.xl),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSkeleton(width: 70, height: 32, borderRadius: 16),
              SizedBox(width: Spacing.sm),
              AppSkeleton(width: 70, height: 32, borderRadius: 16),
            ],
          ),
          const SizedBox(height: Spacing.xl),
          const Row(
            children: [
              Expanded(child: _StatCardSkeleton()),
              SizedBox(width: Spacing.md),
              Expanded(child: _StatCardSkeleton()),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCardSkeleton extends StatelessWidget {
  const _StatCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const PokemonCardSkeleton(
      child: Column(
        children: [
          AppSkeleton(width: 28, height: 28, borderRadius: 6),
          SizedBox(height: Spacing.sm),
          AppSkeleton(width: 60, height: 20, borderRadius: 4),
          SizedBox(height: Spacing.xs),
          AppSkeleton(width: 40, height: 14, borderRadius: 4),
        ],
      ),
    );
  }
}
