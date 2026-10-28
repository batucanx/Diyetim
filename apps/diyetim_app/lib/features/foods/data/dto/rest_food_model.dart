import '../../domain/entities/food_entity.dart';

/// `GET /api/foods/search` yanıtı (docs/api/openapi.yaml → FoodSearchPage).
abstract final class RestFoodModel {
  static FoodSearchPageEntity pageFromJson(Map<String, Object?> j) => FoodSearchPageEntity(
        query: j['query']! as String,
        page: (j['page']! as num).toInt(),
        pageSize: (j['pageSize']! as num).toInt(),
        totalResults: (j['totalResults']! as num).toInt(),
        items: [for (final i in (j['items'] as List<Object?>? ?? const []).cast<Map<String, Object?>>()) summaryFromJson(i)],
        attribution: attributionFromJson(j['attribution']),
      );

  static FoodSummaryEntity summaryFromJson(Map<String, Object?> j) => FoodSummaryEntity(
        id: j['id']! as String,
        name: j['name']! as String,
        brand: j['brand'] as String?,
        defaultServing: servingFromJson(j['defaultServing']! as Map<String, Object?>),
      );

  static ServingEntity servingFromJson(Map<String, Object?> j) => ServingEntity(
        id: j['id']! as String,
        description: j['description']! as String,
        metricAmount: (j['metricAmount'] as num?)?.toDouble(),
        metricUnit: j['metricUnit'] as String?,
        calories: (j['calories']! as num).toDouble(),
        carbohydrate: (j['carbohydrate']! as num).toDouble(),
        protein: (j['protein']! as num).toDouble(),
        fat: (j['fat']! as num).toDouble(),
      );

  /// Atıf zorunlu olabileceği için bağlantı geçersizse metin yine gösterilir; bağlantı yalnız https ise kullanılır.
  static AttributionEntity? attributionFromJson(Object? raw) {
    if (raw is! Map<String, Object?>) return null;
    final text = raw['text'] as String?;
    if (text == null || text.isEmpty) return null;
    final url = Uri.tryParse(raw['url'] as String? ?? '');
    return AttributionEntity(text: text, url: url != null && url.isScheme('https') ? url : null);
  }
}
