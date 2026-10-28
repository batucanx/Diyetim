import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/material.dart';

import '../theme/dy_context.dart';

/// Basılabilir öğelerin etkileşim durumu (görsel çizim için).
@immutable
class DyPressState {
  const DyPressState({required this.hovered, required this.pressed, required this.focused, required this.state});
  final bool hovered;
  final bool pressed;

  /// Klavye odağı (odak halkası gösterilirken true).
  final bool focused;
  final DyComponentState state;
  bool get interactive => state == DyComponentState.enabled;
}

/// Tüm basılabilir öğelerin tabanı: klavye (Enter/Space), odak halkası, basma ölçeği, fare imleci ve semantik.
/// - disabled: odaklanmaz, tetiklenmez.
/// - locked: odaklanabilir, ekran okuyucu nedeni (lockedReason) okur, tetiklenmez.
/// - loading: odaklanabilir, "yükleniyor" bildirilir, tetiklenmez.
class DyPressable extends StatefulWidget {
  const DyPressable({
    super.key,
    required this.builder,
    this.onPressed,
    this.state = DyComponentState.enabled,
    this.lockedReason,
    this.semanticLabel,
    this.semanticValue,
    this.button = true,
    this.toggled,
    this.checked,
    this.selected,
    this.inMutuallyExclusiveGroup,
    this.borderRadius = const BorderRadius.all(Radius.circular(DyRadius.md)),
    this.pressScale = 0.98,
    this.minSize = const Size(DySize.targetMin, DySize.targetMin),
    this.focusNode,
    this.autofocus = false,
  });

  final Widget Function(BuildContext context, DyPressState s) builder;
  final VoidCallback? onPressed;
  final DyComponentState state;
  final String? lockedReason;

  /// Erişilebilir ad. Verilmezse içerikten birleştirilir.
  final String? semanticLabel;
  final String? semanticValue;
  final bool button;
  final bool? toggled;
  final bool? checked;
  final bool? selected;
  final bool? inMutuallyExclusiveGroup;

  /// Odak halkasının izleyeceği şekil.
  final BorderRadius borderRadius;
  final double pressScale;

  /// En küçük dokunma alanı (varsayılan 44 × 44).
  final Size minSize;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<DyPressable> createState() => _DyPressableState();
}

class _DyPressableState extends State<DyPressable> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focusHighlight = false;

  bool get _interactive => widget.state == DyComponentState.enabled && widget.onPressed != null;

  void _activate() {
    if (_interactive) widget.onPressed!.call();
  }

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final s = DyPressState(hovered: _hovered, pressed: _pressed, focused: _focusHighlight, state: widget.state);
    final hint = switch (widget.state) {
      DyComponentState.locked => widget.lockedReason,
      DyComponentState.loading => 'Yükleniyor',
      _ => null,
    };
    Widget child = widget.builder(context, s);
    child = AnimatedScale(
      scale: _pressed && _interactive ? widget.pressScale : 1,
      duration: dy.duration(DyDuration.instant),
      curve: DyEasing.standard,
      child: child,
    );
    child = CustomPaint(
      foregroundPainter: _focusHighlight ? _FocusRingPainter(dy.colors.focusRing, widget.borderRadius) : null,
      child: ConstrainedBox(constraints: BoxConstraints(minWidth: widget.minSize.width, minHeight: widget.minSize.height), child: Center(widthFactor: 1, heightFactor: 1, child: child)),
    );
    return Semantics(
      container: true,
      button: widget.button,
      enabled: widget.state == DyComponentState.enabled,
      label: widget.semanticLabel,
      value: widget.semanticValue,
      hint: hint,
      toggled: widget.toggled,
      checked: widget.checked,
      selected: widget.selected,
      inMutuallyExclusiveGroup: widget.inMutuallyExclusiveGroup,
      onTap: _interactive ? _activate : null,
      child: FocusableActionDetector(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        enabled: widget.state != DyComponentState.disabled,
        mouseCursor: _interactive ? SystemMouseCursors.click : (widget.state == DyComponentState.disabled ? SystemMouseCursors.basic : SystemMouseCursors.forbidden),
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focusHighlight = v),
        actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => _activate())},
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTapDown: _interactive ? (_) => setState(() => _pressed = true) : null,
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          onTap: _interactive ? _activate : null,
          child: child,
        ),
      ),
    );
  }
}

/// Odak halkası: 2 px, 2 px boşlukla, şeklin köşelerini izler.
class _FocusRingPainter extends CustomPainter {
  _FocusRingPainter(this.color, this.radius);
  final Color color;
  final BorderRadius radius;

  @override
  void paint(Canvas canvas, Size size) {
    const offset = DyBorderWidth.focusOffset + DyBorderWidth.focusWidth / 2;
    final rrect = radius.toRRect(Offset.zero & size).inflate(offset);
    canvas.drawRRect(rrect, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = DyBorderWidth.focusWidth
      ..color = color);
  }

  @override
  bool shouldRepaint(_FocusRingPainter old) => old.color != color || old.radius != radius;
}

/// Klavye odağında aynı halkayı başka öğelere (ör. metin alanı çerçevesi) uygulamak için.
class DyFocusRing extends StatelessWidget {
  const DyFocusRing({super.key, required this.visible, required this.child, this.borderRadius = const BorderRadius.all(Radius.circular(DyRadius.md))});
  final bool visible;
  final Widget child;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => CustomPaint(foregroundPainter: visible ? _FocusRingPainter(context.dy.colors.focusRing, borderRadius) : null, child: child);
}
