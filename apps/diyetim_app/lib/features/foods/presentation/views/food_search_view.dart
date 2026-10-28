import 'dart:async';

import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../helpers/http/exceptions/api_exception.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../../shared/error_kind.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/usecases/search_foods.dart';
import '../providers/search_foods_provider.dart';
import '../widgets/attribution_footer.dart';
import '../widgets/food_result_item.dart';

class FoodSearchView extends ConsumerStatefulWidget {
  const FoodSearchView({super.key});

  /// Yazma durduktan sonra istek: her tuşta backend'e (ve FatSecret kotasına) gitmemek için.
  static const debounce = Duration(milliseconds: 300);

  @override
  ConsumerState<FoodSearchView> createState() => _FoodSearchViewState();
}

class _FoodSearchViewState extends ConsumerState<FoodSearchView> {
  Timer? _debounce;

  void _onChanged(String raw) {
    _debounce?.cancel();
    _debounce = Timer(FoodSearchView.debounce, () => ref.read(foodSearchQueryProvider.notifier).set(raw));
  }

  void _onSubmitted(String raw) {
    _debounce?.cancel();
    ref.read(foodSearchQueryProvider.notifier).set(raw);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: dy.colors.background,
      appBar: DyAppBar(title: l10n.foodSearchTitle, onBack: () => context.pop()),
      body: SafeArea(
        top: false,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(DySpacing.lg, DySpacing.md, DySpacing.lg, DySpacing.sm),
            child: DySearchField(label: l10n.foodSearchFieldLabel, placeholder: l10n.foodSearchPlaceholder, onChanged: _onChanged, onSubmitted: _onSubmitted),
          ),
          const Expanded(child: _Results()),
        ]),
      ),
    );
  }
}

class _Results extends ConsumerStatefulWidget {
  const _Results();

  @override
  ConsumerState<_Results> createState() => _ResultsState();
}

class _ResultsState extends ConsumerState<_Results> {
  /// Yeni arama yüklenirken gösterilen son sonuç (ekran iskelete dönüp titremez).
  FoodSearchPageEntity? _last;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(foodSearchQueryProvider);

    if (query.length < SearchFoodsUsecase.minQueryLength) {
      _last = null;
      return _Padded(DyEmptyState(title: l10n.foodSearchHintTitle, description: l10n.foodSearchHint, icon: DyIcons.search, compact: true));
    }

    final results = ref.watch(searchFoodsProvider(query));
    return switch (results) {
      AsyncData(:final value) => _page(context, value, refreshing: false),
      AsyncError(:final error) => _Padded(_error(l10n, error, () => ref.invalidate(searchFoodsProvider(query)))),
      _ when _last != null => _page(context, _last!, refreshing: true),
      _ => DyLoadingRegion(loading: true, label: l10n.foodSearchResultsLabel, skeleton: const _ResultsSkeleton(), child: const SizedBox.shrink()),
    };
  }

  Widget _error(AppLocalizations l10n, Object error, VoidCallback retry) {
    final quota = error is ApiException && error.code == ApiErrorCode.quotaExceeded;
    return DyErrorState(
      kind: errorKindOf(error),
      title: quota ? l10n.foodSearchQuotaTitle : null,
      description: quota ? l10n.foodSearchQuotaDescription : null,
      actionLabel: l10n.retry,
      onAction: retry,
      compact: true,
    );
  }

  Widget _page(BuildContext context, FoodSearchPageEntity page, {required bool refreshing}) {
    final l10n = AppLocalizations.of(context);
    if (!refreshing) _last = page;
    if (page.items.isEmpty && !refreshing) {
      return _Padded(DyEmptyState(title: l10n.foodSearchNoResultsTitle(page.query), description: l10n.foodSearchNoResultsDescription, icon: DyIcons.search, compact: true));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Yenileme göstergesi her zaman yer kaplar; görünüp kaybolurken liste kaymaz.
      SizedBox(height: DySpacing.xs, child: refreshing ? Center(child: DyProgressSweep(color: context.dy.colors.primary)) : null),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(DySpacing.lg, DySpacing.xs, DySpacing.lg, DySpacing.xl3),
          children: [
            // Canlı bölge yalnız metni sarar: boşluk düğüme girerse odak çerçevesi kartın kenarına taşar.
            Padding(
              padding: const EdgeInsets.only(bottom: DySpacing.sm),
              child: Semantics(
                liveRegion: true,
                child: DyText(l10n.foodSearchResultCount(page.totalResults), style: DyTextStyle.caption, tone: DyTextTone.secondary),
              ),
            ),
            DyCard(child: DyList(semanticLabel: l10n.foodSearchResultsLabel, children: [for (final f in page.items) FoodResultItem(key: ValueKey(f.id), food: f)])),
            if (page.hasMore && !refreshing)
              Padding(
                padding: const EdgeInsets.only(top: DySpacing.md),
                child: DyButton(label: l10n.foodLoadMore, variant: DyButtonVariant.tertiary, fullWidth: true, onPressed: () => ref.read(searchFoodsProvider(page.query).notifier).loadMore()),
              ),
            if (page.attribution case final a?) AttributionFooter(attribution: a),
          ],
        ),
      ),
    ]);
  }
}

class _Padded extends StatelessWidget {
  const _Padded(this.child);
  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.all(DySpacing.lg), child: child);
}

class _ResultsSkeleton extends StatelessWidget {
  const _ResultsSkeleton();

  @override
  Widget build(BuildContext context) => ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(DySpacing.lg, DySpacing.md, DySpacing.lg, DySpacing.xl3),
        children: [
          DyCard(child: Column(spacing: DySpacing.xl, children: [for (var i = 0; i < 5; i++) const DySkeleton(shape: DySkeletonShape.text, lines: 3)])),
        ],
      );
}
