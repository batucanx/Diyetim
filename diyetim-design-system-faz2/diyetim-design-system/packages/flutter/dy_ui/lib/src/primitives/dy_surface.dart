import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/widgets.dart';

import '../theme/dy_context.dart';

/// Zemin, kenarlık, radius ve derinliği tek yerden yöneten kutu. Kartlar ve paneller bunun üzerine kurulur.
/// Dark temada derinlik gölge yerine yüzey tonu ve üst kenar ışığıyla verilir.
class DySurface extends StatelessWidget {
  const DySurface({super.key, this.level = DySurfaceLevel.surface, this.elevation = DyElevation.none, this.radius = DyRadius.lg, this.padding, this.bordered, this.child});

  final DySurfaceLevel level;
  final DyElevation elevation;

  /// [DyRadius] değerlerinden biri.
  final double radius;

  /// [DySpacing] değerleriyle EdgeInsets.
  final EdgeInsetsGeometry? padding;

  /// Varsayılan: surface ve elevated katmanlarında açık.
  final bool? bordered;
  final Widget? child;

  static Color colorOf(DyColors c, DySurfaceLevel level) => switch (level) {
        DySurfaceLevel.background => c.background,
        DySurfaceLevel.surface => c.surface,
        DySurfaceLevel.elevated => c.surfaceElevated,
        DySurfaceLevel.secondary => c.surfaceSecondary,
        DySurfaceLevel.sunken => c.surfaceSunken,
        DySurfaceLevel.inverse => c.surfaceInverse,
      };

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final showBorder = bordered ?? (level == DySurfaceLevel.surface || level == DySurfaceLevel.elevated);
    final raised = elevation != DyElevation.none;
    final borderColor = dy.isDark && raised ? Color.alphaBlend(dy.shadows.edgeHighlight, c.borderSubtle) : c.borderSubtle;
    final content = level == DySurfaceLevel.inverse
        ? DefaultTextStyle.merge(style: TextStyle(color: c.textOnInverse), child: child ?? const SizedBox.shrink())
        : child;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorOf(c, level),
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor, width: DyBorderWidth.widthHairline) : null,
        boxShadow: dy.shadows.of(elevation),
      ),
      child: padding == null ? content : Padding(padding: padding!, child: content),
    );
  }
}
