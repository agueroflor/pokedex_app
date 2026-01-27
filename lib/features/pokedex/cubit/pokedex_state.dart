import '../domain/entities/pokemon.dart';
import '../domain/failures/pokemon_failure.dart';

enum PokedexStatus { initial, loading, success, empty, error }

class PokedexState {
  final PokedexStatus status;
  final List<Pokemon> pokemon;
  final bool hasMore;
  final bool isLoadingMore;
  final PokemonFailure? failure;

  const PokedexState({
    this.status = PokedexStatus.initial,
    this.pokemon = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
    this.failure,
  });

  PokedexState copyWith({
    PokedexStatus? status,
    List<Pokemon>? pokemon,
    bool? hasMore,
    bool? isLoadingMore,
    PokemonFailure? failure,
  }) {
    return PokedexState(
      status: status ?? this.status,
      pokemon: pokemon ?? this.pokemon,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: failure,
    );
  }
}
