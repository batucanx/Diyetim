import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/material.dart';

import '../primitives/dy_icon.dart';
import '../primitives/dy_pressable.dart';
import '../theme/dy_context.dart';
import 'dy_button.dart';
import 'dy_field.dart';

@immutable
class DySelectOption<T> {
  const DySelectOption({required this.value, required this.label, this.description, this.enabled = true});
  final T value;
  final String label;
  final String? description;
  final bool enabled;
}

/// Seçim alanı. Mobilde seçenekler alttan açılan sayfada listelenir (React'te açılır liste;
/// sözleşme — seçenekler, değer, durumlar — iki platformda aynıdır).
class DySelect<T> extends StatelessWidget {
  const DySelect({super.key, required this.label, required this.options, required this.value, this.onChanged, this.placeholder = 'Seçin',
      this.description, this.error, this.state = DyComponentState.enabled, this.lockedReason, this.required = false, this.emptyText = 'Seçenek yok'});

  final String label;
  final List<DySelectOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String placeholder;
  final String? description;
  final String? error;
  final DyComponentState state;
  final String? lockedReason;
  final bool required;
  final String emptyText;

  Future<void> _open(BuildContext context) async {
    final picked = await showModalBottomSheet<T>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: context.dy.colors.surfaceElevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(DyRadius.xl2))),
      builder: (context) => _OptionSheet<T>(title: label, options: options, selected: {if (value != null) value as T}, multiple: false, emptyText: emptyText),
    );
    if (picked != null) onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final selected = options.where((o) => o.value == value).firstOrNull;
    return _SelectTrigger(
      label: label,
      display: selected?.label,
      placeholder: placeholder,
      description: description,
      error: error,
      state: state,
      lockedReason: lockedReason,
      required: required,
      onTap: () => _open(context),
    );
  }
}

/// Çoklu seçim. Alttan açılan sayfada seçimler değiştirilir, "Tamam" ile onaylanır.
class DyMultiSelect<T> extends StatelessWidget {
  const DyMultiSelect({super.key, required this.label, required this.options, required this.values, this.onChanged, this.placeholder = 'Seçin',
      this.description, this.error, this.state = DyComponentState.enabled, this.lockedReason, this.emptyText = 'Seçenek yok', this.confirmLabel = 'Tamam'});

  final String label;
  final List<DySelectOption<T>> options;
  final Set<T> values;
  final ValueChanged<Set<T>>? onChanged;
  final String placeholder;
  final String? description;
  final String? error;
  final DyComponentState state;
  final String? lockedReason;
  final String emptyText;
  final String confirmLabel;

  String? get _summary {
    final sel = options.where((o) => values.contains(o.value)).toList();
    if (sel.isEmpty) return null;
    return sel.length <= 2 ? sel.map((o) => o.label).join(', ') : '${sel.length} seçili';
  }

  Future<void> _open(BuildContext context) async {
    final picked = await showModalBottomSheet<Set<T>>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: context.dy.colors.surfaceElevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(DyRadius.xl2))),
      builder: (context) => _OptionSheet<T>(title: label, options: options, selected: values, multiple: true, emptyText: emptyText, confirmLabel: confirmLabel),
    );
    if (picked != null) onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) => _SelectTrigger(
        label: label,
        display: _summary,
        placeholder: placeholder,
        description: description,
        error: error,
        state: state,
        lockedReason: lockedReason,
        required: false,
        onTap: () => _open(context),
      );
}

