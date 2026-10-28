import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/widgets.dart';

import '../theme/dy_context.dart';
import '../utils/dy_format.dart';
import 'dy_icon.dart';

enum DyNumberFormat { decimal, percent }

/// Sayıları Türkçe biçimde, eşit genişlikli rakamlarla ve birimiyle gösterir.
/// [visibility] hidden ise değer gösterilmez ("Gizli"); bu durumda değer API'den zaten gelmez.
class DyNumber extends StatelessWidget {
  const DyNumber(this.value, {super.key, this.unit, this.style = DyTextStyle.numericSm, this.tone = DyTextTone.primary, this.fractionDigits = 1,
      this.format = DyNumberFormat.decimal, this.label, this.visibility = DyVisibility.visible, this.emptyLabel = '—'});

  final num? value;
  final String? unit;
  final DyTextStyle style;
  final DyTextTone tone;
  final int fractionDigits;
  final DyNumberFormat format;

  /// Ekran okuyucu bağlamı (ör. "Kalan kalori"); değerden önce okunur.
  final String? label;
  final DyVisibility visibility;
  final String emptyLabel;

  String get formatted {
    final v = value;
    if (v == null) return emptyLabel;
    return format == DyNumberFormat.percent ? DyFormat.percent(v) : DyFormat.number(v, maxFractionDigits: fractionDigits);
  }

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final base = dy.text(style, tone: tone);
    final prefix = label == null ? '' : '$label: ';
    if (visibility == DyVisibility.hidden) {
      final muted = dy.text(DyTextStyle.label, tone: DyTextTone.muted);
      return Semantics(
        label: '${prefix}Gizli',
        excludeSemantics: true,
        child: Row(mainAxisSize: MainAxisSize.min, spacing: DySpacing.xs, children: [
          DyIcon(DyIcons.eyeOff, size: DyIconSize.sm, color: muted.color),
          Text('Gizli', style: muted),
        ]),
      );
    }
    if (value == null) {
      return Semantics(label: '${prefix}değer yok', excludeSemantics: true, child: Text(emptyLabel, style: base.copyWith(color: dy.colors.textMuted)));
    }
    final unitStyle = base.copyWith(fontSize: (base.fontSize ?? 14) * 0.55, fontWeight: FontWeight.w600, color: dy.colors.textMuted, letterSpacing: 0);
    final text = formatted;
    return Semantics(
      label: '$prefix$text${unit == null ? '' : ' $unit'}',
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(text: text, style: base, children: [if (unit != null) TextSpan(text: '${DyFormat.nbsp}$unit', style: unitStyle)]),
        softWrap: false,
      ),
    );
  }
}
