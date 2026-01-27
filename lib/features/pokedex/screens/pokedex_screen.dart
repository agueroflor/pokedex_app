import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/dio_client.dart';
import '../../../data/datasources/remote/pokemon_remote_datasource.dart';
import '../../../data/repositories/pokemon_repository_impl.dart';
import '../cubit/pokedex_cubit.dart';
import '../cubit/pokedex_state.dart';
import '../cubit/pokemon_detail_cubit.dart';
import '../domain/usecases/get_pokemon_detail_use_case.dart';
import '../widgets/pokemon_list_item.dart';
import 'pokemon_detail_screen.dart';

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
    final repository = PokemonRepositoryImpl(
      PokemonRemoteDatasource(DioClient.instance),
    );

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
      ),
      body: BlocBuilder<PokedexCubit, PokedexState>(
        builder: (context, state) {
          switch (state.status) {
            case PokedexStatus.initial:
            case PokedexStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case PokedexStatus.error:
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
                      onPressed: () => context.read<PokedexCubit>().loadInitial(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );

            case PokedexStatus.success:
              if (state.isEmpty) {
                return const Center(child: Text('No Pokémon found'));
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: state.hasMore
                    ? state.pokemon.length + 1
                    : state.pokemon.length,
                itemBuilder: (context, index) {
                  if (index >= state.pokemon.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final pokemon = state.pokemon[index];
                  return PokemonListItem(
                    pokemon: pokemon,
                    onTap: () => _navigateToDetail(pokemon.id),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
