import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/pokedex_cubit.dart';
import '../cubit/pokedex_state.dart';
import '../widgets/pokemon_list_item.dart';

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
                  return PokemonListItem(pokemon: state.pokemon[index]);
                },
              );
          }
        },
      ),
    );
  }
}
