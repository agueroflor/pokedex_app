import '../entities/pokemon.dart';

abstract class PokemonRepository {
  Future<({List<Pokemon> items, bool hasMore})> getPokemonList({
    required int limit,
    required int offset,
  });
}
