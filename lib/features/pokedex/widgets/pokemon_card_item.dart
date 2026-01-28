import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../domain/entities/pokemon.dart';
import 'pokemon_card.dart';
import 'pokemon_card_content.dart';

class PokemonCardItem extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;
  final bool isCompact;

  const PokemonCardItem({
    super.key,
    required this.pokemon,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = isCompact ? Sizes.listItemImage : null;

    return RepaintBoundary(
      child: PokemonCard(
        onTap: onTap,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: PokemonImageBox(
                      imageUrl: pokemon.imageUrl,
                      size: imageSize,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                PokemonName(
                  displayName: pokemon.displayName,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.xs),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _PokemonIdBadge(displayId: pokemon.displayId),
            ),
          ],
        ),
      ),
    );
  }
}

class _PokemonIdBadge extends StatelessWidget {
  final String displayId;

  const _PokemonIdBadge({required this.displayId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(Spacing.sm),
      ),
      child: Text(
        displayId,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }
}
