import '../domain/entities/pokemon_detail.dart';
import '../domain/failures/pokemon_failure.dart';

enum PokemonDetailStatus { initial, loading, success, error }

class PokemonDetailState {
  final PokemonDetailStatus status;
  final PokemonDetail? pokemon;
  final PokemonFailure? failure;

  const PokemonDetailState({
    this.status = PokemonDetailStatus.initial,
    this.pokemon,
    this.failure,
  });

  PokemonDetailState copyWith({
    PokemonDetailStatus? status,
    PokemonDetail? pokemon,
    PokemonFailure? failure,
  }) {
    return PokemonDetailState(
      status: status ?? this.status,
      pokemon: pokemon ?? this.pokemon,
      failure: failure,
    );
  }
}
