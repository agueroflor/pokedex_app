import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens.dart';
import '../cubit/cubits.dart';
import '../domain/entities/pokemon.dart';
import '../widgets/widgets.dart';
import '../../../core/constants/constants.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/repositories/pokemon_repository.dart';
import '../domain/usecases/get_pokemon_detail_use_case.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  int _lastPrecachedCount = 0;

  static const _precacheAhead = 10;

  @override
  void initState() {
    super.initState();
    context.read<PokedexCubit>().loadInitial();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isNearBottom) {
      context.read<PokedexCubit>().loadMore();
    }
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 300);
  }

  void _precacheImages(List<Pokemon> pokemon) {
    if (pokemon.length <= _lastPrecachedCount) return;

    final newItems = pokemon.skip(_lastPrecachedCount).take(_precacheAhead);
    _lastPrecachedCount = pokemon.length;
    

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final item in newItems) {
        precacheImage(
          CachedNetworkImageProvider(item.imageUrl),
          context,
        );
      }
    });
  }

  void _onSearchChanged(String query) {
    context.read<PokedexCubit>().search(query);
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<PokedexCubit>().clearSearch();
  }

  void _navigateToDetail(int pokemonId) {
    final repository = context.read<PokemonRepository>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => PokemonDetailCubit(
            getPokemonDetail: GetPokemonDetailUseCase(repository),
            pokemonId: pokemonId,
          ),
          child: PokemonDetailScreen(pokemonId: pokemonId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
        centerTitle: true,
      ),
      body: BlocConsumer<PokedexCubit, PokedexState>(
        listener: (context, state) {
          if (state.status == PokedexStatus.success) {
            _precacheImages(state.pokemon);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              if (state.status == PokedexStatus.success ||
                  state.status == PokedexStatus.empty)
                _SearchBar(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onClear: _clearSearch,
                  isSearching: state.isSearching,
                ),
              Expanded(
                child: _buildContent(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(PokedexState state) {
    return switch (state.status) {
      PokedexStatus.initial || PokedexStatus.loading => ResponsiveLayout(
          mobile: const _GridSkeletonView(crossAxisCount: 2),
          tablet: const _GridSkeletonView(crossAxisCount: 3),
          desktop: const _GridSkeletonView(crossAxisCount: 4),
        ),
      PokedexStatus.error => AppError(
          message: state.failure?.message ?? 'Ocurrio un error',
          onRetry: () => context.read<PokedexCubit>().loadInitial(),
        ),
      PokedexStatus.empty => const AppEmpty(
          message: 'No hay Pokemon disponibles',
          icon: Icons.catching_pokemon,
        ),
      PokedexStatus.success => _buildSuccessContent(state),
    };
  }

  Widget _buildSuccessContent(PokedexState state) {
    final pokemon = state.filteredPokemon;

    if (pokemon.isEmpty && state.isSearching) {
      return const AppEmpty(
        message: 'No se encontraron Pokemon',
        icon: Icons.search_off,
      );
    }

    return ResponsiveLayout(
      mobile: _PokemonGridView(
        scrollController: _scrollController,
        pokemon: pokemon,
        isLoadingMore: state.isLoadingMore,
        hasMore: state.hasMore,
        isSearching: state.isSearching,
        onTap: _navigateToDetail,
        crossAxisCount: 2,
        spacing: Spacing.sm,
      ),
      tablet: _PokemonGridView(
        scrollController: _scrollController,
        pokemon: pokemon,
        isLoadingMore: state.isLoadingMore,
        hasMore: state.hasMore,
        isSearching: state.isSearching,
        onTap: _navigateToDetail,
        crossAxisCount: 3,
        spacing: Spacing.md,
      ),
      desktop: _PokemonGridView(
        scrollController: _scrollController,
        pokemon: pokemon,
        isLoadingMore: state.isLoadingMore,
        hasMore: state.hasMore,
        isSearching: state.isSearching,
        onTap: _navigateToDetail,
        crossAxisCount: 4,
        spacing: Spacing.lg,
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool isSearching;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.isSearching,
  });

  static const _padding = EdgeInsets.symmetric(
    horizontal: Spacing.md,
    vertical: Spacing.sm,
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: _padding,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search Pokemon',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Spacing.md),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
        ),
      ),
    );
  }
}

class _GridSkeletonView extends StatelessWidget {
  final int crossAxisCount;

  const _GridSkeletonView({required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final spacing = crossAxisCount == 2 ? Spacing.sm : Spacing.md;

    return ContentContainer(
      padding: EdgeInsets.all(spacing),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.85,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: crossAxisCount * 3,
        itemBuilder: (_, __) => const PokemonGridSkeletonItem(),
      ),
    );
  }
}

class _PokemonGridView extends StatelessWidget {
  final ScrollController scrollController;
  final List<Pokemon> pokemon;
  final bool isLoadingMore;
  final bool hasMore;
  final bool isSearching;
  final void Function(int) onTap;
  final int crossAxisCount;
  final double spacing;

  const _PokemonGridView({
    required this.scrollController,
    required this.pokemon,
    required this.isLoadingMore,
    required this.hasMore,
    required this.isSearching,
    required this.onTap,
    required this.crossAxisCount,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final showLoader = !isSearching && (isLoadingMore || hasMore);
    final loaderCount = showLoader ? crossAxisCount : 0;
    final itemCount = pokemon.length + loaderCount;

    return ContentContainer(
      padding: EdgeInsets.all(spacing),
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.85,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index >= pokemon.length) {
            return PokemonGridSkeletonItem(
              key: ValueKey('skeleton_$index'),
            );
          }
          final item = pokemon[index];
          return PokemonCardItem(
            key: ValueKey('pokemon_${item.id}'),
            pokemon: item,
            onTap: () => onTap(item.id),
          );
        },
      ),
    );
  }
}
