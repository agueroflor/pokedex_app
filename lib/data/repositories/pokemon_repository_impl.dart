import '../../features/pokedex/domain/entities/pokemon.dart';
import '../../features/pokedex/domain/repositories/pokemon_repository.dart';
import '../datasources/remote/pokemon_remote_datasource.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDatasource _remoteDatasource;

  PokemonRepositoryImpl(this._remoteDatasource);

  @override
  Future<({List<Pokemon> items, bool hasMore})> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    final response = await _remoteDatasource.getPokemonList(
      limit: limit,
      offset: offset,
    );
    return (
      items: response.results.map((model) => model.toEntity()).toList(),
      hasMore: response.hasMore,
    );
  }
}
