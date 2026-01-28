import '../../features/pokedex/domain/entities/pokemon_detail.dart';

class PokemonDetailModel {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<String> types;
  final String imageUrl;

  const PokemonDetailModel({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.imageUrl,
  });

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    final types = (json['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();

    final sprites = json['sprites'] as Map<String, dynamic>;
    final otherSprites = sprites['other'] as Map<String, dynamic>?;
    final officialArtwork = otherSprites?['official-artwork'] as Map<String, dynamic>?;
    final imageUrl = officialArtwork?['front_default'] as String? ??
        sprites['front_default'] as String? ??
        '';

    return PokemonDetailModel(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      types: types,
      imageUrl: imageUrl,
    );
  }

  factory PokemonDetailModel.fromHive(Map<dynamic, dynamic> map) {
    return PokemonDetailModel(
      id: map['id'] as int,
      name: map['name'] as String,
      height: map['height'] as int,
      weight: map['weight'] as int,
      types: (map['types'] as List).cast<String>(),
      imageUrl: map['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toHive() {
    return {
      'id': id,
      'name': name,
      'height': height,
      'weight': weight,
      'types': types,
      'imageUrl': imageUrl,
    };
  }

  PokemonDetail toEntity() {
    return PokemonDetail(
      id: id,
      name: name,
      imageUrl: imageUrl,
      height: height,
      weight: weight,
      types: types,
    );
  }
}
