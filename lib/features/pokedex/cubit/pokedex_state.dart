import '../domain/entities/pokemon.dart';

enum PokedexStatus { initial, loading, success, error }

class PokedexState {
  final PokedexStatus status;
  final List<Pokemon> pokemon;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const PokedexState({
    this.status = PokedexStatus.initial,
    this.pokemon = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get isEmpty => status == PokedexStatus.success && pokemon.isEmpty;

  PokedexState copyWith({
    PokedexStatus? status,
    List<Pokemon>? pokemon,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return PokedexState(
      status: status ?? this.status,
      pokemon: pokemon ?? this.pokemon,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }
}
