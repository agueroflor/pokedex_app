import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens.dart';
import '../cubit/cubits.dart';
import '../widgets/widgets.dart';
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
    if (_isBottom) {
      context.read<PokedexCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
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
            PokedexStatus.initial || PokedexStatus.loading => const AppLoader(),
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
                  hasMore: state.hasMore,
                  onTap: _navigateToDetail,
                ),
                tablet: _PokemonGridView(
                  scrollController: _scrollController,
                  pokemon: state.pokemon,
                  hasMore: state.hasMore,
                  onTap: _navigateToDetail,
                  crossAxisCount: 3,
                ),
                desktop: _PokemonGridView(
                  scrollController: _scrollController,
                  pokemon: state.pokemon,
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

class _PokemonListView extends StatelessWidget {
  final ScrollController scrollController;
  final List<dynamic> pokemon;
  final bool hasMore;
  final void Function(int) onTap;

  const _PokemonListView({
    required this.scrollController,
    required this.pokemon,
    required this.hasMore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: hasMore ? pokemon.length + 1 : pokemon.length,
      itemBuilder: (context, index) {
        if (index >= pokemon.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: AppLoader(),
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
  final bool hasMore;
  final void Function(int) onTap;
  final int crossAxisCount;

  const _PokemonGridView({
    required this.scrollController,
    required this.pokemon,
    required this.hasMore,
    required this.onTap,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = hasMore ? pokemon.length + 1 : pokemon.length;

    return ContentContainer(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index >= pokemon.length) {
            return const Card(
              child: AppLoader(),
            );
          }
          final item = pokemon[index];
          return PokemonGridItem(
            pokemon: item,
            onTap: () => onTap(item.id),
          );
        },
      ),
    );
  }
}
