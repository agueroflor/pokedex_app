import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens.dart';
import '../cubit/cubits.dart';
import '../widgets/widgets.dart';
import '../../../core/constants/spacing.dart';
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
        title: const Text('Pokédex'),
        centerTitle: true,
      ),
      body: BlocBuilder<PokedexCubit, PokedexState>(
        builder: (context, state) {
          return switch (state.status) {
            PokedexStatus.initial || PokedexStatus.loading => ResponsiveLayout(
                mobile: const _ListSkeletonView(),
                tablet: const _GridSkeletonView(crossAxisCount: 3),
                desktop: const _GridSkeletonView(crossAxisCount: 4),
              ),
            PokedexStatus.error => AppError(
                message: state.failure?.message ?? 'Ocurrió un error',
                onRetry: () => context.read<PokedexCubit>().loadInitial(),
              ),
            PokedexStatus.empty => const AppEmpty(
                message: 'No hay Pokémon disponibles',
                icon: Icons.catching_pokemon,
              ),
            PokedexStatus.success => ResponsiveLayout(
                mobile: _PokemonListView(
                  scrollController: _scrollController,
                  pokemon: state.pokemon,
                  isLoadingMore: state.isLoadingMore,
                  hasMore: state.hasMore,
                  onTap: _navigateToDetail,
                ),
                tablet: _PokemonGridView(
                  scrollController: _scrollController,
                  pokemon: state.pokemon,
                  isLoadingMore: state.isLoadingMore,
                  hasMore: state.hasMore,
                  onTap: _navigateToDetail,
                  crossAxisCount: 3,
                ),
                desktop: _PokemonGridView(
                  scrollController: _scrollController,
                  pokemon: state.pokemon,
                  isLoadingMore: state.isLoadingMore,
                  hasMore: state.hasMore,
                  onTap: _navigateToDetail,
                  crossAxisCount: 4,
                ),
              ),
          };
        },
      ),
    );
  }
}

class _ListSkeletonView extends StatelessWidget {
  const _ListSkeletonView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (_, __) => const PokemonListSkeletonItem(),
    );
  }
}

class _GridSkeletonView extends StatelessWidget {
  final int crossAxisCount;

  const _GridSkeletonView({required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    return ContentContainer(
      padding: const EdgeInsets.all(Spacing.md),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1,
          crossAxisSpacing: Spacing.md,
          mainAxisSpacing: Spacing.md,
        ),
        itemCount: crossAxisCount * 3,
        itemBuilder: (_, __) => const PokemonGridSkeletonItem(),
      ),
    );
  }
}

class _PokemonListView extends StatelessWidget {
  final ScrollController scrollController;
  final List<dynamic> pokemon;
  final bool isLoadingMore;
  final bool hasMore;
  final void Function(int) onTap;

  const _PokemonListView({
    required this.scrollController,
    required this.pokemon,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final showLoader = isLoadingMore || hasMore;
    final itemCount = showLoader ? pokemon.length + 1 : pokemon.length;

    return ListView.builder(
      controller: scrollController,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= pokemon.length) {
          return const _LoadMoreIndicator(
            child: PokemonListSkeletonItem(),
          );
        }
        final item = pokemon[index];
        return PokemonListItem(
          pokemon: item,
          onTap: () => onTap(item.id),
        );
      },
    );
  }
}

class _PokemonGridView extends StatelessWidget {
  final ScrollController scrollController;
  final List<dynamic> pokemon;
  final bool isLoadingMore;
  final bool hasMore;
  final void Function(int) onTap;
  final int crossAxisCount;

  const _PokemonGridView({
    required this.scrollController,
    required this.pokemon,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onTap,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    final showLoader = isLoadingMore || hasMore;
    final loaderCount = showLoader ? crossAxisCount : 0;
    final itemCount = pokemon.length + loaderCount;

    return ContentContainer(
      padding: const EdgeInsets.all(Spacing.md),
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1,
          crossAxisSpacing: Spacing.md,
          mainAxisSpacing: Spacing.md,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index >= pokemon.length) {
            return PokemonGridSkeletonItem(
              key: ValueKey('skeleton_$index'),
            );
          }
          final item = pokemon[index];
          return PokemonGridItem(
            key: ValueKey('pokemon_${item.id}'),
            pokemon: item,
            onTap: () => onTap(item.id),
          );
        },
      ),
    );
  }
}

class _LoadMoreIndicator extends StatelessWidget {
  final Widget child;

  const _LoadMoreIndicator({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: child,
    );
  }
}
