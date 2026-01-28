import 'package:hive_flutter/hive_flutter.dart';

import '../../data/datasources/local/pokemon_local_datasource.dart';
import '../../data/datasources/remote/pokemon_remote_datasource.dart';
import '../../data/repositories/pokemon_repository_impl.dart';
import '../../features/pokedex/domain/repositories/pokemon_repository.dart';
import '../network/dio_client.dart';

class Dependencies {
  final PokemonRepository pokemonRepository;

  const Dependencies._({required this.pokemonRepository});

  static Future<Dependencies> init() async {
    await Hive.initFlutter();

    final listBox = await Hive.openBox(PokemonLocalDatasource.listBoxName);
    final detailBox = await Hive.openBox(PokemonLocalDatasource.detailBoxName);

    final localDatasource = PokemonLocalDatasource(
      listBox: listBox,
      detailBox: detailBox,
    );
    final remoteDatasource = PokemonRemoteDatasource(DioClient.instance);

    final pokemonRepository = PokemonRepositoryImpl(
      remoteDatasource,
      localDatasource,
    );

    return Dependencies._(pokemonRepository: pokemonRepository);
  }
}
