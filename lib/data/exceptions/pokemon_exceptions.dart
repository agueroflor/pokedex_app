import '../../features/pokedex/domain/failures/pokemon_failure.dart';

class PokemonException implements Exception {
  final PokemonFailure failure;

  const PokemonException(this.failure);
}
