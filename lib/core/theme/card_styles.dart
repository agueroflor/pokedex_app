import 'package:flutter/material.dart';

class CardStyles {
  CardStyles._();

  static const double borderRadius = 16;
  static const double imageRadius = 12;

  static BorderRadius get cardBorderRadius => BorderRadius.circular(borderRadius);
  static BorderRadius get imageBorderRadius => BorderRadius.circular(imageRadius);

  static BoxDecoration cardDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
  }

  static BoxDecoration imageContainerDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: imageBorderRadius,
    );
  }
}
