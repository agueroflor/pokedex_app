import '../entities/pokemon.dart';
import '../entities/pokemon_detail.dart';

abstract class PokemonRepository {
  Future<({List<Pokemon> items, bool hasMore})> getPokemonList({
    required int limit,
    required int offset,
  });

  Future<PokemonDetail> getPokemonDetail(int id);
}