class _SelectTrigger extends StatelessWidget {
  const _SelectTrigger({required this.label, required this.display, required this.placeholder, required this.description, required this.error,
      required this.state, required this.lockedReason, required this.required, required this.onTap});
  final String label;
  final String? display;
  final String placeholder;
  final String? description;
  final String? error;
  final DyComponentState state;
  final String? lockedReason;
  final bool required;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final shell = DyFieldShell(label: label, description: description, error: error, state: state, lockedReason: lockedReason, required: required, child: const SizedBox.shrink());
    return DyFieldShell(
      label: label,
      description: description,
      error: error,
      state: state,
      lockedReason: lockedReason,
      required: required,
      child: Semantics(
        hint: shell.semanticHint,
        child: DyPressable(
          onPressed: onTap,
          state: state,
          lockedReason: lockedReason,
          semanticLabel: label,
          semanticValue: display ?? placeholder,
          pressScale: 1,
          borderRadius: BorderRadius.circular(DyRadius.md),
          builder: (context, s) => DyInputFrame(
            focused: false,
            state: state,
            invalid: error != null,
            trailing: DyIcon(DyIcons.chevronDown, size: DyIconSize.sm, color: dy.colors.textMuted),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: DySpacing.sm),
              child: Text(display ?? placeholder, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: dy.text(DyTextStyle.body, tone: display == null ? DyTextTone.muted : state == DyComponentState.locked ? DyTextTone.secondary : DyTextTone.primary)),
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionSheet<T> extends StatefulWidget {
  const _OptionSheet({required this.title, required this.options, required this.selected, required this.multiple, required this.emptyText, this.confirmLabel = 'Tamam'});
  final String title;
  final List<DySelectOption<T>> options;
  final Set<T> selected;
  final bool multiple;
  final String emptyText;
  final String confirmLabel;

  @override
  State<_OptionSheet<T>> createState() => _OptionSheetState<T>();
}

class _OptionSheetState<T> extends State<_OptionSheet<T>> {
  late final Set<T> _sel = {...widget.selected};

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(DySpacing.xl, 0, DySpacing.xl, DySpacing.xl),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, spacing: DySpacing.md, children: [
          Text(widget.title, style: dy.text(DyTextStyle.h3)),
          if (widget.options.isEmpty) Padding(padding: const EdgeInsets.all(DySpacing.md), child: Text(widget.emptyText, style: dy.text(DyTextStyle.bodySm, tone: DyTextTone.muted))),
          Flexible(
            child: ListView(shrinkWrap: true, children: [
              for (final o in widget.options)
                DyPressable(
                  onPressed: () {
                    if (!widget.multiple) {
                      Navigator.of(context).pop(o.value);
                      return;
                    }
                    setState(() => _sel.contains(o.value) ? _sel.remove(o.value) : _sel.add(o.value));
                  },
                  state: o.enabled ? DyComponentState.enabled : DyComponentState.disabled,
                  button: false,
                  selected: _sel.contains(o.value),
                  checked: widget.multiple ? _sel.contains(o.value) : null,
                  inMutuallyExclusiveGroup: widget.multiple ? null : true,
                  semanticLabel: o.label,
                  pressScale: 1,
                  borderRadius: BorderRadius.circular(DyRadius.sm),
                  builder: (context, s) => Opacity(
                    opacity: o.enabled ? 1 : DyOpacity.disabled,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: DySize.targetComfortable),
                      padding: const EdgeInsets.symmetric(horizontal: DySpacing.md, vertical: DySpacing.sm),
                      decoration: BoxDecoration(color: s.hovered ? c.surfaceSecondary : null, borderRadius: BorderRadius.circular(DyRadius.sm)),
                      child: Row(spacing: DySpacing.md, children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                            Text(o.label, style: dy.text(DyTextStyle.body).copyWith(fontWeight: _sel.contains(o.value) ? FontWeight.w600 : null)),
                            if (o.description != null) Text(o.description!, style: dy.text(DyTextStyle.caption, tone: DyTextTone.muted)),
                          ]),
                        ),
                        if (_sel.contains(o.value)) DyIcon(DyIcons.check, size: DyIconSize.md, color: c.primary),
                      ]),
                    ),
                  ),
                ),
            ]),
          ),
          if (widget.multiple) DyButton(label: widget.confirmLabel, size: DyButtonSize.lg, fullWidth: true, onPressed: () => Navigator.of(context).pop(_sel)),
        ]),
      ),
    );
  }
}
