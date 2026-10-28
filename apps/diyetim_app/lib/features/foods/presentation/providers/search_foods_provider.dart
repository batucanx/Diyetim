import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructure/di/injection.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/usecases/search_foods.dart';

part 'search_foods_provider.g.dart';

/// Ekrandaki arama metni (gecikmeli). Görünüm her tuşta değil, yazma durunca günceller.
@riverpod
class FoodSearchQuery extends _$FoodSearchQuery {
  @override
  String build() => '';

  void set(String raw) => state = SearchFoodsUsecase.normalize(raw);
}

/// Bir arama metninin sonuçları. Metin değişince eski aile örneği bırakılır; geç gelen eski yanıt yeni sonucu ezmez.
@riverpod
class SearchFoods extends _$SearchFoods {
  bool _loadingMore = false;

  @override
  Future<FoodSearchPageEntity> build(String query) => _fetch(0);

  Future<FoodSearchPageEntity> _fetch(int page) async {
    final output = await sl<SearchFoodsUsecase>()(SearchFoodsUsecaseInput(query: query, page: page));
    return output.page;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return;
    _loadingMore = true;
    try {
      final next = await _fetch(current.page + 1);
      if (ref.mounted) state = AsyncData(current.append(next));
    } finally {
      _loadingMore = false;
    }
  }
}
