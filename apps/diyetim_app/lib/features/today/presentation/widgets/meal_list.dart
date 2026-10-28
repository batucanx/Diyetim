import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/widgets.dart';

import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/entities/today_entity.dart';

/// Günün öğünleri. Durum `meta`'da (başlığı sıkıştırmaz), kalori `trailing`'de; gizli kalori "Gizli" okunur.
class MealList extends StatelessWidget {
  const MealList({super.key, required this.meals});
  final List<MealEntity> meals;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (meals.isEmpty) {
      return DyEmptyState(title: l10n.mealsEmptyTitle, description: l10n.mealsEmptyDescription, icon: DyIcons.plan, compact: true);
    }
    return DyCard(
      child: DyList(children: [
        for (final m in meals)
          DyListItem(
            key: ValueKey(m.id),
            title: m.name,
            description: m.items.map((i) => i.name).join(', '),
            meta: [
              DyStatusTag(m.status.style),
              if (m.time != null) DyText(m.time!, style: DyTextStyle.caption, tone: DyTextTone.muted),
            ],
            trailing: DyNumber(
              m.calories,
              unit: l10n.unitKcal,
              fractionDigits: 0,
              label: l10n.mealCaloriesLabel(m.name),
              visibility: m.caloriesVisibility,
              tone: DyTextTone.secondary,
            ),
          ),
      ]),
    );
  }
}
