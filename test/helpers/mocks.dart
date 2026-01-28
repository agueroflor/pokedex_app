import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/data/datasources/local/pokemon_local_datasource.dart';
import 'package:pokedex_app/data/datasources/remote/pokemon_remote_datasource.dart';
import 'package:pokedex_app/features/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_app/features/pokedex/domain/usecases/get_pokemon_detail_use_case.dart';
import 'package:pokedex_app/features/pokedex/domain/usecases/get_pokemon_list_use_case.dart';

class MockPokemonRemoteDatasource extends Mock
    implements PokemonRemoteDatasource {}

class MockPokemonLocalDatasource extends Mock
    implements PokemonLocalDatasource {}

class MockPokemonRepository extends Mock implements PokemonRepository {}

class MockGetPokemonListUseCase extends Mock implements GetPokemonListUseCase {}

class MockGetPokemonDetailUseCase extends Mock
    implements GetPokemonDetailUseCase {}
