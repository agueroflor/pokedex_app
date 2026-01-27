import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/network/dio_client.dart';
import 'data/datasources/local/pokemon_local_datasource.dart';
import 'data/datasources/remote/pokemon_remote_datasource.dart';
import 'data/repositories/pokemon_repository_impl.dart';
import 'features/pokedex/cubit/pokedex_cubit.dart';
import 'features/pokedex/domain/repositories/pokemon_repository.dart';
import 'features/pokedex/domain/usecases/get_pokemon_list_use_case.dart';
import 'features/pokedex/screens/pokedex_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = PokemonRepositoryImpl(
      PokemonRemoteDatasource(DioClient.instance),
      PokemonLocalDatasource(),
    );

    return RepositoryProvider<PokemonRepository>.value(
      value: repository,
      child: MaterialApp(
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
      ),
    );
  }
}
