import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

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
    final resolvedSize = size;
    final iconSize = resolvedSize != null ? resolvedSize * 0.5 : 48.0;
    final cacheSize = resolvedSize?.toInt();

    return Container(
      width: resolvedSize,
      height: resolvedSize,
      decoration: CardStyles.imageContainerDecoration(context),
      child: ClipRRect(
        borderRadius: CardStyles.imageBorderRadius,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          memCacheWidth: cacheSize,
          memCacheHeight: cacheSize,
          placeholder: (_, __) => _PlaceholderIcon(size: iconSize, opacity: 0.3),
          errorWidget: (_, __, ___) => _PlaceholderIcon(size: iconSize),
        ),
      ),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  final double size;
  final double opacity;

  const _PlaceholderIcon({
    required this.size,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outline;
    return Icon(
      Icons.catching_pokemon,
      size: size,
      color: opacity < 1.0 ? color.withValues(alpha: opacity) : color,
    );
  }
}

class PokemonName extends StatelessWidget {
  final String displayName;
  final TextAlign textAlign;

  const PokemonName({
    super.key,
    required this.displayName,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      displayName,
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
  final String displayId;
  final TextAlign textAlign;

  const PokemonNumber({
    super.key,
    required this.displayId,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      displayId,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: -0.5,
          ),
      textAlign: textAlign,
    );
  }
}
