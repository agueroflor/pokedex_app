import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/card_styles.dart';

class PokemonImageBox extends StatelessWidget {
  final String imageUrl;
  final double? size;

  const PokemonImageBox({
    super.key,
    required this.imageUrl,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size != null ? size! * 0.5 : 48.0;
    final outlineColor = Theme.of(context).colorScheme.outline;

    return Container(
      width: size,
      height: size,
      decoration: CardStyles.imageContainerDecoration(context),
      child: ClipRRect(
        borderRadius: CardStyles.imageBorderRadius,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          placeholder: (_, __) => Icon(
            Icons.catching_pokemon,
            size: iconSize,
            color: outlineColor.withValues(alpha: 0.3),
          ),
          errorWidget: (_, __, ___) => Icon(
            Icons.catching_pokemon,
            size: iconSize,
            color: outlineColor,
          ),
        ),
      ),
    );
  }
}

class PokemonName extends StatelessWidget {
  final String name;
  final TextAlign textAlign;

  const PokemonName({
    super.key,
    required this.name,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final capitalized = name.isNotEmpty
        ? '${name[0].toUpperCase()}${name.substring(1)}'
        : name;

    return Text(
      capitalized,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}

class PokemonNumber extends StatelessWidget {
  final int id;
  final TextAlign textAlign;

  const PokemonNumber({
    super.key,
    required this.id,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '#${id.toString().padLeft(3, '0')}',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: -0.5,
          ),
      textAlign: textAlign,
    );
  }
}
