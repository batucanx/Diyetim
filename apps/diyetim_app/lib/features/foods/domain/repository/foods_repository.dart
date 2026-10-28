import '../usecases/search_foods.dart';

abstract class FoodsRepository {
  /// Girdi: arama metni (≥ 2 harf), sayfa · Çıktı: bir sonuç sayfası ve sağlayıcı atfı.
  Future<SearchFoodsUsecaseOutput> search(SearchFoodsUsecaseInput input);
}
