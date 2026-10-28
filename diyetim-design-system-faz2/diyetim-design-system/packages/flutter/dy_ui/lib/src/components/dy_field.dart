import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../primitives/dy_icon.dart';
import '../primitives/dy_pressable.dart';
import '../theme/dy_context.dart';
import '../utils/dy_format.dart';
import 'dy_button.dart';

/// Form alanlarının ortak kabuğu: görünür etiket, açıklama, kilit nedeni ve hata/başarı mesajı.
/// Hata metni ne olduğunu ve nasıl düzeltileceğini söylemeli; canlı bölge olarak duyurulur.
class DyFieldShell extends StatelessWidget {
  const DyFieldShell({
    super.key,
    required this.label,
    required this.child,
    this.hideLabel = false,
    this.description,
    this.error,
    this.success,
    this.state = DyComponentState.enabled,
    this.lockedReason,
    this.required = false,
  });

  final String label;
  final Widget child;
  final bool hideLabel;
  final String? description;
  final String? error;
  final String? success;
  final DyComponentState state;
  final String? lockedReason;
  final bool required;

  DyValidationState get validation => error != null ? DyValidationState.error : success != null ? DyValidationState.success : DyValidationState.none;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final help = dy.text(DyTextStyle.caption, tone: DyTextTone.muted);
    Widget line(DyIconData icon, String text, Color color, {bool live = false}) => Semantics(
          liveRegion: live,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: DySpacing.xs, children: [
            Padding(padding: const EdgeInsets.only(top: DySpacing.xxs / 2), child: DyIcon(icon, size: DyIconSize.sm, color: color)),
            Expanded(child: Text(text, style: help.copyWith(color: color, fontWeight: live ? FontWeight.w600 : null))),
          ]),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: DySpacing.sm,
      children: [
        if (!hideLabel)
          ExcludeSemantics(
            child: Text.rich(
              TextSpan(text: label, children: [if (required) TextSpan(text: ' *', style: TextStyle(color: c.errorStrong))]),
              style: dy.text(DyTextStyle.label, tone: DyTextTone.secondary),
            ),
          ),
        child,
        if (description != null) Text(description!, style: help),
        if (state == DyComponentState.locked && lockedReason != null) line(DyIcons.lock, lockedReason!, c.textSecondary),
        if (error != null) line(DyIcons.alert, error!, c.errorStrong, live: true),
        if (error == null && success != null) line(DyIcons.checkCircle, success!, c.successStrong, live: true),
      ],
    );
  }

  /// Alanın ekran okuyucu ipucu: açıklama, kilit nedeni ve hata birlikte okunur.
  String? get semanticHint {
    final parts = [
      if (description != null) description!,
      if (state == DyComponentState.locked && lockedReason != null) lockedReason!,
      if (error != null) error!,
      if (error == null && success != null) success!,
    ];
    return parts.isEmpty ? null : parts.join('. ');
  }
}

/// Giriş çerçevesi: zemin, odak kenarı + hale, hata kenarı, kilitli zemin, yükleme çizgisi.
class DyInputFrame extends StatelessWidget {
  const DyInputFrame({super.key, required this.focused, required this.state, required this.invalid, required this.child, this.leading, this.trailing, this.minHeight = DySize.controlLg, this.multiline = false});
  final bool focused;
  final DyComponentState state;
  final bool invalid;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final double minHeight;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final locked = state == DyComponentState.locked;
    final bg = locked ? c.surfaceSunken : (focused || invalid) ? c.surface : c.surfaceSecondary;
    // Kilitli alan çerçeveyi kilitli butonla aynı ince kenarla korur: dark temada surface-sunken zeminle aynıdır.
    final border = invalid ? c.error : focused ? c.focusRing : locked ? c.borderSubtle : const Color(0x00000000);
    return Opacity(
      opacity: state == DyComponentState.disabled ? DyOpacity.disabled : 1,
      child: AnimatedContainer(
        duration: dy.duration(DyDuration.fast),
        curve: DyEasing.standard,
        constraints: BoxConstraints(minHeight: minHeight),
        // Tek satırda dikey boşluk yok: metin alanı çerçevenin tüm yüksekliğini kaplar (dokunma ve semantik alanı = çerçeve).
        padding: EdgeInsets.symmetric(horizontal: DySpacing.lg, vertical: multiline ? DySpacing.sm : 0),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(DyRadius.md),
          border: Border.all(color: border, width: DyBorderWidth.widthStrong),
          boxShadow: focused && !invalid ? [BoxShadow(color: c.primarySubtle, spreadRadius: DySpacing.xs)] : null,
        ),
        child: Stack(children: [
          Row(
            crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            spacing: DySpacing.md,
            children: [
              if (locked) DyIcon(DyIcons.lock, size: DyIconSize.sm, color: c.textMuted) else if (leading != null) IconTheme.merge(data: IconThemeData(color: c.textMuted), child: leading!),
              Expanded(child: child),
              if (trailing != null) trailing!,
            ],
          ),
          if (state == DyComponentState.loading)
            Positioned(left: 0, right: 0, bottom: -DySpacing.xs + DySpacing.xxs, child: DyProgressSweep(color: c.primary, width: double.infinity, height: DySpacing.xxs)),
        ]),
      ),
    );
  }
}

