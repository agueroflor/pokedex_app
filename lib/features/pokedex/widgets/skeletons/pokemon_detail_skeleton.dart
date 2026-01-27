import 'package:flutter/material.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/widgets/widgets.dart';

class PokemonDetailSkeleton extends StatelessWidget {
  const PokemonDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        children: [
          const AppSkeleton(width: 200, height: 200, borderRadius: 16),
          const SizedBox(height: Spacing.lg),
          const AppSkeleton(width: 160, height: 28),
          const SizedBox(height: Spacing.sm),
          const AppSkeleton(width: 80, height: 20),
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
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
        child: const Column(
          children: [
            AppSkeleton(width: 28, height: 28),
            SizedBox(height: Spacing.sm),
            AppSkeleton(width: 60, height: 20),
            SizedBox(height: Spacing.xs),
            AppSkeleton(width: 40, height: 14),
          ],
        ),
      ),
    );
  }
}
