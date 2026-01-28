import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemonListUseCase {
  final PokemonRepository _repository;

  GetPokemonListUseCase(this._repository);

  Future<({List<Pokemon> items, bool hasMore})> call({
    required int limit,
    required int offset,
  }) {
    return _repository.getPokemonList(limit: limit, offset: offset);
  }
}
