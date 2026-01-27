import '../domain/entities/pokemon_detail.dart';

enum PokemonDetailStatus { initial, loading, success, error }

class PokemonDetailState {
  final PokemonDetailStatus status;
  final PokemonDetail? pokemon;
  final String? errorMessage;

  const PokemonDetailState({
    this.status = PokemonDetailStatus.initial,
    this.pokemon,
    this.errorMessage,
  });

  PokemonDetailState copyWith({
    PokemonDetailStatus? status,
    PokemonDetail? pokemon,
    String? errorMessage,
  }) {
    return PokemonDetailState(
      status: status ?? this.status,
      pokemon: pokemon ?? this.pokemon,
      errorMessage: errorMessage,
    );
  }
}
