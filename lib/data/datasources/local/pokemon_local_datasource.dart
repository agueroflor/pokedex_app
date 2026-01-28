import 'package:hive/hive.dart';

import '../../models/models.dart';

class PokemonLocalDatasource {
  static const String listBoxName = 'pokemon_list';
  static const String detailBoxName = 'pokemon_detail';
  static const String _listKey = 'cached_list';

  final Box _listBox;
  final Box _detailBox;

  PokemonLocalDatasource({
    required Box listBox,
    required Box detailBox,
  })  : _listBox = listBox,
        _detailBox = detailBox;

  List<PokemonListItemModel> getPokemonList() {
    final data = _listBox.get(_listKey);
    if (data == null) return [];

    return (data as List)
        .map((item) => PokemonListItemModel.fromHive(item))
        .toList();
  }

  Future<void> savePokemonList(List<PokemonListItemModel> pokemon) async {
    final data = pokemon.map((p) => p.toHive()).toList();
    await _listBox.put(_listKey, data);
  }

  PokemonDetailModel? getPokemonDetail(int id) {
    final data = _detailBox.get(id);
    if (data == null) return null;

    return PokemonDetailModel.fromHive(data);
  }

  Future<void> savePokemonDetail(PokemonDetailModel detail) async {
    await _detailBox.put(detail.id, detail.toHive());
  }
}
