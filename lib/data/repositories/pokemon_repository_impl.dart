import 'package:dio/dio.dart';
import '../../features/pokedex/domain/entities/pokemon.dart';
import '../../features/pokedex/domain/entities/pokemon_detail.dart';
import '../../features/pokedex/domain/failures/pokemon_failure.dart';
import '../../features/pokedex/domain/repositories/pokemon_repository.dart';
import '../datasources/local/pokemon_local_datasource.dart';
import '../datasources/remote/pokemon_remote_datasource.dart';
import '../exceptions/pokemon_exceptions.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDatasource _remoteDatasource;
  final PokemonLocalDatasource _localDatasource;

  PokemonRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<({List<Pokemon> items, bool hasMore})> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    final cachedModels = await _localDatasource.getPokemonList();

    try {
      final response = await _remoteDatasource.getPokemonList(
        limit: limit,
        offset: offset,
      );

      List<Pokemon> allItems;
      if (offset == 0) {
        await _localDatasource.savePokemonList(response.results);
        allItems = response.results.map((m) => m.toEntity()).toList();
      } else {
        final existingModels = cachedModels.take(offset).toList();
        final allModels = [...existingModels, ...response.results];
        await _localDatasource.savePokemonList(allModels);
        allItems = response.results.map((m) => m.toEntity()).toList();
      }

      return (items: allItems, hasMore: response.hasMore);
    } catch (e) {
      if (cachedModels.isEmpty) {
        throw PokemonException(_mapToFailure(e));
      }

      if (offset >= cachedModels.length) {
        return (items: <Pokemon>[], hasMore: false);
      }

      final pageItems = cachedModels.skip(offset).take(limit).toList();
      final hasMore = offset + pageItems.length < cachedModels.length;

      return (
        items: pageItems.map((m) => m.toEntity()).toList(),
        hasMore: hasMore,
      );
    }
  }

  @override
  Future<PokemonDetail> getPokemonDetail(int id) async {
    final cached = await _localDatasource.getPokemonDetail(id);

    try {
      final model = await _remoteDatasource.getPokemonDetail(id);
      await _localDatasource.savePokemonDetail(model);
      return model.toEntity();
    } catch (e) {
      if (cached != null) {
        return cached.toEntity();
      }
      throw PokemonException(_mapToFailure(e));
    }
  }

  PokemonFailure _mapToFailure(Object error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return const NetworkFailure();
      }
    }
    return const UnexpectedFailure();
  }
}
