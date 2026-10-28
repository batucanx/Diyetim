import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/material.dart';

/// Bileşenlerin tema erişimi: `context.dy.colors.textPrimary`, `context.dy.text(DyTextStyle.h2)`.
@immutable
class DyThemeData {
  const DyThemeData({required this.colors, required this.shadows, required this.expanded, required this.reduceMotion, required this.isDark});

  final DyColors colors;
  final DyShadows shadows;

  /// Pencere genişliği ≥ [DyBreakpoint.expanded]: masaüstü tipografi ölçeği.
  final bool expanded;

  /// İşletim sisteminde hareketi azalt açık.
  final bool reduceMotion;
  final bool isDark;

  static DyThemeData of(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<DyColors>();
    final shadows = theme.extension<DyShadows>();
    assert(colors != null && shadows != null, 'MaterialApp temasına DyTheme.light() / DyTheme.dark() verilmeli.');
    return DyThemeData(
      colors: colors ?? DyColors.light,
      shadows: shadows ?? DyShadows.light,
      expanded: MediaQuery.sizeOf(context).width >= DyBreakpoint.expanded,
      reduceMotion: MediaQuery.maybeDisableAnimationsOf(context) ?? false,
      isDark: theme.brightness == Brightness.dark,
    );
  }

  /// Tipografi stili, verilen tonun rengiyle.
  TextStyle text(DyTextStyle style, {DyTextTone tone = DyTextTone.primary}) {
    final s = expanded ? DyTypeScale.expanded(style) : DyTypeScale.compact(style);
    return s.copyWith(color: toneColor(tone));
  }

  Color toneColor(DyTextTone tone) => switch (tone) {
        DyTextTone.primary => colors.textPrimary,
        DyTextTone.secondary => colors.textSecondary,
        DyTextTone.muted => colors.textMuted,
        DyTextTone.disabled => colors.textDisabled,
        DyTextTone.onPrimary => colors.textOnPrimary,
        DyTextTone.onInverse => colors.textOnInverse,
        DyTextTone.link => colors.textLink,
        DyTextTone.error => colors.errorStrong,
        DyTextTone.success => colors.successStrong,
      };

  /// Hareketi azalt açıksa sıfır süre.
  Duration duration(Duration d) => reduceMotion ? Duration.zero : d;
}

extension DyContext on BuildContext {
  DyThemeData get dy => DyThemeData.of(this);
}
