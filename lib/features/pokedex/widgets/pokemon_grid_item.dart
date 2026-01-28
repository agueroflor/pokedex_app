import 'package:flutter/material.dart';
import '../../../core/constants/spacing.dart';
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

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: PokemonCard(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PokemonImageBox(imageUrl: pokemon.imageUrl),
              ),
            ),
            const SizedBox(height: Spacing.md),
            PokemonName(name: pokemon.name, textAlign: TextAlign.center),
            const SizedBox(height: Spacing.xs),
            PokemonNumber(id: pokemon.id, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
