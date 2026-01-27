import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubits.dart';
import '../widgets/widgets.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/widgets.dart';
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
              ResponsiveLayout(
                mobile: const PokemonDetailSkeleton(),
                tablet: const ContentContainer(
                  maxWidth: 600,
                  child: PokemonDetailSkeleton(),
                ),
              ),
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
    final isLandscape = ResponsiveUtils.isLandscape(context);
    final isMobile = ResponsiveLayout.isMobile(context);

    final verticalPadding = isLandscape && isMobile ? Spacing.md : Spacing.lg;
    final imageSize = isLandscape && isMobile ? 140.0 : 200.0;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: verticalPadding,
      ),
      child: Column(
        children: [
          Hero(
            tag: 'pokemon-${pokemon.id}',
            child: Image.network(
              pokemon.imageUrl,
              height: imageSize,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => SizedBox(
                height: imageSize,
                child: const Icon(Icons.catching_pokemon, size: 80),
              ),
            ),
          ),
          SizedBox(height: isLandscape ? Spacing.sm : Spacing.md),
          Text(
            pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.scaledFontSize(context, 28),
                ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            '#${pokemon.id.toString().padLeft(3, '0')}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: ResponsiveUtils.scaledFontSize(context, 16),
                ),
          ),
          SizedBox(height: isLandscape ? Spacing.md : Spacing.lg),
          Wrap(
            spacing: Spacing.sm,
            runSpacing: Spacing.sm,
            alignment: WrapAlignment.center,
            children: pokemon.types
                .map((type) => Chip(
                      label: Text(
                        type[0].toUpperCase() + type.substring(1),
                        style: TextStyle(
                          fontSize: ResponsiveUtils.scaledFontSize(context, 14),
                        ),
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                    ))
                .toList(),
          ),
          SizedBox(height: isLandscape ? Spacing.lg : Spacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.height,
                  label: 'Altura',
                  value: '${(pokemon.height / 10).toStringAsFixed(1)} m',
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: _StatCard(
                  icon: Icons.fitness_center,
                  label: 'Peso',
                  value: '${(pokemon.weight / 10).toStringAsFixed(1)} kg',
                ),
              ),
            ],
          ),
          SizedBox(height: verticalPadding),
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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.scaledFontSize(context, 20),
                  ),
            ),
            const SizedBox(height: Spacing.xs),
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
