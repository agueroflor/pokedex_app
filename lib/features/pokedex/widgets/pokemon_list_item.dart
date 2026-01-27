import 'package:flutter/material.dart';
import '../domain/entities/pokemon.dart';

class PokemonListItem extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonListItem({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        pokemon.imageUrl,
        width: 56,
        height: 56,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const SizedBox(
          width: 56,
          height: 56,
          child: Icon(Icons.catching_pokemon),
        ),
      ),
      title: Text(
        pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text('#${pokemon.id.toString().padLeft(3, '0')}'),
    );
  }
}
