import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/material.dart';

import '../primitives/dy_icon.dart';
import '../primitives/dy_pressable.dart';
import '../theme/dy_context.dart';

/// Eylem butonu. Ekranda en fazla bir [DyButtonVariant.primary].
/// loading genişliği korur, etiketi ekran okuyucu için saklar; dönen yükleyici kullanılmaz.
class DyButton extends StatelessWidget {
  const DyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = DyButtonVariant.primary,
    this.size = DyButtonSize.md,
    this.state = DyComponentState.enabled,
    this.lockedReason,
    this.iconStart,
    this.iconEnd,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final DyButtonVariant variant;

  /// sm 36 (yalnızca panel) · md 44 · lg 52 (mobil ana eylem).
  final DyButtonSize size;
  final DyComponentState state;
  final String? lockedReason;
  final DyIconData? iconStart;
  final DyIconData? iconEnd;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final height = switch (size) { DyButtonSize.sm => DySize.controlSm, DyButtonSize.md => DySize.controlMd, DyButtonSize.lg => DySize.controlLg };
    final padH = switch (size) { DyButtonSize.sm => DySpacing.lg, DyButtonSize.md => DySpacing.xl, DyButtonSize.lg => DySpacing.xl2 };
    final textStyle = switch (size) {
      DyButtonSize.sm => dy.text(DyTextStyle.label),
      DyButtonSize.md => dy.text(DyTextStyle.body).copyWith(fontWeight: FontWeight.w700),
      DyButtonSize.lg => dy.text(DyTextStyle.h4).copyWith(fontWeight: FontWeight.w700),
    };
    final iconSize = size == DyButtonSize.lg ? DyIconSize.md : DyIconSize.sm;
    const radius = BorderRadius.all(Radius.circular(DyRadius.md));

    return DyPressable(
      onPressed: onPressed,
      state: state,
      lockedReason: lockedReason,
      semanticLabel: label,
      borderRadius: radius,
      minSize: Size(DySize.targetMin, size == DyButtonSize.sm ? DySize.controlSm : DySize.targetMin),
      builder: (context, s) {
        final locked = state == DyComponentState.locked;
        final (Color bg, Color fg, Color border) = locked
            ? (c.surfaceSunken, c.textSecondary, c.borderSubtle)
            : switch (variant) {
                DyButtonVariant.primary => (s.pressed ? c.primaryActive : s.hovered ? c.primaryHover : c.primary, c.textOnPrimary, const Color(0x00000000)),
                DyButtonVariant.secondary => (c.primarySubtle, c.onPrimarySubtle, const Color(0x00000000)),
                DyButtonVariant.tertiary => (const Color(0x00000000), c.textPrimary, s.hovered ? c.borderStrong : c.border),
                DyButtonVariant.ghost => (s.hovered ? c.primarySubtle : const Color(0x00000000), c.textLink, const Color(0x00000000)),
                DyButtonVariant.destructive => (c.error, c.textOnPrimary, const Color(0x00000000)),
              };
        final content = Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: DySpacing.sm,
          children: [
            if (locked) DyIcon(DyIcons.lock, size: DyIconSize.sm, color: fg) else if (iconStart != null) DyIcon(iconStart!, size: iconSize, color: fg),
            Flexible(child: Text(label, style: textStyle.copyWith(color: fg), textAlign: TextAlign.center, softWrap: true)),
            if (iconEnd != null) DyIcon(iconEnd!, size: iconSize, color: fg),
          ],
        );
        return Opacity(
          opacity: state == DyComponentState.disabled ? DyOpacity.disabled : 1,
          child: AnimatedContainer(
            duration: dy.duration(DyDuration.fast),
            curve: DyEasing.standard,
            constraints: BoxConstraints(minHeight: height, minWidth: fullWidth ? double.infinity : 0),
            padding: EdgeInsets.symmetric(horizontal: variant == DyButtonVariant.ghost ? DySpacing.md : padH, vertical: DySpacing.sm),
            decoration: BoxDecoration(color: bg, borderRadius: radius, border: Border.all(color: border, width: DyBorderWidth.widthHairline)),
            child: Stack(alignment: Alignment.center, children: [
              Opacity(opacity: state == DyComponentState.loading ? 0 : 1, child: content),
              if (state == DyComponentState.loading) DyProgressSweep(color: fg),
            ]),
          ),
        );
      },
    );
  }
}

