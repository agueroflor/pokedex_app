import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/pokemon_detail_cubit.dart';
import '../cubit/pokemon_detail_state.dart';
import '../domain/entities/pokemon_detail.dart';

class PokemonDetailScreen extends StatefulWidget {
  final int pokemonId;

  const PokemonDetailScreen({super.key, required this.pokemonId});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PokemonDetailCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Detail'),
      ),
      body: BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
        builder: (context, state) {
          switch (state.status) {
            case PokemonDetailStatus.initial:
            case PokemonDetailStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case PokemonDetailStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage ?? 'An error occurred',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<PokemonDetailCubit>().load(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );

            case PokemonDetailStatus.success:
              return _DetailContent(pokemon: state.pokemon!);
          }
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final PokemonDetail pokemon;

  const _DetailContent({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Image.network(
            pokemon.imageUrl,
            height: 200,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox(
              height: 200,
              child: Icon(Icons.catching_pokemon, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            '#${pokemon.id.toString().padLeft(3, '0')}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            children: pokemon.types.map((type) => Chip(label: Text(type))).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatCard(
                label: 'Height',
                value: '${(pokemon.height / 10).toStringAsFixed(1)} m',
              ),
              _StatCard(
                label: 'Weight',
                value: '${(pokemon.weight / 10).toStringAsFixed(1)} kg',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
