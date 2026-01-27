import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/get_pokemon_detail_use_case.dart';
import 'pokemon_detail_state.dart';

class PokemonDetailCubit extends Cubit<PokemonDetailState> {
  final GetPokemonDetailUseCase _getPokemonDetail;
  final int pokemonId;

  PokemonDetailCubit({
    required GetPokemonDetailUseCase getPokemonDetail,
    required this.pokemonId,
  })  : _getPokemonDetail = getPokemonDetail,
        super(const PokemonDetailState());

  Future<void> load() async {
    emit(state.copyWith(status: PokemonDetailStatus.loading));

    try {
      final pokemon = await _getPokemonDetail(pokemonId);
      emit(state.copyWith(
        status: PokemonDetailStatus.success,
        pokemon: pokemon,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PokemonDetailStatus.error,
        errorMessage: 'Failed to load Pokémon details. Please try again.',
      ));
    }
  }
}
