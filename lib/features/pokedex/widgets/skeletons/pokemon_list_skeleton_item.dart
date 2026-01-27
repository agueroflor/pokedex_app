import 'package:flutter/material.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/widgets/widgets.dart';

class PokemonListSkeletonItem extends StatelessWidget {
  const PokemonListSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm + Spacing.xs,
      ),
      child: Row(
        children: [
          AppSkeleton(width: 56, height: 56, borderRadius: 28),
          SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton(width: 120, height: 16),
                SizedBox(height: Spacing.sm),
                AppSkeleton(width: 60, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
