import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/widgets.dart';

import '../generated/dy_icons.g.dart';

/// Bir durum tonunun renkleri: zemin (subtle), metin (strong) ve vurgu (ikon, nokta).
@immutable
class DyToneColors {
  const DyToneColors({required this.background, required this.foreground, required this.accent});
  final Color background;
  final Color foreground;
  final Color accent;

  /// Semantic renklerden çözer; light ve dark temada kontrast token testleriyle doğrulanmıştır.
  static DyToneColors of(DyColors c, DyStatusTone tone) => switch (tone) {
        DyStatusTone.neutral => DyToneColors(background: c.surfaceSecondary, foreground: c.textSecondary, accent: c.textMuted),
        DyStatusTone.success => DyToneColors(background: c.successSubtle, foreground: c.successStrong, accent: c.success),
        DyStatusTone.warning => DyToneColors(background: c.warningSubtle, foreground: c.warningStrong, accent: c.warning),
        DyStatusTone.error => DyToneColors(background: c.errorSubtle, foreground: c.errorStrong, accent: c.error),
        DyStatusTone.info => DyToneColors(background: c.infoSubtle, foreground: c.infoStrong, accent: c.info),
        DyStatusTone.primary => DyToneColors(background: c.primarySubtle, foreground: c.onPrimarySubtle, accent: c.primary),
      };
}

/// DyStatusStyle.icon adını ikon verisine çevirir.
DyIconData dyIconNamed(String name) => DyIcons.all.firstWhere((i) => i.name == name, orElse: () => DyIcons.info);
