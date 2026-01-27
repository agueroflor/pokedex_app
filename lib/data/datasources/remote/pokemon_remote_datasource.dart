import 'package:dio/dio.dart';

import 'package:pokedex_app/data/models/models.dart';
import 'package:pokedex_app/core/constants/api_constants.dart';

class PokemonListResponse {
  final List<PokemonListItemModel> results;
  final bool hasMore;

  const PokemonListResponse({
    required this.results,
    required this.hasMore,
  });
}

class PokemonRemoteDatasource {
  final Dio _dio;

  PokemonRemoteDatasource(this._dio);

  Future<PokemonListResponse> getPokemonList({
    int limit = ApiConstants.defaultPageSize,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      '/pokemon',
      queryParameters: {
        'limit': limit,
        'offset': offset,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final results = (data['results'] as List)
        .map((item) => PokemonListItemModel.fromJson(item))
        .toList();

    final hasMore = data['next'] != null;

    return PokemonListResponse(
      results: results,
      hasMore: hasMore,
    );
  }

  Future<PokemonDetailModel> getPokemonDetail(int id) async {
    final response = await _dio.get('/pokemon/$id');
    return PokemonDetailModel.fromJson(response.data);
  }
}