/// Tek satırlık metin alanı.
class DyTextField extends StatefulWidget {
  const DyTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.description,
    this.error,
    this.success,
    this.state = DyComponentState.enabled,
    this.lockedReason,
    this.required = false,
    this.hideLabel = false,
    this.leading,
    this.suffix,
    this.trailing,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.obscureText = false,
    this.autofillHints,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final String? description;
  final String? error;
  final String? success;
  final DyComponentState state;
  final String? lockedReason;
  final bool required;
  final bool hideLabel;
  final DyIconData? leading;

  /// Birim (kg, g).
  final String? suffix;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  @override
  State<DyTextField> createState() => _DyTextFieldState();
}

class _DyTextFieldState extends State<DyTextField> {
  /// Tek satırlı alanın çerçeveyi (controlLg) kenarlık içinde tam dolduracağı dikey boşluk: (52 − 2 × 1,5 − body satırı) / 2.
  static final double _singleLinePadding = () {
    final body = DyTypeScale.compact(DyTextStyle.body);
    return (DySize.controlLg - 2 * DyBorderWidth.widthStrong - body.fontSize! * body.height!) / 2;
  }();

  late final TextEditingController _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
  late final FocusNode _focus = widget.focusNode ?? FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
    _controller.addListener(_onText);
  }

  void _onFocus() => setState(() => _focused = _focus.hasFocus);
  void _onText() => setState(() {});

  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    _controller.removeListener(_onText);
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final c = dy.colors;
    final shell = DyFieldShell(
      label: widget.label,
      hideLabel: widget.hideLabel,
      description: widget.description,
      error: widget.error,
      success: widget.success,
      state: widget.state,
      lockedReason: widget.lockedReason,
      required: widget.required,
      child: const SizedBox.shrink(),
    );
    final editable = widget.state == DyComponentState.enabled;
    final multiline = (widget.maxLines ?? 2) > 1;
    final field = TextField(
      controller: _controller,
      focusNode: _focus,
      enabled: widget.state != DyComponentState.disabled,
      readOnly: !editable,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType ?? (multiline ? TextInputType.multiline : null),
      textInputAction: widget.textInputAction,
      inputFormatters: [...?widget.inputFormatters, if (widget.maxLength != null) LengthLimitingTextInputFormatter(widget.maxLength)],
      obscureText: widget.obscureText,
      autofillHints: widget.autofillHints,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      style: dy.text(DyTextStyle.body, tone: editable ? DyTextTone.primary : DyTextTone.secondary),
      cursorColor: c.primary,
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: multiline ? DySpacing.sm : _singleLinePadding),
        hintText: widget.placeholder,
        hintStyle: dy.text(DyTextStyle.body, tone: DyTextTone.muted),
      ),
    );
    final count = widget.maxLength == null
        ? null
        : Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text('${DyFormat.number(_controller.text.length)} / ${DyFormat.number(widget.maxLength!)}',
                style: dy.text(DyTextStyle.caption, tone: DyTextTone.muted).copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: _controller.text.length >= widget.maxLength! * 0.9 ? c.warningStrong : null,
                )),
          );
    // Görünür etiket ExcludeSemantics; ad, ipucu ve alan tek düğümde birleşir. Sondaki butonlar ayrı odaklanır.
    final labelled = MergeSemantics(child: Semantics(label: widget.label, hint: shell.semanticHint, readOnly: !editable, child: field));
    final frame = DyInputFrame(
        focused: _focused && editable,
        state: widget.state,
        invalid: widget.error != null,
        multiline: multiline,
        leading: widget.leading == null ? null : DyIcon(widget.leading!, color: c.textMuted),
        trailing: Row(mainAxisSize: MainAxisSize.min, spacing: DySpacing.sm, children: [
          if (widget.suffix != null) Text(widget.suffix!, style: dy.text(DyTextStyle.body, tone: DyTextTone.muted).copyWith(fontWeight: FontWeight.w600)),
          if (widget.trailing != null) widget.trailing!,
        ]),
        child: multiline && count != null ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [labelled, count]) : labelled,
    );
    return DyFieldShell(
        label: widget.label,
        hideLabel: widget.hideLabel,
        description: widget.description,
        error: widget.error,
        success: widget.success,
        state: widget.state,
        lockedReason: widget.lockedReason,
        required: widget.required,
        child: frame,
    );
  }
}

