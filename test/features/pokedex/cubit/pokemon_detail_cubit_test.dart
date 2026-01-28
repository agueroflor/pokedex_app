import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/data/exceptions/pokemon_exceptions.dart';
import 'package:pokedex_app/features/pokedex/cubit/pokemon_detail_cubit.dart';
import 'package:pokedex_app/features/pokedex/cubit/pokemon_detail_state.dart';
import 'package:pokedex_app/features/pokedex/domain/failures/pokemon_failure.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late PokemonDetailCubit cubit;
  late MockGetPokemonDetailUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetPokemonDetailUseCase();
    cubit = PokemonDetailCubit(
      getPokemonDetail: mockUseCase,
      pokemonId: 1,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is correct', () {
    expect(cubit.state.status, PokemonDetailStatus.initial);
    expect(cubit.state.pokemon, isNull);
    expect(cubit.state.failure, isNull);
  });

  group('load', () {
    blocTest<PokemonDetailCubit, PokemonDetailState>(
      'emits [loading, success] when detail is loaded successfully',
      build: () {
        when(() => mockUseCase(1)).thenAnswer((_) async => tPokemonDetail);
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<PokemonDetailState>()
            .having((s) => s.status, 'status', PokemonDetailStatus.loading),
        isA<PokemonDetailState>()
            .having((s) => s.status, 'status', PokemonDetailStatus.success)
            .having((s) => s.pokemon?.id, 'pokemon.id', 1)
            .having((s) => s.pokemon?.name, 'pokemon.name', 'bulbasaur'),
      ],
    );

    blocTest<PokemonDetailCubit, PokemonDetailState>(
      'emits [loading, error] with NetworkFailure when PokemonException is thrown',
      build: () {
        when(() => mockUseCase(1))
            .thenThrow(const PokemonException(NetworkFailure()));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<PokemonDetailState>()
            .having((s) => s.status, 'status', PokemonDetailStatus.loading),
        isA<PokemonDetailState>()
            .having((s) => s.status, 'status', PokemonDetailStatus.error)
            .having((s) => s.failure, 'failure', isA<NetworkFailure>()),
      ],
    );

    blocTest<PokemonDetailCubit, PokemonDetailState>(
      'emits [loading, error] with NoCacheFailure',
      build: () {
        when(() => mockUseCase(1))
            .thenThrow(const PokemonException(NoCacheFailure()));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<PokemonDetailState>()
            .having((s) => s.status, 'status', PokemonDetailStatus.loading),
        isA<PokemonDetailState>()
            .having((s) => s.status, 'status', PokemonDetailStatus.error)
            .having((s) => s.failure, 'failure', isA<NoCacheFailure>()),
      ],
    );

    blocTest<PokemonDetailCubit, PokemonDetailState>(
      'emits [loading, error] with UnexpectedFailure on unknown exception',
      build: () {
        when(() => mockUseCase(1)).thenThrow(Exception('unknown'));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<PokemonDetailState>()
            .having((s) => s.status, 'status', PokemonDetailStatus.loading),
        isA<PokemonDetailState>()
            .having((s) => s.status, 'status', PokemonDetailStatus.error)
            .having((s) => s.failure, 'failure', isA<UnexpectedFailure>()),
      ],
    );

    blocTest<PokemonDetailCubit, PokemonDetailState>(
      'uses pokemonId passed to constructor',
      build: () {
        mockUseCase = MockGetPokemonDetailUseCase();
        when(() => mockUseCase(25)).thenAnswer((_) async => tPokemonDetail);
        return PokemonDetailCubit(
          getPokemonDetail: mockUseCase,
          pokemonId: 25,
        );
      },
      act: (cubit) => cubit.load(),
      verify: (_) {
        verify(() => mockUseCase(25)).called(1);
      },
    );
  });
}
