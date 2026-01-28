import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/data/exceptions/pokemon_exceptions.dart';
import 'package:pokedex_app/features/pokedex/cubit/pokedex_cubit.dart';
import 'package:pokedex_app/features/pokedex/cubit/pokedex_state.dart';
import 'package:pokedex_app/features/pokedex/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokedex/domain/failures/pokemon_failure.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late PokedexCubit cubit;
  late MockGetPokemonListUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetPokemonListUseCase();
    cubit = PokedexCubit(mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is correct', () {
    expect(cubit.state.status, PokedexStatus.initial);
    expect(cubit.state.pokemon, isEmpty);
    expect(cubit.state.hasMore, true);
    expect(cubit.state.isLoadingMore, false);
    expect(cubit.state.failure, isNull);
  });

  group('loadInitial', () {
    blocTest<PokedexCubit, PokedexState>(
      'emits [loading, success] when data is loaded successfully',
      build: () {
        when(() => mockUseCase(limit: any(named: 'limit'), offset: any(named: 'offset')))
            .thenAnswer((_) async => (items: tPokemonList, hasMore: true));
        return cubit;
      },
      act: (cubit) => cubit.loadInitial(),
      expect: () => [
        isA<PokedexState>()
            .having((s) => s.status, 'status', PokedexStatus.loading),
        isA<PokedexState>()
            .having((s) => s.status, 'status', PokedexStatus.success)
            .having((s) => s.pokemon.length, 'pokemon.length', 3)
            .having((s) => s.hasMore, 'hasMore', true),
      ],
    );

    blocTest<PokedexCubit, PokedexState>(
      'emits [loading, empty] when no pokemon are returned',
      build: () {
        when(() => mockUseCase(limit: any(named: 'limit'), offset: any(named: 'offset')))
            .thenAnswer((_) async => (items: <Pokemon>[], hasMore: false));
        return cubit;
      },
      act: (cubit) => cubit.loadInitial(),
      expect: () => [
        isA<PokedexState>()
            .having((s) => s.status, 'status', PokedexStatus.loading),
        isA<PokedexState>()
            .having((s) => s.status, 'status', PokedexStatus.empty),
      ],
    );

    blocTest<PokedexCubit, PokedexState>(
      'emits [loading, error] with NetworkFailure when PokemonException is thrown',
      build: () {
        when(() => mockUseCase(limit: any(named: 'limit'), offset: any(named: 'offset')))
            .thenThrow(const PokemonException(NetworkFailure()));
        return cubit;
      },
      act: (cubit) => cubit.loadInitial(),
      expect: () => [
        isA<PokedexState>()
            .having((s) => s.status, 'status', PokedexStatus.loading),
        isA<PokedexState>()
            .having((s) => s.status, 'status', PokedexStatus.error)
            .having((s) => s.failure, 'failure', isA<NetworkFailure>()),
      ],
    );

    blocTest<PokedexCubit, PokedexState>(
      'emits [loading, error] with UnexpectedFailure on unknown exception',
      build: () {
        when(() => mockUseCase(limit: any(named: 'limit'), offset: any(named: 'offset')))
            .thenThrow(Exception('unknown'));
        return cubit;
      },
      act: (cubit) => cubit.loadInitial(),
      expect: () => [
        isA<PokedexState>()
            .having((s) => s.status, 'status', PokedexStatus.loading),
        isA<PokedexState>()
            .having((s) => s.status, 'status', PokedexStatus.error)
            .having((s) => s.failure, 'failure', isA<UnexpectedFailure>()),
      ],
    );
  });

  group('loadMore', () {
    blocTest<PokedexCubit, PokedexState>(
      'appends new pokemon to existing list',
      build: () {
        when(() => mockUseCase(limit: any(named: 'limit'), offset: any(named: 'offset')))
            .thenAnswer((_) async => (items: [tPokemon3], hasMore: false));
        return cubit;
      },
      seed: () => PokedexState(
        status: PokedexStatus.success,
        pokemon: [tPokemon1, tPokemon2],
        hasMore: true,
      ),
      act: (cubit) => cubit.loadMore(),
      expect: () => [
        isA<PokedexState>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', true)
            .having((s) => s.pokemon.length, 'pokemon.length', 2),
        isA<PokedexState>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.pokemon.length, 'pokemon.length', 3)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );

    blocTest<PokedexCubit, PokedexState>(
      'does nothing when already loading more',
      build: () => cubit,
      seed: () => PokedexState(
        status: PokedexStatus.success,
        pokemon: tPokemonList,
        hasMore: true,
        isLoadingMore: true,
      ),
      act: (cubit) => cubit.loadMore(),
      expect: () => [],
    );

    blocTest<PokedexCubit, PokedexState>(
      'does nothing when hasMore is false',
      build: () => cubit,
      seed: () => PokedexState(
        status: PokedexStatus.success,
        pokemon: tPokemonList,
        hasMore: false,
      ),
      act: (cubit) => cubit.loadMore(),
      expect: () => [],
    );

    blocTest<PokedexCubit, PokedexState>(
      'resets isLoadingMore on error and keeps existing data',
      build: () {
        when(() => mockUseCase(limit: any(named: 'limit'), offset: any(named: 'offset')))
            .thenThrow(Exception('error'));
        return cubit;
      },
      seed: () => PokedexState(
        status: PokedexStatus.success,
        pokemon: tPokemonList,
        hasMore: true,
      ),
      act: (cubit) => cubit.loadMore(),
      expect: () => [
        isA<PokedexState>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', true)
            .having((s) => s.pokemon.length, 'pokemon.length', 3),
        isA<PokedexState>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.pokemon.length, 'pokemon.length', 3)
            .having((s) => s.hasMore, 'hasMore', true),
      ],
    );
  });
}
