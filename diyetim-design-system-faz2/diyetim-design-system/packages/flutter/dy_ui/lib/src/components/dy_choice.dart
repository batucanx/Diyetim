import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../primitives/dy_icon.dart';
import '../primitives/dy_pressable.dart';
import '../theme/dy_context.dart';

Widget _texts(BuildContext context, String label, String? description, String? lockedReason, String? error, DyComponentState state) {
  final dy = context.dy;
  final c = dy.colors;
  return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, spacing: DySpacing.xxs, children: [
    Text(label, style: dy.text(DyTextStyle.body).copyWith(fontWeight: FontWeight.w600)),
    if (description != null) Text(description, style: dy.text(DyTextStyle.bodySm, tone: DyTextTone.muted)),
    if (state == DyComponentState.locked && lockedReason != null)
      Row(spacing: DySpacing.xs, children: [DyIcon(DyIcons.lock, size: DyIconSize.sm, color: c.textSecondary), Flexible(child: Text(lockedReason, style: dy.text(DyTextStyle.bodySm, tone: DyTextTone.secondary)))]),
    if (error != null)
      Row(spacing: DySpacing.xs, children: [DyIcon(DyIcons.alert, size: DyIconSize.sm, color: c.errorStrong), Flexible(child: Text(error, style: dy.text(DyTextStyle.caption, tone: DyTextTone.error).copyWith(fontWeight: FontWeight.w600)))]),
  ]);
}

String? _hint(String? description, String? lockedReason, String? error, DyComponentState state) {
  final p = [if (description != null) description, if (state == DyComponentState.locked && lockedReason != null) lockedReason, if (error != null) error];
  return p.isEmpty ? null : p.join('. ');
}

/// Onay kutusu. [value] null ise karışık durum (tristate). locked iken odaklanır, değişmez.
class DyCheckbox extends StatelessWidget {
  const DyCheckbox({super.key, required this.label, required this.value, this.onChanged, this.description, this.state = DyComponentState.enabled, this.lockedReason, this.error});
  final String label;

  /// true · false · null (karışık).
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final String? description;
  final DyComponentState state;
  final String? lockedReason;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final locked = state == DyComponentState.locked;
    final on = value != false;
    return DyPressable(
      onPressed: onChanged == null ? null : () => onChanged!(!(value ?? false)),
      state: state,
      lockedReason: lockedReason,
      button: false,
      checked: value ?? false,
      semanticLabel: label,
      semanticValue: value == null ? 'karışık' : null,
      borderRadius: BorderRadius.circular(DyRadius.xs),
      pressScale: 1,
      builder: (context, s) => Opacity(
        opacity: state == DyComponentState.disabled ? DyOpacity.disabled : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: DySpacing.xs),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: DySpacing.md, children: [
            Padding(
              padding: const EdgeInsets.only(top: DySpacing.xxs),
              child: AnimatedContainer(
                duration: dy.duration(DyDuration.fast),
                width: DySpacing.xl,
                height: DySpacing.xl,
                decoration: BoxDecoration(
                  color: on ? (locked ? c.textSecondary : c.primary) : (locked ? c.surfaceSunken : c.surface),
                  borderRadius: BorderRadius.circular(DyRadius.xs),
                  border: Border.all(color: on ? (locked ? c.textSecondary : c.primary) : (error != null ? c.error : locked ? c.border : c.borderStrong), width: DyBorderWidth.widthStrong),
                ),
                child: on ? Center(child: DyIcon(value == null ? DyIcons.minus : DyIcons.check, size: DyIconSize.sm, color: c.textOnPrimary)) : null,
              ),
            ),
            Flexible(child: ExcludeSemantics(child: _texts(context, label, description, lockedReason, error, state))),
          ]),
        ),
      ),
    ).withHint(_hint(description, lockedReason, error, state));
  }
}

extension on Widget {
  Widget withHint(String? hint) => hint == null ? this : Semantics(hint: hint, child: this);
}

@immutable
class DyRadioOption<T> {
  const DyRadioOption({required this.value, required this.label, this.description, this.enabled = true});
  final T value;
  final String label;
  final String? description;
  final bool enabled;
}

