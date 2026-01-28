import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/data/exceptions/pokemon_exceptions.dart';
import 'package:pokedex_app/data/models/models.dart';
import 'package:pokedex_app/data/repositories/pokemon_repository_impl.dart';
import 'package:pokedex_app/features/pokedex/domain/failures/pokemon_failure.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late PokemonRepositoryImpl repository;
  late MockPokemonRemoteDatasource mockRemote;
  late MockPokemonLocalDatasource mockLocal;

  setUpAll(() {
    registerFallbackValue(<PokemonListItemModel>[]);
    registerFallbackValue(tPokemonDetailModel);
  });

  setUp(() {
    mockRemote = MockPokemonRemoteDatasource();
    mockLocal = MockPokemonLocalDatasource();
    repository = PokemonRepositoryImpl(mockRemote, mockLocal);
  });

  group('getPokemonList', () {
    test('returns data from remote and saves to cache on success', () async {
      when(() => mockLocal.getPokemonList()).thenReturn([]);
      when(() => mockRemote.getPokemonList(limit: 20, offset: 0))
          .thenAnswer((_) async => tPokemonListResponse);
      when(() => mockLocal.savePokemonList(any()))
          .thenAnswer((_) async {});

      final result = await repository.getPokemonList(limit: 20, offset: 0);

      expect(result.items.length, 3);
      expect(result.items[0].id, 1);
      expect(result.items[0].name, 'bulbasaur');
      expect(result.hasMore, true);

      verify(() => mockLocal.savePokemonList(tPokemonModels)).called(1);
    });

    test('returns cached data when remote fails and cache exists', () async {
      when(() => mockLocal.getPokemonList()).thenReturn(tPokemonModels);
      when(() => mockRemote.getPokemonList(limit: 20, offset: 0))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      final result = await repository.getPokemonList(limit: 20, offset: 0);

      expect(result.items.length, 3);
      expect(result.items[0].name, 'bulbasaur');
    });

    test('throws NetworkFailure when remote fails and cache is empty', () async {
      when(() => mockLocal.getPokemonList()).thenReturn([]);
      when(() => mockRemote.getPokemonList(limit: 20, offset: 0))
          .thenThrow(DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(),
          ));

      expect(
        () => repository.getPokemonList(limit: 20, offset: 0),
        throwsA(isA<PokemonException>().having(
          (e) => e.failure,
          'failure',
          isA<NetworkFailure>(),
        )),
      );
    });

    test('returns empty list when offset exceeds cache size', () async {
      when(() => mockLocal.getPokemonList()).thenReturn(tPokemonModels);
      when(() => mockRemote.getPokemonList(limit: 20, offset: 100))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      final result = await repository.getPokemonList(limit: 20, offset: 100);

      expect(result.items, isEmpty);
      expect(result.hasMore, false);
    });

    test('paginates correctly from cache when remote fails', () async {
      when(() => mockLocal.getPokemonList()).thenReturn(tPokemonModels);
      when(() => mockRemote.getPokemonList(limit: 2, offset: 0))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      final result = await repository.getPokemonList(limit: 2, offset: 0);

      expect(result.items.length, 2);
      expect(result.hasMore, true);
    });

    test('appends to existing cache on pagination', () async {
      final existingCache = [tPokemonModel1, tPokemonModel2];
      when(() => mockLocal.getPokemonList()).thenReturn(existingCache);
      when(() => mockRemote.getPokemonList(limit: 20, offset: 2))
          .thenAnswer((_) async => tPokemonListResponseNoMore);
      when(() => mockLocal.savePokemonList(any()))
          .thenAnswer((_) async {});

      await repository.getPokemonList(limit: 20, offset: 2);

      verify(() => mockLocal.savePokemonList(
        [tPokemonModel1, tPokemonModel2, ...tPokemonModels],
      )).called(1);
    });
  });

  group('getPokemonDetail', () {
    test('returns data from remote and saves to cache on success', () async {
      when(() => mockLocal.getPokemonDetail(1)).thenReturn(null);
      when(() => mockRemote.getPokemonDetail(1))
          .thenAnswer((_) async => tPokemonDetailModel);
      when(() => mockLocal.savePokemonDetail(any()))
          .thenAnswer((_) async {});

      final result = await repository.getPokemonDetail(1);

      expect(result.id, 1);
      expect(result.name, 'bulbasaur');
      expect(result.types, ['grass', 'poison']);

      verify(() => mockLocal.savePokemonDetail(tPokemonDetailModel)).called(1);
    });

    test('returns cached data when remote fails and cache exists', () async {
      when(() => mockLocal.getPokemonDetail(1)).thenReturn(tPokemonDetailModel);
      when(() => mockRemote.getPokemonDetail(1))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      final result = await repository.getPokemonDetail(1);

      expect(result.id, 1);
      expect(result.name, 'bulbasaur');
    });

    test('throws NetworkFailure when remote fails and cache is empty', () async {
      when(() => mockLocal.getPokemonDetail(1)).thenReturn(null);
      when(() => mockRemote.getPokemonDetail(1))
          .thenThrow(DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(),
          ));

      expect(
        () => repository.getPokemonDetail(1),
        throwsA(isA<PokemonException>().having(
          (e) => e.failure,
          'failure',
          isA<NetworkFailure>(),
        )),
      );
    });

    test('throws UnexpectedFailure for non-network errors', () async {
      when(() => mockLocal.getPokemonDetail(1)).thenReturn(null);
      when(() => mockRemote.getPokemonDetail(1))
          .thenThrow(Exception('unknown error'));

      expect(
        () => repository.getPokemonDetail(1),
        throwsA(isA<PokemonException>().having(
          (e) => e.failure,
          'failure',
          isA<UnexpectedFailure>(),
        )),
      );
    });
  });
}
