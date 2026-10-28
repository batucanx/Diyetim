import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_entity.freezed.dart';

/// Bir arama sayfası. Sağlayıcıdan bağımsızdır; yalnız [attribution] sağlayıcının atıf koşulunu taşır.
@freezed
abstract class FoodSearchPageEntity with _$FoodSearchPageEntity {
  const FoodSearchPageEntity._();
  const factory FoodSearchPageEntity({
    required String query,
    required int page,
    required int pageSize,
    required int totalResults,
    required List<FoodSummaryEntity> items,
    AttributionEntity? attribution,
  }) = _FoodSearchPageEntity;

  bool get hasMore => items.length < totalResults;

  /// Sonraki sayfayı ekler; aynı kimlik iki kez görünmez.
  FoodSearchPageEntity append(FoodSearchPageEntity next) {
    final seen = {for (final f in items) f.id};
    return copyWith(page: next.page, totalResults: next.totalResults, items: [...items, ...next.items.where((f) => seen.add(f.id))], attribution: next.attribution ?? attribution);
  }
}

@freezed
abstract class FoodSummaryEntity with _$FoodSummaryEntity {
  const factory FoodSummaryEntity({required String id, required String name, String? brand, required ServingEntity defaultServing}) = _FoodSummaryEntity;
}

@freezed
abstract class ServingEntity with _$ServingEntity {
  const factory ServingEntity({
    required String id,
    required String description,
    double? metricAmount,
    String? metricUnit,
    required double calories,
    required double carbohydrate,
    required double protein,
    required double fat,
  }) = _ServingEntity;
}

@freezed
abstract class AttributionEntity with _$AttributionEntity {
  const factory AttributionEntity({required String text, Uri? url}) = _AttributionEntity;
}