/// Arama alanı: Escape ve temizle butonu değeri siler.
class DySearchField extends StatefulWidget {
  const DySearchField({super.key, required this.label, this.onChanged, this.onSubmitted, this.placeholder, this.hideLabel = true, this.state = DyComponentState.enabled, this.clearLabel = 'Aramayı temizle', this.controller});
  final String label;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final bool hideLabel;
  final DyComponentState state;
  final String clearLabel;
  final TextEditingController? controller;

  @override
  State<DySearchField> createState() => _DySearchFieldState();
}

class _DySearchFieldState extends State<DySearchField> {
  late final TextEditingController _c = widget.controller ?? TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    if (widget.controller == null) _c.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _clear() {
    _c.clear();
    widget.onChanged?.call('');
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): () { if (_c.text.isNotEmpty) _clear(); }},
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _c,
        builder: (context, v, _) => DyTextField(
          label: widget.label,
          hideLabel: widget.hideLabel,
          controller: _c,
          focusNode: _focus,
          placeholder: widget.placeholder,
          state: widget.state,
          leading: DyIcons.search,
          textInputAction: TextInputAction.search,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          trailing: v.text.isEmpty || widget.state != DyComponentState.enabled
              ? null
              : DyIconButton(icon: DyIcons.x, label: widget.clearLabel, onPressed: _clear),
        ),
      ),
    );
  }
}

/// Türkçe ondalık (virgül) kabul eden sayı alanı. Ok tuşları ve − / + adımlar; sınır dışına adımlamaz.
/// Ekran okuyucuda ayarlanabilir değer olarak sunulur (artır / azalt hareketleri).
class DyNumberField extends StatefulWidget {
  const DyNumberField({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.min,
    this.max,
    this.step = 1,
    this.fractionDigits = 1,
    this.unit,
    this.stepper = true,
    this.description,
    this.error,
    this.state = DyComponentState.enabled,
    this.lockedReason,
    this.required = false,
  });

  final String label;
  final double? value;
  final ValueChanged<double?>? onChanged;
  final double? min;
  final double? max;
  final double step;
  final int fractionDigits;
  final String? unit;
  final bool stepper;
  final String? description;
  final String? error;
  final DyComponentState state;
  final String? lockedReason;
  final bool required;

  @override
  State<DyNumberField> createState() => _DyNumberFieldState();
}

class _DyNumberFieldState extends State<DyNumberField> {
  late final TextEditingController _c = TextEditingController(text: _fmt(widget.value));
  final _focus = FocusNode();

  String _fmt(double? v) => v == null ? '' : DyFormat.number(v, maxFractionDigits: widget.fractionDigits).replaceAll('.', '');

  @override
  void didUpdateWidget(DyNumberField old) {
    super.didUpdateWidget(old);
    if (widget.value != DyFormat.parse(_c.text)) _c.text = _fmt(widget.value);
  }

