import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/dio_client.dart';
import 'data/datasources/remote/pokemon_remote_datasource.dart';
import 'data/repositories/pokemon_repository_impl.dart';
import 'features/pokedex/cubit/pokedex_cubit.dart';
import 'features/pokedex/domain/usecases/get_pokemon_list_use_case.dart';
import 'features/pokedex/screens/pokedex_screen.dart';

void main() {
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = PokemonRepositoryImpl(
      PokemonRemoteDatasource(DioClient.instance),
    );

    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => PokedexCubit(
          GetPokemonListUseCase(repository),
        ),
        child: const PokedexScreen(),
      ),
    );
  }
}
