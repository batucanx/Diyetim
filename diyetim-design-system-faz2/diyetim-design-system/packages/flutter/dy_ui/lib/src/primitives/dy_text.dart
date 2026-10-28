import 'package:dy_tokens/dy_tokens.dart';
import 'package:flutter/widgets.dart';

import '../theme/dy_context.dart';

/// Tüm metinlerin tek kapısı. Serbest font boyutu veya renk kabul etmez.
/// Başlık stilleri (display–h4) ekran okuyucuya başlık olarak bildirilir.
class DyText extends StatelessWidget {
  const DyText(this.text, {super.key, this.style = DyTextStyle.body, this.tone = DyTextTone.primary, this.maxLines, this.textAlign, this.semanticsLabel});

  final String text;
  final DyTextStyle style;
  final DyTextTone tone;

  /// Satır sınırı; aşan metin üç noktayla kesilir. null: sınırsız (varsayılan; büyük metinde kırpma yok).
  final int? maxLines;
  final TextAlign? textAlign;
  final String? semanticsLabel;

  static const _headings = {DyTextStyle.display, DyTextStyle.h1, DyTextStyle.h2, DyTextStyle.h3, DyTextStyle.h4};

  @override
  Widget build(BuildContext context) {
    final t = Text(
      text,
      style: context.dy.text(style, tone: tone),
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.visible : TextOverflow.ellipsis,
      textAlign: textAlign,
      semanticsLabel: semanticsLabel,
    );
    return _headings.contains(style) ? Semantics(header: true, child: t) : t;
  }
}
