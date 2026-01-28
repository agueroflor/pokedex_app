import 'package:flutter/material.dart';

class CardStyles {
  CardStyles._();

  static const double borderRadius = 16;
  static const double imageRadius = 12;

  static final BorderRadius cardBorderRadius = BorderRadius.circular(borderRadius);
  static final BorderRadius imageBorderRadius = BorderRadius.circular(imageRadius);

  static final Map<int, BoxDecoration> _cardDecorationCache = {};
  static final Map<int, BoxDecoration> _imageDecorationCache = {};

  static BoxDecoration cardDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final cacheKey = theme.colorScheme.hashCode;

    return _cardDecorationCache.putIfAbsent(cacheKey, () {
      final colorScheme = theme.colorScheme;
      return BoxDecoration(
        color: colorScheme.surface,
        borderRadius: cardBorderRadius,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
    });
  }

  static BoxDecoration imageContainerDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final cacheKey = theme.colorScheme.hashCode;

    return _imageDecorationCache.putIfAbsent(cacheKey, () {
      final colorScheme = theme.colorScheme;
      return BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: imageBorderRadius,
      );
    });
  }
}