/// Buton ve alanlarda kullanılan yatay ilerleme çizgisi. Hareketi azalt açıkken sabit durur.
class DyProgressSweep extends StatefulWidget {
  const DyProgressSweep({super.key, required this.color, this.width = DySpacing.xl4, this.height = DySpacing.xs});
  final Color color;
  final double width;
  final double height;

  @override
  State<DyProgressSweep> createState() => _DyProgressSweepState();
}

class _DyProgressSweepState extends State<DyProgressSweep> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: DyDuration.deliberate * 2);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.dy.reduceMotion) {
      _c.value = 0.5;
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DyRadius.full),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: ColoredBox(
            color: widget.color.withValues(alpha: 0.25),
            child: AnimatedBuilder(
              animation: _c,
              builder: (context, _) => FractionallySizedBox(
                widthFactor: 0.45,
                alignment: Alignment(-1.6 + _c.value * 3.2, 0),
                child: DecoratedBox(decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(DyRadius.full))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum DyIconButtonVariant { ghost, surface, primary }

/// Yalnızca ikon içeren buton. Erişilebilir ad zorunlu; dokunma alanı en az 44 × 44.
class DyIconButton extends StatelessWidget {
  const DyIconButton({super.key, required this.icon, required this.label, this.onPressed, this.variant = DyIconButtonVariant.ghost, this.large = false, this.state = DyComponentState.enabled, this.lockedReason});
  final DyIconData icon;
  final String label;
  final VoidCallback? onPressed;
  final DyIconButtonVariant variant;
  final bool large;
  final DyComponentState state;
  final String? lockedReason;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final size = large ? DySize.targetComfortable : DySize.targetMin;
    return DyPressable(
      onPressed: onPressed,
      state: state,
      lockedReason: lockedReason,
      semanticLabel: label,
      borderRadius: BorderRadius.circular(DyRadius.full),
      builder: (context, s) {
        final (Color bg, Color fg) = switch (variant) {
          DyIconButtonVariant.ghost => (s.hovered ? c.surfaceSecondary : const Color(0x00000000), c.textPrimary),
          DyIconButtonVariant.surface => (c.surface, c.textPrimary),
          DyIconButtonVariant.primary => (c.primary, c.textOnPrimary),
        };
        return Opacity(
          opacity: state == DyComponentState.disabled ? DyOpacity.disabled : 1,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: variant == DyIconButtonVariant.surface ? Border.all(color: c.borderSubtle, width: DyBorderWidth.widthHairline) : null,
              boxShadow: variant == DyIconButtonVariant.surface ? dy.shadows.low : null,
            ),
            child: DyIcon(icon, size: large ? DyIconSize.lg : DyIconSize.md, color: fg),
          ),
        );
      },
    );
  }
}

/// Ekrandaki tek yüksek vurgulu eylem (surface-inverse).
class DyFab extends StatelessWidget {
  const DyFab({super.key, required this.icon, required this.label, this.onPressed, this.state = DyComponentState.enabled});
  final DyIconData icon;
  final String label;
  final VoidCallback? onPressed;
  final DyComponentState state;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    return DyPressable(
      onPressed: onPressed,
      state: state,
      semanticLabel: label,
      pressScale: 0.96,
      borderRadius: BorderRadius.circular(DyRadius.full),
      builder: (context, s) => Opacity(
        opacity: state == DyComponentState.disabled ? DyOpacity.disabled : 1,
        child: Container(
          width: DySize.fab,
          height: DySize.fab,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: dy.colors.surfaceInverse, shape: BoxShape.circle, boxShadow: dy.shadows.high),
          child: DyIcon(icon, size: DyIconSize.lg, color: dy.colors.textOnInverse),
        ),
      ),
    );
  }
}
