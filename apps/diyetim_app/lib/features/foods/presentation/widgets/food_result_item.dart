import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/widgets.dart';

import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/entities/food_entity.dart';

/// Arama sonucu satırı: ad, (marka ·) porsiyon, makrolar ve porsiyon kalorisi.
class FoodResultItem extends StatelessWidget {
  const FoodResultItem({super.key, required this.food});
  final FoodSummaryEntity food;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s = food.defaultServing;
    String g(double v) => DyFormat.number(v);
    final serving = l10n.foodServingPer(s.description);
    return DyListItem(
      title: food.name,
      description: food.brand == null ? serving : '${food.brand} · $serving',
      meta: [
        Semantics(
          label: l10n.foodMacrosSemantic(g(s.carbohydrate), g(s.protein), g(s.fat)),
          excludeSemantics: true,
          child: DyText(l10n.foodMacros(g(s.carbohydrate), g(s.protein), g(s.fat)), style: DyTextStyle.caption, tone: DyTextTone.muted),
        ),
      ],
      trailing: DyNumber(s.calories, unit: l10n.unitKcal, fractionDigits: 0, tone: DyTextTone.secondary),
    );
  }
}
