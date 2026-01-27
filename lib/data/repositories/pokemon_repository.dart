import '../datasources/remote/pokemon_remote_datasource.dart';
import '../models/pokemon_list_item_model.dart';

class PokemonRepository {
  final PokemonRemoteDatasource _remoteDatasource;

  PokemonRepository(this._remoteDatasource);

  Future<({List<PokemonListItemModel> items, bool hasMore})> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    final response = await _remoteDatasource.getPokemonList(
      limit: limit,
      offset: offset,
    );
    return (items: response.results, hasMore: response.hasMore);
  }
}
