import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../domain/entities/pokemon.dart';
import 'pokemon_card.dart';
import 'pokemon_card_content.dart';

class PokemonListItem extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const PokemonListItem({
    super.key,
    required this.pokemon,
    this.onTap,
  });

  static const _padding = EdgeInsets.symmetric(
    horizontal: Spacing.md,
    vertical: Spacing.sm,
  );

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: _padding,
        child: PokemonCard(
          onTap: onTap,
          child: Row(
            children: [
              PokemonImageBox(
                imageUrl: pokemon.imageUrl,
                size: Sizes.listItemImage,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PokemonName(displayName: pokemon.displayName),
                    const SizedBox(height: Spacing.xs),
                    PokemonNumber(displayId: pokemon.displayId),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
