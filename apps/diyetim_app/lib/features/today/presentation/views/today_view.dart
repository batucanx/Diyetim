import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../../shared/error_kind.dart';
import '../../../../shared/section_title.dart';
import '../providers/get_today_provider.dart';
import '../widgets/dietitian_note_card.dart';
import '../widgets/meal_list.dart';

class TodayView extends ConsumerWidget {
  const TodayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dy = context.dy;
    final l10n = AppLocalizations.of(context);
    final today = ref.watch(getTodayProvider);

    final Widget body = switch (today) {
      AsyncValue(:final value?) => ListView(
          padding: const EdgeInsets.fromLTRB(DySpacing.lg, DySpacing.sm, DySpacing.lg, DySpacing.xl3),
          children: [
            // Karar 0002: önce diyetisyen notu (yoksa bölüm yok), sonra öğünler.
            if (value.dietitianNote case final note?) ...[
              SectionTitle(l10n.dietitianNoteTitle),
              DietitianNoteCard(note: note),
            ],
            SectionTitle(l10n.mealsTitle),
            MealList(meals: value.meals),
          ],
        ),
      AsyncError(:final error) => Center(
          child: Padding(
            padding: const EdgeInsets.all(DySpacing.lg),
            child: DyErrorState(kind: errorKindOf(error), actionLabel: l10n.retry, onAction: () => ref.read(getTodayProvider.notifier).refresh()),
          ),
        ),
      _ => DyLoadingRegion(loading: true, label: l10n.todayLoadingLabel, skeleton: const _TodaySkeleton(), child: const SizedBox.shrink()),
    };

    return Scaffold(
      backgroundColor: dy.colors.background,
      appBar: DyAppBar(
        title: l10n.todayTitle,
        // large: Scaffold.appBar yuvasında metin ölçeğiyle büyüyemez (dy_ui Navigation.md); kayan büyük başlık gelene kadar standart çubuk.
        actions: [DyIconButton(icon: DyIcons.search, label: l10n.todaySearchFoods, onPressed: () => context.push(Paths.foodSearch))],
      ),
      body: SafeArea(top: false, child: body),
    );
  }
}

/// Gerçek içerikle aynı yerleşim: bölüm başlığı + not kartı + öğün kartı (yükleme bitince kayma olmaz).
class _TodaySkeleton extends StatelessWidget {
  const _TodaySkeleton();

  @override
  Widget build(BuildContext context) => ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(DySpacing.lg, DySpacing.sm, DySpacing.lg, DySpacing.xl3),
        children: const [
          _SkeletonTitle(),
          DyCard(
            variant: DyCardVariant.raised,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: DySpacing.md, children: [
              Row(spacing: DySpacing.md, children: [
                DySkeleton(shape: DySkeletonShape.circle, width: DySize.targetMin),
                Expanded(child: DySkeleton(shape: DySkeletonShape.text, lines: 2)),
              ]),
              DySkeleton(shape: DySkeletonShape.text, lines: 4),
            ]),
          ),
          _SkeletonTitle(),
          DyCard(child: Column(spacing: DySpacing.xl, children: [
            DySkeleton(shape: DySkeletonShape.text, lines: 3),
            DySkeleton(shape: DySkeletonShape.text, lines: 3),
            DySkeleton(shape: DySkeletonShape.text, lines: 3),
          ])),
        ],
      );
}

class _SkeletonTitle extends StatelessWidget {
  const _SkeletonTitle();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.only(top: DySpacing.xl2, bottom: DySpacing.md),
        child: DySkeleton(shape: DySkeletonShape.rect, width: DySpacing.xl8 + DySpacing.xl3, height: DySpacing.xl2, radius: DyRadius.xs),
      );
}
