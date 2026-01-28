class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  late final String displayName = _capitalize(name);
  late final String displayId = '#${id.toString().padLeft(3, '0')}';

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}
