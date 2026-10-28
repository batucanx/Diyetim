import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/material.dart';

import '../i18n_strings.dart';
import '../primitives/dy_icon.dart';
import '../theme/dy_context.dart';
import '../theme/dy_tone_colors.dart';
import '../utils/dy_format.dart';
import 'dy_button.dart';

/// Durum etiketi: subtle zemin + strong metin + ikon. 1–3 kelime.
class DyTag extends StatelessWidget {
  const DyTag({super.key, required this.label, this.tone = DyStatusTone.neutral, this.icon});
  final String label;
  final DyStatusTone tone;
  final DyIconData? icon;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final t = DyToneColors.of(dy.colors, tone);
    return Container(
      constraints: const BoxConstraints(minHeight: DySpacing.xl2),
      padding: const EdgeInsets.symmetric(horizontal: DySpacing.sm, vertical: DySpacing.xxs),
      decoration: BoxDecoration(color: t.background, borderRadius: BorderRadius.circular(DyRadius.sm)),
      child: Row(mainAxisSize: MainAxisSize.min, spacing: DySpacing.xs, children: [
        if (icon != null) DyIcon(icon!, size: DyIconSize.sm, color: t.foreground),
        Flexible(child: Text(label, style: dy.text(DyTextStyle.caption).copyWith(color: t.foreground, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}

/// Ortak sözleşmedeki durum stilini (ton, ikon, çeviri anahtarı) gösterir.
class DyStatusTag extends StatelessWidget {
  const DyStatusTag(this.style, {super.key});

  /// Örn. `DyMealStatus.pendingReview.style`, `DyAppointmentStatus.noShow.style`.
  final DyStatusStyle style;

  @override
  Widget build(BuildContext context) => DyTag(label: DyStrings.of(context).t(style.i18nKey), tone: style.tone, icon: dyIconNamed(style.icon));
}

/// Verinin kaynağı: Sen girdin · Diyetisyen · AI tahmini · Onaylı.
class DySourceTag extends StatelessWidget {
  const DySourceTag(this.source, {super.key});
  final DyDataSource source;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final s = source.style;
    final dot = switch (s.tone) { DyStatusTone.primary => dy.colors.primary, DyStatusTone.success => dy.colors.success, _ => dy.colors.textMuted };
    return Row(mainAxisSize: MainAxisSize.min, spacing: DySpacing.xs, children: [
      Container(width: DySpacing.xs, height: DySpacing.xs, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
      Text(DyStrings.of(context).t(s.i18nKey), style: dy.text(DyTextStyle.caption, tone: DyTextTone.secondary).copyWith(fontWeight: FontWeight.w600)),
    ]);
  }
}

enum DyBadgeTone { primary, error, neutral }

/// Sayaç rozeti. 0 iken gösterilmez; [max] üstü "99+".
class DyBadge extends StatelessWidget {
  const DyBadge({super.key, required this.count, required this.label, this.max = 99, this.tone = DyBadgeTone.primary});
  final int count;

  /// Ekran okuyucu metni, ör. "3 okunmamış bildirim".
  final String label;
  final int max;
  final DyBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final c = context.dy.colors;
    final (bg, fg) = switch (tone) {
      DyBadgeTone.primary => (c.primary, c.textOnPrimary),
      DyBadgeTone.error => (c.error, c.textOnPrimary),
      DyBadgeTone.neutral => (c.surfaceInverse, c.textOnInverse),
    };
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(minWidth: DySpacing.xl, minHeight: DySpacing.xl),
        padding: const EdgeInsets.symmetric(horizontal: DySpacing.xs),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(DyRadius.full)),
        child: Text(count > max ? '${DyFormat.number(max)}+' : DyFormat.number(count),
            style: context.dy.text(DyTextStyle.caption).copyWith(color: fg, fontWeight: FontWeight.w700, height: 1, fontFeatures: const [FontFeature.tabularFigures()])),
      ),
    );
  }
}

/// Kısa açıklama. Uzun basma (dokunmatik) ve fare/odak (masaüstü) ile görünür. Zorunlu bilgi tooltip'e konmaz.
class DyTooltip extends StatelessWidget {
  const DyTooltip({super.key, required this.message, required this.child});
  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    return Tooltip(
      message: message,
      waitDuration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(color: dy.colors.surfaceInverse, borderRadius: BorderRadius.circular(DyRadius.sm), boxShadow: dy.shadows.medium),
      textStyle: dy.text(DyTextStyle.caption).copyWith(color: dy.colors.textOnInverse, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: DySpacing.sm, vertical: DySpacing.xs),
      child: child,
    );
  }
}

/// Sayfa içi kalıcı mesaj. error ve warning hemen duyurulur (canlı bölge). [banner] sayfa üstü tam genişlik.
class DyAlert extends StatelessWidget {
  const DyAlert({super.key, required this.title, this.tone = DyFeedbackTone.info, this.message, this.actions = const [], this.onDismiss, this.banner = false, this.icon});
  final String title;
  final DyFeedbackTone tone;
  final String? message;
  final List<Widget> actions;
  final VoidCallback? onDismiss;
  final bool banner;
  final DyIconData? icon;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final t = DyToneColors.of(dy.colors, switch (tone) {
      DyFeedbackTone.info => DyStatusTone.info,
      DyFeedbackTone.success => DyStatusTone.success,
      DyFeedbackTone.warning => DyStatusTone.warning,
      DyFeedbackTone.error => DyStatusTone.error,
    });
    final ico = icon ?? switch (tone) { DyFeedbackTone.success => DyIcons.checkCircle, DyFeedbackTone.info => DyIcons.info, _ => DyIcons.alert };
    return Semantics(
      liveRegion: tone == DyFeedbackTone.error || tone == DyFeedbackTone.warning,
      container: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: banner ? DySpacing.xl : DySpacing.lg, vertical: DySpacing.lg),
        decoration: BoxDecoration(color: t.background, borderRadius: banner ? null : BorderRadius.circular(DyRadius.md)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: DySpacing.md, children: [
          Padding(padding: const EdgeInsets.only(top: DySpacing.xxs), child: DyIcon(ico, color: t.foreground)),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: DySpacing.xs, children: [
              Text(title, style: dy.text(DyTextStyle.body).copyWith(color: t.foreground, fontWeight: FontWeight.w700)),
              if (message != null) Text(message!, style: dy.text(DyTextStyle.bodySm).copyWith(color: t.foreground)),
              if (actions.isNotEmpty) Padding(padding: const EdgeInsets.only(top: DySpacing.xs), child: Wrap(spacing: DySpacing.sm, runSpacing: DySpacing.sm, children: actions)),
            ]),
          ),
          if (onDismiss != null) DyIconButton(icon: DyIcons.x, label: DyStrings.of(context).t('common.dismiss'), onPressed: onDismiss),
        ]),
      ),
    );
  }
}

