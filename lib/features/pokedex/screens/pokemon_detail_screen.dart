import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/widgets.dart';
import '../cubit/cubits.dart';
import '../domain/entities/pokemon_detail.dart';
import '../widgets/widgets.dart';

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

  static const _imageSizeLandscape = 140.0;
  static const _imageSizePortrait = 200.0;
  static const _iconSize = 80.0;
  static const _cacheSize = 200;

  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveUtils.isLandscape(context);
    final isMobile = ResponsiveLayout.isMobile(context);
    final isCompact = isLandscape && isMobile;

    final verticalPadding = isCompact ? Spacing.md : Spacing.lg;
    final imageSize = isCompact ? _imageSizeLandscape : _imageSizePortrait;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: verticalPadding,
      ),
      child: Column(
        children: [
          Hero(
            tag: 'pokemon-${pokemon.id}',
            child: CachedNetworkImage(
              imageUrl: pokemon.imageUrl,
              height: imageSize,
              fit: BoxFit.contain,
              memCacheWidth: _cacheSize,
              memCacheHeight: _cacheSize,
              errorWidget: (_, __, ___) => SizedBox(
                height: imageSize,
                child: const Icon(Icons.catching_pokemon, size: _iconSize),
              ),
            ),
          ),
          SizedBox(height: isLandscape ? Spacing.sm : Spacing.md),
          Text(
            pokemon.displayName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.scaledFontSize(context, 28),
                ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            pokemon.displayId,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: ResponsiveUtils.scaledFontSize(context, 16),
                ),
          ),
          SizedBox(height: isCompact ? Spacing.md : Spacing.lg),
          _TypeChips(types: pokemon.displayTypes, isCompact: isCompact),
          SizedBox(height: isCompact ? Spacing.lg : Spacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.height,
                  label: 'Altura',
                  value: pokemon.displayHeight,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: _StatCard(
                  icon: Icons.fitness_center,
                  label: 'Peso',
                  value: pokemon.displayWeight,
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

class _TypeChips extends StatelessWidget {
  final List<String> types;
  final bool isCompact;

  const _TypeChips({required this.types, required this.isCompact});

  static const _chipPadding = EdgeInsets.symmetric(horizontal: Spacing.sm);

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveUtils.scaledFontSize(context, 14);
    final backgroundColor = Theme.of(context).colorScheme.secondaryContainer;

    return Wrap(
      spacing: Spacing.sm,
      runSpacing: Spacing.sm,
      alignment: WrapAlignment.center,
      children: types
          .map((type) => Chip(
                label: Text(type, style: TextStyle(fontSize: fontSize)),
                backgroundColor: backgroundColor,
                padding: _chipPadding,
              ))
          .toList(),
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

  static const _padding = EdgeInsets.symmetric(
    horizontal: Spacing.lg,
    vertical: Spacing.md,
  );
  static const _iconSize = 28.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: _padding,
        child: Column(
          children: [
            Icon(icon, color: colorScheme.primary, size: _iconSize),
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
                    color: colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
