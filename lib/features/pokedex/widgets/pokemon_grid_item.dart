import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../domain/entities/pokemon.dart';
import 'pokemon_card.dart';
import 'pokemon_card_content.dart';

class PokemonGridItem extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const PokemonGridItem({
    super.key,
    required this.pokemon,
    this.onTap,
  });

  static const _aspectRatio = 1.0;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: PokemonCard(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: _aspectRatio,
                child: PokemonImageBox(imageUrl: pokemon.imageUrl),
              ),
            ),
            const SizedBox(height: Spacing.md),
            PokemonName(
              displayName: pokemon.displayName,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xs),
            PokemonNumber(
              displayId: pokemon.displayId,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
