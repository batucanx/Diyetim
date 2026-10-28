import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/widgets.dart';

/// Ekran içi bölüm başlığı (ekran okuyucu başlık olarak okur; DyText h3 header semantiği taşır).
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: DySpacing.xl2, bottom: DySpacing.md),
        child: DyText(text, style: DyTextStyle.h3),
      );
}