/// Tek seçimli seçenek grubu. Ok tuşları seçimi değiştirir.
class DyRadioGroup<T> extends StatelessWidget {
  const DyRadioGroup({super.key, required this.label, required this.options, required this.value, this.onChanged, this.description, this.error,
      this.state = DyComponentState.enabled, this.lockedReason, this.horizontal = false});
  final String label;
  final List<DyRadioOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String? description;
  final String? error;
  final DyComponentState state;
  final String? lockedReason;
  final bool horizontal;

  void _move(int dir) {
    if (state != DyComponentState.enabled || onChanged == null) return;
    final enabled = [for (final o in options) if (o.enabled) o];
    if (enabled.isEmpty) return;
    final i = enabled.indexWhere((o) => o.value == value);
    onChanged!(enabled[(i + dir + enabled.length) % enabled.length].value);
  }

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final items = [
      for (final o in options)
        DyPressable(
          onPressed: onChanged == null || !o.enabled ? null : () => onChanged!(o.value),
          state: !o.enabled || state == DyComponentState.disabled ? DyComponentState.disabled : state,
          lockedReason: lockedReason,
          button: false,
          checked: o.value == value,
          inMutuallyExclusiveGroup: true,
          semanticLabel: o.label,
          borderRadius: BorderRadius.circular(DyRadius.full),
          pressScale: 1,
          builder: (context, s) {
            final on = o.value == value;
            final locked = state == DyComponentState.locked;
            return Opacity(
              opacity: !o.enabled || state == DyComponentState.disabled ? DyOpacity.disabled : 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: DySpacing.xs),
                child: Row(mainAxisSize: horizontal ? MainAxisSize.min : MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, spacing: DySpacing.md, children: [
                  Padding(
                    padding: const EdgeInsets.only(top: DySpacing.xxs),
                    child: AnimatedContainer(
                      duration: dy.duration(DyDuration.fast),
                      width: DySpacing.xl,
                      height: DySpacing.xl,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: locked ? c.surfaceSunken : c.surface,
                        border: Border.all(
                          color: on ? (locked ? c.textSecondary : c.primary) : (error != null ? c.error : c.borderStrong),
                          width: on ? DySpacing.xs + DyBorderWidth.widthStrong : DyBorderWidth.widthStrong,
                        ),
                      ),
                    ),
                  ),
                  Flexible(child: ExcludeSemantics(child: _texts(context, o.label, o.description, null, null, DyComponentState.enabled))),
                ]),
              ),
            );
          },
        ),
    ];
    return Semantics(
      container: true,
      label: label,
      hint: _hint(description, lockedReason, error, state),
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowDown): () => _move(1),
          const SingleActivator(LogicalKeyboardKey.arrowRight): () => _move(1),
          const SingleActivator(LogicalKeyboardKey.arrowUp): () => _move(-1),
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _move(-1),
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, spacing: DySpacing.sm, children: [
          ExcludeSemantics(child: Text(label, style: dy.text(DyTextStyle.label, tone: DyTextTone.secondary))),
          if (horizontal) Wrap(spacing: DySpacing.xl, children: items) else Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: DySpacing.xs, children: items),
          ExcludeSemantics(child: _texts(context, '', description, lockedReason, error, state)),
        ]),
      ),
    );
  }
}

/// Anında geçerli açık/kapalı ayarı. Kaydet gerektiren seçimlerde [DyCheckbox] kullanılır.
class DySwitch extends StatelessWidget {
  const DySwitch({super.key, required this.label, required this.value, this.onChanged, this.description, this.state = DyComponentState.enabled, this.lockedReason});
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? description;

  /// loading: değişiklik sunucuya giderken (yeni konumda, etkileşim kapalı).
  final DyComponentState state;
  final String? lockedReason;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final locked = state == DyComponentState.locked;
    const trackW = DySize.targetComfortable;
    const trackH = DySpacing.xl + DySpacing.sm;
    const thumb = DySpacing.xl2;
    return DyPressable(
      onPressed: onChanged == null ? null : () => onChanged!(!value),
      state: state,
      lockedReason: lockedReason,
      button: false,
      toggled: value,
      semanticLabel: label,
      pressScale: 1,
      borderRadius: BorderRadius.circular(DyRadius.md),
      builder: (context, s) => Opacity(
        opacity: state == DyComponentState.disabled ? DyOpacity.disabled : 1,
        child: Row(spacing: DySpacing.lg, children: [
          Expanded(child: ExcludeSemantics(child: _texts(context, label, description, lockedReason, null, state))),
          AnimatedContainer(
            duration: dy.duration(DyDuration.normal),
            width: trackW,
            height: trackH,
            padding: const EdgeInsets.all(DySpacing.xxs),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DyRadius.full),
              color: locked ? (value ? c.textSecondary : c.surfaceSunken) : (value ? c.primary : c.borderStrong),
            ),
            child: AnimatedAlign(
              duration: dy.duration(DyDuration.normal),
              curve: DyEasing.emphasized,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: thumb,
                height: thumb,
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: c.surfaceElevated, boxShadow: dy.shadows.low),
                child: locked ? DyIcon(DyIcons.lock, size: DyIconSize.sm, color: c.textMuted) : null,
              ),
            ),
          ),
        ]),
      ),
    ).withHint(_hint(description, lockedReason, null, state));
  }
}

