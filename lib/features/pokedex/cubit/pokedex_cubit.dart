import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/api_constants.dart';
import '../../../data/repositories/pokemon_repository.dart';
import 'pokedex_state.dart';

class PokedexCubit extends Cubit<PokedexState> {
  final PokemonRepository _repository;

  PokedexCubit(this._repository) : super(const PokedexState());

  Future<void> loadInitial() async {
    emit(state.copyWith(
  status: PokedexStatus.loading,
  pokemon: [],
  hasMore: true,
  isLoadingMore: false,
  errorMessage: null,
));


    try {
      final result = await _repository.getPokemonList(
        limit: ApiConstants.defaultPageSize,
        offset: 0,
      );

      emit(state.copyWith(
        status: PokedexStatus.success,
        pokemon: result.items,
        hasMore: result.hasMore,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PokedexStatus.error,
        errorMessage: 'Failed to load Pokémon. Please try again.',
      ));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final result = await _repository.getPokemonList(
        limit: ApiConstants.defaultPageSize,
        offset: state.pokemon.length,
      );

      emit(state.copyWith(
        pokemon: [...state.pokemon, ...result.items],
        hasMore: result.hasMore,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}
