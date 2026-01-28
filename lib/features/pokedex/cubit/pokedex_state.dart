import '../domain/entities/pokemon.dart';
import '../domain/failures/pokemon_failure.dart';

enum PokedexStatus { initial, loading, success, empty, error }

class PokedexState {
  final PokedexStatus status;
  final List<Pokemon> pokemon;
  final bool hasMore;
  final bool isLoadingMore;
  final PokemonFailure? failure;
  final String searchQuery;

  const PokedexState({
    this.status = PokedexStatus.initial,
    this.pokemon = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
    this.failure,
    this.searchQuery = '',
  });

  bool get isSearching => searchQuery.isNotEmpty;

  List<Pokemon> get filteredPokemon {
    if (!isSearching) return pokemon;
    final query = searchQuery.toLowerCase();
    return pokemon.where((p) {
      return p.name.toLowerCase().contains(query) ||
          p.displayId.contains(query);
    }).toList();
  }

  PokedexState copyWith({
    PokedexStatus? status,
    List<Pokemon>? pokemon,
    bool? hasMore,
    bool? isLoadingMore,
    PokemonFailure? failure,
    String? searchQuery,
  }) {
    return PokedexState(
      status: status ?? this.status,
      pokemon: pokemon ?? this.pokemon,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: failure,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