@immutable
class DySegment<T> {
  const DySegment({required this.value, required this.label, this.icon, this.enabled = true});
  final T value;
  final String label;
  final DyIconData? icon;
  final bool enabled;
}

/// 2–5 karşılıklı dışlayıcı görünüm arasında geçiş (Gün · Hafta · Ay). Ok tuşları seçimi değiştirir.
class DySegmentedControl<T> extends StatelessWidget {
  const DySegmentedControl({super.key, required this.label, required this.segments, required this.value, this.onChanged, this.state = DyComponentState.enabled});
  final String label;
  final List<DySegment<T>> segments;
  final T value;
  final ValueChanged<T>? onChanged;
  final DyComponentState state;

  void _move(int dir) {
    if (state != DyComponentState.enabled || onChanged == null) return;
    final enabled = [for (final s in segments) if (s.enabled) s];
    final i = enabled.indexWhere((s) => s.value == value);
    onChanged!(enabled[(i + dir + enabled.length) % enabled.length].value);
  }

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final index = segments.indexWhere((s) => s.value == value).clamp(0, segments.length - 1);
    return Semantics(
      container: true,
      label: label,
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowRight): () => _move(1),
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _move(-1),
        },
        child: Opacity(
          opacity: state == DyComponentState.disabled ? DyOpacity.disabled : 1,
          child: Container(
            padding: const EdgeInsets.all(DySpacing.xs),
            decoration: BoxDecoration(color: c.surfaceSecondary, borderRadius: BorderRadius.circular(DyRadius.md)),
            child: LayoutBuilder(builder: (context, box) {
              final w = box.maxWidth.isFinite ? box.maxWidth / segments.length : null;
              return Stack(children: [
                if (w != null)
                  AnimatedPositioned(
                    duration: dy.duration(DyDuration.normal),
                    curve: DyEasing.emphasized,
                    left: w * index,
                    width: w,
                    top: 0,
                    bottom: 0,
                    child: DecoratedBox(decoration: BoxDecoration(color: c.surfaceElevated, borderRadius: BorderRadius.circular(DyRadius.sm), boxShadow: dy.shadows.low)),
                  ),
                Row(children: [
                  for (final (i, s) in segments.indexed)
                    Expanded(
                      child: DyPressable(
                        onPressed: onChanged == null || !s.enabled ? null : () => onChanged!(s.value),
                        state: !s.enabled ? DyComponentState.disabled : state,
                        button: false,
                        selected: i == index,
                        inMutuallyExclusiveGroup: true,
                        semanticLabel: s.label,
                        pressScale: 1,
                        borderRadius: BorderRadius.circular(DyRadius.sm),
                        builder: (context, p) => Container(
                          constraints: const BoxConstraints(minHeight: DySize.controlMd),
                          padding: const EdgeInsets.symmetric(horizontal: DySpacing.md, vertical: DySpacing.xs),
                          alignment: Alignment.center,
                          child: Row(mainAxisSize: MainAxisSize.min, spacing: DySpacing.xs, children: [
                            if (s.icon != null) DyIcon(s.icon!, size: DyIconSize.sm, color: i == index ? c.textPrimary : c.textSecondary),
                            Flexible(child: Text(s.label, textAlign: TextAlign.center, style: dy.text(DyTextStyle.label, tone: i == index ? DyTextTone.primary : DyTextTone.secondary).copyWith(fontWeight: FontWeight.w700))),
                          ]),
                        ),
                      ),
                    ),
                ]),
              ]);
            }),
          ),
        ),
      ),
    );
  }
}
