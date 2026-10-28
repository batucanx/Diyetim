import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/material.dart';

/// Diyetim temaları. Material 3 yalnızca taban olarak kullanılır; tüm ürün değerleri
/// [DyColors] ve [DyShadows] uzantılarından okunur (`context.dy`).
abstract final class DyTheme {
  static ThemeData light() => _build(Brightness.light, DyColors.light, DyShadows.light);
  static ThemeData dark() => _build(Brightness.dark, DyColors.dark, DyShadows.dark);

  static ThemeData _build(Brightness brightness, DyColors c, DyShadows s) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.textOnPrimary,
      primaryContainer: c.primarySubtle,
      onPrimaryContainer: c.onPrimarySubtle,
      secondary: c.primary,
      onSecondary: c.textOnPrimary,
      error: c.error,
      onError: c.textOnPrimary,
      errorContainer: c.errorSubtle,
      onErrorContainer: c.errorStrong,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceContainerHighest: c.surfaceSecondary,
      outline: c.borderStrong,
      outlineVariant: c.border,
      inverseSurface: c.surfaceInverse,
      onInverseSurface: c.textOnInverse,
      shadow: const Color(0xFF000000),
      scrim: c.scrim,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      // Ham aile adı: ThemeData `packages/dy_tokens/` önekini kendisi ekler. TextStyle.fontFamily zaten
      // önekli olduğundan oradan okumak adı ikiye katlıyor ve stilsiz metinler sistem fontuna düşüyordu.
      fontFamily: DyTypeScale.fontFamily,
      package: DyTypeScale.fontPackage,
      splashFactory: NoSplash.splashFactory,
      highlightColor: const Color(0x00000000),
      focusColor: c.focusRing,
      textSelectionTheme: TextSelectionThemeData(cursorColor: c.primary, selectionColor: c.primarySubtle, selectionHandleColor: c.primary),
      dividerColor: c.borderSubtle,
      extensions: <ThemeExtension<dynamic>>[c, s],
    );
  }
}
