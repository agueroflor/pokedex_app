import '../entities/pokemon_detail.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemonDetailUseCase {
  final PokemonRepository _repository;

  GetPokemonDetailUseCase(this._repository);

  Future<PokemonDetail> call(int id) {
    return _repository.getPokemonDetail(id);
  }
}
