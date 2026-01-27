import '../../features/pokedex/domain/entities/pokemon.dart';

class PokemonListItemModel {
  final int id;
  final String name;
  final String imageUrl;

  const PokemonListItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory PokemonListItemModel.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final id = _extractIdFromUrl(url);
    return PokemonListItemModel(
      id: id,
      name: json['name'] as String,
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
    );
  }

  factory PokemonListItemModel.fromHive(Map<dynamic, dynamic> map) {
    return PokemonListItemModel(
      id: map['id'] as int,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toHive() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  static int _extractIdFromUrl(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return int.parse(segments.last);
  }

  Pokemon toEntity() {
    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
    );
  }
}