/// Kısa süreli bildirim (Toast) veya tek eylemli bildirim (Snackbar: "Geri al").
/// ScaffoldMessenger kuyruğunu kullanır: aynı anda tek bildirim, ekran okuyucuya duyurulur.
abstract final class DyToast {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
    DyFeedbackTone tone = DyFeedbackTone.success,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    assert(tone == DyFeedbackTone.success || tone == DyFeedbackTone.info, 'Hatalar toast ile değil, ilgili alanda veya DyAlert ile gösterilir.');
    final dy = context.dy;
    final c = dy.colors;
    final fg = c.textOnInverse;
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.surfaceInverse,
      elevation: 0,
      duration: duration ?? (onAction != null ? const Duration(seconds: 6) : const Duration(seconds: 4)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DyRadius.lg)),
      margin: const EdgeInsets.fromLTRB(DySpacing.xl, 0, DySpacing.xl, DySpacing.lg),
      padding: const EdgeInsets.symmetric(horizontal: DySpacing.lg, vertical: DySpacing.sm),
      showCloseIcon: onAction == null,
      closeIconColor: fg,
      content: Row(spacing: DySpacing.md, children: [
        DyIcon(tone == DyFeedbackTone.info ? DyIcons.info : DyIcons.checkCircle, color: fg),
        Expanded(child: Text(message, style: dy.text(DyTextStyle.bodySm).copyWith(color: fg, fontWeight: FontWeight.w600))),
      ]),
      action: onAction == null || actionLabel == null ? null : SnackBarAction(label: actionLabel, textColor: fg, onPressed: onAction),
    ));
  }
}

/// Boş durum: ne oldu (başlık), neden (açıklama), ne yapılabilir (eylem). Büyük illüstrasyon yok.
class DyEmptyState extends StatelessWidget {
  const DyEmptyState({super.key, required this.title, this.description, this.icon = DyIcons.inbox, this.action, this.secondaryAction, this.compact = false});
  final String title;
  final String? description;
  final DyIconData icon;
  final Widget? action;
  final Widget? secondaryAction;
  final bool compact;

  @override
  Widget build(BuildContext context) => _StateLayout(icon: icon, title: title, description: description, actions: [if (action != null) action!, if (secondaryAction != null) secondaryAction!], compact: compact);
}

/// Hata durumu: sakin dil, teknik kod yok, her zaman bir yol. Varsayılan metinler çeviri anahtarından gelir.
class DyErrorState extends StatelessWidget {
  const DyErrorState({super.key, required this.kind, this.title, this.description, this.onAction, this.actionLabel, this.retrying = false, this.compact = false});
  final DyErrorKind kind;
  final String? title;
  final String? description;
  final VoidCallback? onAction;
  final String? actionLabel;
  final bool retrying;
  final bool compact;

