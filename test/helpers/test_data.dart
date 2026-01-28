import 'package:pokedex_app/data/datasources/remote/pokemon_remote_datasource.dart';
import 'package:pokedex_app/data/models/models.dart';
import 'package:pokedex_app/features/pokedex/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokedex/domain/entities/pokemon_detail.dart';

const tPokemonModel1 = PokemonListItemModel(
  id: 1,
  name: 'bulbasaur',
  imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
);

const tPokemonModel2 = PokemonListItemModel(
  id: 2,
  name: 'ivysaur',
  imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
);

const tPokemonModel3 = PokemonListItemModel(
  id: 3,
  name: 'venusaur',
  imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png',
);

final tPokemonModels = [tPokemonModel1, tPokemonModel2, tPokemonModel3];

const tPokemon1 = Pokemon(
  id: 1,
  name: 'bulbasaur',
  imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
);

const tPokemon2 = Pokemon(
  id: 2,
  name: 'ivysaur',
  imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
);

const tPokemon3 = Pokemon(
  id: 3,
  name: 'venusaur',
  imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png',
);

final tPokemonList = [tPokemon1, tPokemon2, tPokemon3];

const tPokemonDetailModel = PokemonDetailModel(
  id: 1,
  name: 'bulbasaur',
  height: 7,
  weight: 69,
  types: ['grass', 'poison'],
  imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
);

const tPokemonDetail = PokemonDetail(
  id: 1,
  name: 'bulbasaur',
  height: 7,
  weight: 69,
  types: ['grass', 'poison'],
  imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
);

final tPokemonListResponse = PokemonListResponse(
  results: tPokemonModels,
  hasMore: true,
);

final tPokemonListResponseNoMore = PokemonListResponse(
  results: tPokemonModels,
  hasMore: false,
);
