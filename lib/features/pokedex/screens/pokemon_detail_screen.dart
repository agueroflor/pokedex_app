import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/widgets.dart';
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
        title: const Text('Detalle'),
        centerTitle: true,
      ),
      body: BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
        builder: (context, state) {
          return switch (state.status) {
            PokemonDetailStatus.initial ||
            PokemonDetailStatus.loading =>
              const AppLoader(),
            PokemonDetailStatus.error => AppError(
                message: state.failure?.message ?? 'Ocurrió un error',
                onRetry: () => context.read<PokemonDetailCubit>().load(),
              ),
            PokemonDetailStatus.success => ResponsiveLayout(
                mobile: _DetailContent(pokemon: state.pokemon!),
                tablet: ContentContainer(
                  maxWidth: 600,
                  child: _DetailContent(pokemon: state.pokemon!),
                ),
              ),
          };
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
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Hero(
            tag: 'pokemon-${pokemon.id}',
            child: Image.network(
              pokemon.imageUrl,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 200,
                child: Icon(Icons.catching_pokemon, size: 100),
              ),
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
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pokemon.types
                .map((type) => Chip(
                      label: Text(type),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                    ))
                .toList(),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatCard(
                icon: Icons.height,
                label: 'Altura',
                value: '${(pokemon.height / 10).toStringAsFixed(1)} m',
              ),
              _StatCard(
                icon: Icons.fitness_center,
                label: 'Peso',
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
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
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
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
