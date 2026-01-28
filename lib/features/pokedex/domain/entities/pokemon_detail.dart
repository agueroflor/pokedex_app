class PokemonDetail {
  final int id;
  final String name;
  final String imageUrl;
  final int height;
  final int weight;
  final List<String> types;

  // Valores derivados para presentación.
  // Se calculan una sola vez para evitar lógica repetida en la UI y mantener
  // los widgets simples y declarativos.
  // En un producto grande podrían moverse a una capa de presentación,
  // pero para este scope es un trade-off consciente.
  late final String displayName = _capitalize(name);
  late final String displayId = '#${id.toString().padLeft(3, '0')}';
  late final String displayHeight = '${(height / 10).toStringAsFixed(1)} m';
  late final String displayWeight = '${(weight / 10).toStringAsFixed(1)} kg';
  late final List<String> displayTypes = types
      .map((t) => _capitalize(t))
      .toList();

  PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
  });

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}
