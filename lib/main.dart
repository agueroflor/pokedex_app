import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/dependencies.dart';
import 'core/theme/theme.dart';
import 'features/pokedex/cubit/cubits.dart';
import 'features/pokedex/domain/repositories/pokemon_repository.dart';
import 'features/pokedex/domain/usecases/get_pokemon_list_use_case.dart';
import 'features/pokedex/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await Dependencies.init();
  runApp(PokedexApp(dependencies: dependencies));
}

class PokedexApp extends StatelessWidget {
  final Dependencies dependencies;

  const PokedexApp({super.key, required this.dependencies});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PokemonRepository>.value(
          value: dependencies.pokemonRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => PokedexCubit(
              GetPokemonListUseCase(dependencies.pokemonRepository),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Pokédex',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const PokedexScreen(),
        ),
      ),
    );
  }
}
