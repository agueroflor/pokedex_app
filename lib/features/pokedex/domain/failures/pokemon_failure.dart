sealed class PokemonFailure {
  const PokemonFailure();

  String get message;
}

class NetworkFailure extends PokemonFailure {
  const NetworkFailure();

  @override
  String get message => 'No hay conexión a internet. Verificá tu red.';
}

class NoCacheFailure extends PokemonFailure {
  const NoCacheFailure();

  @override
    String get message => 'No hay datos disponibles. Conectate a internet e intentá de nuevo.';
  }

class UnexpectedFailure extends PokemonFailure {
  const UnexpectedFailure();

  @override
  String get message => 'Algo salió mal. Intentá de nuevo.';
}