  @override
  void dispose() {
    _c.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool get _editable => widget.state == DyComponentState.enabled;
  bool get _atMin => widget.value != null && widget.min != null && widget.value! <= widget.min!;
  bool get _atMax => widget.value != null && widget.max != null && widget.value! >= widget.max!;

  void _stepBy(int dir) {
    if (!_editable) return;
    final next = ((widget.value ?? widget.min ?? 0) + dir * widget.step).clamp(widget.min ?? double.negativeInfinity, widget.max ?? double.infinity).toDouble();
    _c.text = _fmt(next);
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.unit == null ? '' : ' ${widget.unit}';
    final valueText = widget.value == null ? '' : '${_fmt(widget.value)}$u';
    return Semantics(
      value: valueText,
      increasedValue: _editable && !_atMax ? '${_fmt(((widget.value ?? 0) + widget.step).clamp(widget.min ?? double.negativeInfinity, widget.max ?? double.infinity).toDouble())}$u' : null,
      decreasedValue: _editable && !_atMin ? '${_fmt(((widget.value ?? 0) - widget.step).clamp(widget.min ?? double.negativeInfinity, widget.max ?? double.infinity).toDouble())}$u' : null,
      onIncrease: _editable && !_atMax ? () => _stepBy(1) : null,
      onDecrease: _editable && !_atMin ? () => _stepBy(-1) : null,
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowUp): () => _stepBy(1),
          const SingleActivator(LogicalKeyboardKey.arrowDown): () => _stepBy(-1),
        },
        child: DyTextField(
          label: widget.label,
          controller: _c,
          focusNode: _focus,
          description: widget.description,
          error: widget.error,
          state: widget.state,
          lockedReason: widget.lockedReason,
          required: widget.required,
          suffix: widget.unit,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[-\d.,\s]'))],
          onChanged: (raw) => widget.onChanged?.call(DyFormat.parse(raw)),
          trailing: widget.stepper
              ? Row(mainAxisSize: MainAxisSize.min, spacing: DySpacing.xs, children: [
                  _StepButton(icon: DyIcons.minus, label: '${DyFormat.number(widget.step)}$u azalt', enabled: _editable && !_atMin, onTap: () => _stepBy(-1)),
                  _StepButton(icon: DyIcons.plus, label: '${DyFormat.number(widget.step)}$u artır', enabled: _editable && !_atMax, onTap: () => _stepBy(1)),
                ])
              : null,
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.label, required this.enabled, required this.onTap});
  final DyIconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    return DyPressable(
      onPressed: onTap,
      state: enabled ? DyComponentState.enabled : DyComponentState.disabled,
      semanticLabel: label,
      borderRadius: BorderRadius.circular(DyRadius.sm),
      builder: (context, s) => Opacity(
        opacity: enabled ? 1 : DyOpacity.disabled,
        child: Container(
          width: DySize.controlSm,
          height: DySize.controlSm,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: dy.colors.surface, borderRadius: BorderRadius.circular(DyRadius.sm), boxShadow: enabled ? dy.shadows.low : null),
          child: DyIcon(icon, size: DyIconSize.sm, color: dy.colors.textPrimary),
        ),
      ),
    );
  }
}

/// Çok satırlı metin (diyetisyen notu, öğün notu). maxLength verilirse sayaç gösterilir.
class DyTextarea extends StatelessWidget {
  const DyTextarea({super.key, required this.label, this.controller, this.initialValue, this.onChanged, this.placeholder, this.description, this.error,
      this.state = DyComponentState.enabled, this.lockedReason, this.minLines = 3, this.maxLines = 10, this.maxLength});
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final String? description;
  final String? error;
  final DyComponentState state;
  final String? lockedReason;
  final int minLines;
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) => DyTextField(
        label: label,
        controller: controller,
        initialValue: initialValue,
        onChanged: onChanged,
        placeholder: placeholder,
        description: description,
        error: error,
        state: state,
        lockedReason: lockedReason,
        minLines: minLines,
        maxLines: maxLines,
        maxLength: maxLength,
      );
}
