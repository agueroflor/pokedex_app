import 'package:hive/hive.dart';

import '../../models/models.dart';

class PokemonLocalDatasource {
  static const String _listBoxName = 'pokemon_list';
  static const String _detailBoxName = 'pokemon_detail';
  static const String _listKey = 'cached_list';

  Future<Box> get _listBox => Hive.openBox(_listBoxName);
  Future<Box> get _detailBox => Hive.openBox(_detailBoxName);

  Future<List<PokemonListItemModel>> getPokemonList() async {
    final box = await _listBox;
    final data = box.get(_listKey);
    if (data == null) return [];

    return (data as List)
        .map((item) => PokemonListItemModel.fromHive(item))
        .toList();
  }

  Future<void> savePokemonList(List<PokemonListItemModel> pokemon) async {
    final box = await _listBox;
    final data = pokemon.map((p) => p.toHive()).toList();
    await box.put(_listKey, data);
  }

  Future<PokemonDetailModel?> getPokemonDetail(int id) async {
    final box = await _detailBox;
    final data = box.get(id);
    if (data == null) return null;

    return PokemonDetailModel.fromHive(data);
  }

  Future<void> savePokemonDetail(PokemonDetailModel detail) async {
    final box = await _detailBox;
    await box.put(detail.id, detail.toHive());
  }
}
