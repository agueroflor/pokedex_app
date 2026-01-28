import 'package:flutter/material.dart';
import '../../../core/constants/spacing.dart';
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

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        child: PokemonCard(
          onTap: onTap,
          child: Row(
            children: [
              PokemonImageBox(imageUrl: pokemon.imageUrl, size: 72),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PokemonName(name: pokemon.name),
                    const SizedBox(height: Spacing.xs),
                    PokemonNumber(id: pokemon.id),
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
