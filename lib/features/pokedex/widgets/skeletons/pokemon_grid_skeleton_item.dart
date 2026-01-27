import 'package:flutter/material.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/widgets/widgets.dart';

class PokemonGridSkeletonItem extends StatelessWidget {
  const PokemonGridSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          children: [
            const Expanded(
              flex: 3,
              child: AppSkeleton(
                width: double.infinity,
                height: double.infinity,
                borderRadius: 8,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            const AppSkeleton(width: 80, height: 14),
            const SizedBox(height: Spacing.xs),
            const AppSkeleton(width: 40, height: 10),
          ],
        ),
      ),
    );
  }
}
