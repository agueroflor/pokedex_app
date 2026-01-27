import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits.dart';
import '../domain/failures/pokemon_failure.dart';
import '../../../core/constants/api_constants.dart';
import '../../../data/exceptions/pokemon_exceptions.dart';
import '../domain/usecases/get_pokemon_list_use_case.dart';


class PokedexCubit extends Cubit<PokedexState> {
  final GetPokemonListUseCase _getPokemonList;

  PokedexCubit(this._getPokemonList) : super(const PokedexState());

  Future<void> loadInitial() async {
    emit(state.copyWith(
      status: PokedexStatus.loading,
      pokemon: [],
      hasMore: true,
      isLoadingMore: false,
      failure: null,
    ));

    try {
      final result = await _getPokemonList(
        limit: ApiConstants.defaultPageSize,
        offset: 0,
      );

      if (result.items.isEmpty) {
        emit(state.copyWith(status: PokedexStatus.empty));
      } else {
        emit(state.copyWith(
          status: PokedexStatus.success,
          pokemon: result.items,
          hasMore: result.hasMore,
        ));
      }
    } on PokemonException catch (e) {
      emit(state.copyWith(
        status: PokedexStatus.error,
        failure: e.failure,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: PokedexStatus.error,
        failure: const UnexpectedFailure(),
      ));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final result = await _getPokemonList(
        limit: ApiConstants.defaultPageSize,
        offset: state.pokemon.length,
      );

      emit(state.copyWith(
        pokemon: [...state.pokemon, ...result.items],
        hasMore: result.hasMore,
        isLoadingMore: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}