  static DyIconData iconOf(DyErrorKind k) => switch (k) {
        DyErrorKind.network => DyIcons.wifiOff,
        DyErrorKind.server => DyIcons.alert,
        DyErrorKind.permission => DyIcons.lock,
        DyErrorKind.timeout => DyIcons.clock,
        DyErrorKind.processing => DyIcons.file,
        DyErrorKind.notFound => DyIcons.search,
      };

  @override
  Widget build(BuildContext context) {
    final s = DyStrings.of(context);
    String k(String part) => s.t('error.${kind.wire}.$part');
    return Semantics(
      liveRegion: true,
      child: _StateLayout(
        icon: iconOf(kind),
        title: title ?? k('title'),
        description: description ?? k('description'),
        warning: true,
        compact: compact,
        actions: [
          if (onAction != null)
            DyButton(
              label: actionLabel ?? k('action'),
              variant: kind == DyErrorKind.permission || kind == DyErrorKind.notFound ? DyButtonVariant.tertiary : DyButtonVariant.primary,
              state: retrying ? DyComponentState.loading : DyComponentState.enabled,
              onPressed: onAction,
            ),
        ],
      ),
    );
  }
}

/// Çevrimdışı bildirimi (banner). Girilen veriler kaybolmaz; bekleyen değişiklik sayısı gösterilir.
class DyOfflineState extends StatelessWidget {
  const DyOfflineState({super.key, this.pendingCount = 0, this.onRetry, this.retrying = false});
  final int pendingCount;
  final VoidCallback? onRetry;
  final bool retrying;

  @override
  Widget build(BuildContext context) {
    final s = DyStrings.of(context);
    return DyAlert(
      banner: true,
      tone: DyFeedbackTone.warning,
      icon: DyIcons.wifiOff,
      title: s.t('offline.title'),
      message: [s.t('offline.description'), if (pendingCount > 0) '${s.t('offline.pending', {'count': pendingCount})}.'].join(' '),
      actions: [
        if (onRetry != null)
          DyButton(label: s.t('offline.retry'), size: DyButtonSize.sm, variant: DyButtonVariant.tertiary, state: retrying ? DyComponentState.loading : DyComponentState.enabled, onPressed: onRetry),
      ],
    );
  }
}

/// Yükleme bölgesi: yüklenirken iskeleti gösterir ve bölgeyi meşgul olarak bildirir; bitince içeriği gösterir.
class DyLoadingRegion extends StatelessWidget {
  const DyLoadingRegion({super.key, required this.loading, required this.skeleton, required this.child, required this.label});
  final bool loading;
  final Widget skeleton;
  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    final s = DyStrings.of(context);
    return Semantics(
      container: true,
      label: loading ? '$label: ${s.t('common.loading')}' : label,
      liveRegion: true,
      child: AnimatedSwitcher(duration: context.dy.duration(DyDuration.normal), child: loading ? KeyedSubtree(key: const ValueKey('s'), child: skeleton) : KeyedSubtree(key: const ValueKey('c'), child: child)),
    );
  }
}

class _StateLayout extends StatelessWidget {
  const _StateLayout({required this.icon, required this.title, required this.description, required this.actions, required this.compact, this.warning = false});
  final DyIconData icon;
  final String title;
  final String? description;
  final List<Widget> actions;
  final bool compact;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DySpacing.xl, vertical: compact ? DySpacing.xl2 : DySpacing.xl6),
      child: Column(mainAxisSize: MainAxisSize.min, spacing: DySpacing.sm, children: [
        Container(
          width: DySize.controlLg,
          height: DySize.controlLg,
          margin: const EdgeInsets.only(bottom: DySpacing.sm),
          decoration: BoxDecoration(color: warning ? c.warningSubtle : c.surfaceSecondary, borderRadius: BorderRadius.circular(DyRadius.lg)),
          child: Center(child: DyIcon(icon, size: DyIconSize.lg, color: warning ? c.warningStrong : c.textSecondary)),
        ),
        Semantics(header: true, child: Text(title, textAlign: TextAlign.center, style: dy.text(DyTextStyle.h3))),
        if (description != null) Text(description!, textAlign: TextAlign.center, style: dy.text(DyTextStyle.body, tone: DyTextTone.secondary)),
        if (actions.isNotEmpty) Padding(padding: const EdgeInsets.only(top: DySpacing.md), child: Wrap(alignment: WrapAlignment.center, spacing: DySpacing.sm, runSpacing: DySpacing.sm, children: actions)),
      ]),
    );
  }
}
