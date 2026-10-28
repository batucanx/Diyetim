import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/widgets.dart';

import '../../../../helpers/url/url_helper.dart';
import '../../../../infrastructure/di/injection.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/entities/food_entity.dart';

/// Sağlayıcı atfı (FatSecret Basic koşulu). Metin API'den gelir; istemcide sağlayıcı adı yazılmaz.
class AttributionFooter extends StatelessWidget {
  const AttributionFooter({super.key, required this.attribution});
  final AttributionEntity attribution;

  @override
  Widget build(BuildContext context) {
    final url = attribution.url;
    final text = DyText(attribution.text, style: DyTextStyle.caption, tone: url == null ? DyTextTone.muted : DyTextTone.link);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DySpacing.lg),
      child: Center(
        child: url == null
            ? text
            // Bağlantı rolü ile ad aynı düğümde olmalı; yoksa ekran okuyucu "bağlantı" demez.
            : MergeSemantics(
                child: Semantics(
                  link: true,
                  child: DyPressable(
                    button: false,
                    semanticLabel: AppLocalizations.of(context).attributionOpen(attribution.text),
                    onPressed: () => sl<UrlHelper>().openExternal(url),
                    borderRadius: BorderRadius.circular(DyRadius.xs),
                    builder: (_, _) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: DySpacing.sm),
                      child: text,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
