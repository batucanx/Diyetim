import 'package:diyetim_app/features/foods/data/dto/rest_food_model.dart';
import 'package:diyetim_app/features/foods/domain/entities/food_entity.dart';
import 'package:diyetim_app/features/foods/domain/repository/foods_repository.dart';
import 'package:diyetim_app/features/foods/domain/usecases/search_foods.dart';
import 'package:diyetim_app/features/today/data/dto/rest_today_model.dart';
import 'package:diyetim_app/l10n/gen/app_localizations_tr.dart';
import 'package:diyetim_app/shared/relative_time.dart';
import 'package:dy_ui/dy_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RestTodayModel', () {
    Map<String, Object?> meal(Map<String, Object?> extra) => {'id': 'm', 'name': 'Kahvaltı', 'status': 'approved', 'items': <Object?>[], ...extra};
    Map<String, Object?> today(List<Object?> meals, {Object? note}) => {'date': '2026-10-28', 'dietitianNote': note, 'meals': meals};

    test('wire durumları eşlenir; bilinmeyen durum "logged" olur', () {
      final t = RestTodayModel.fromJson(today([meal({'status': 'pending-review'}), meal({'status': 'yeni-durum'})]));
      expect(t.meals.map((m) => m.status), [DyMealStatus.pendingReview, DyMealStatus.logged]);
    });

    test('gizli kalori: yanlışlıkla gönderilen değer de atılır', () {
      final m = RestTodayModel.fromJson(today([meal({'caloriesVisibility': 'hidden', 'calories': 420})])).meals.single;
      expect(m.caloriesVisibility, DyVisibility.hidden);
      expect(m.calories, isNull);
    });

    test('görünür ama bilinmeyen kalori null kalır; not null ise not yok', () {
      final t = RestTodayModel.fromJson(today([meal({})]));
      expect(t.meals.single.caloriesVisibility, DyVisibility.visible);
      expect(t.meals.single.calories, isNull);
      expect(t.dietitianNote, isNull);
    });

    test('kaynak etiketi wire adından', () {
      final m = RestTodayModel.fromJson(today([meal({'items': [{'name': 'Ceviz', 'source': 'ai'}, {'name': 'Elma'}]})])).meals.single;
      expect(m.items.map((i) => i.source), [DyDataSource.ai, null]);
    });
  });

  group('RestFoodModel.attribution', () {
    test('Premier: null → atıf yok', () => expect(RestFoodModel.attributionFromJson(null), isNull));
    test('https bağlantı korunur', () {
      final a = RestFoodModel.attributionFromJson({'text': 'Powered by fatsecret', 'url': 'https://www.fatsecret.com'})!;
      expect(a.url, Uri.parse('https://www.fatsecret.com'));
    });
    test('güvensiz bağlantı açılmaz ama metin kalır (atıf zorunlu)', () {
      final a = RestFoodModel.attributionFromJson({'text': 'Powered by fatsecret', 'url': 'javascript:alert(1)'})!;
      expect(a.text, 'Powered by fatsecret');
      expect(a.url, isNull);
    });
  });

  group('SearchFoodsUsecase', () {
    test('boşluklar sadeleşir', () => expect(SearchFoodsUsecase.normalize('  kırmızı   mercimek '), 'kırmızı mercimek'));
    test('2 harften kısa sorgu backend\'e gitmez', () async {
      final u = SearchFoodsUsecase(repository: _NeverRepo());
      expect(() => u(const SearchFoodsUsecaseInput(query: ' m ')), throwsArgumentError);
    });
  });

  test('FoodSearchPageEntity.append: sayfa ilerler, tekrar eden kimlik eklenmez', () {
    FoodSummaryEntity f(String id) => FoodSummaryEntity(id: id, name: id, defaultServing: const ServingEntity(id: 's', description: '100 g', calories: 1, carbohydrate: 0, protein: 0, fat: 0));
    final a = FoodSearchPageEntity(query: 'q', page: 0, pageSize: 2, totalResults: 3, items: [f('1'), f('2')]);
    final b = a.append(FoodSearchPageEntity(query: 'q', page: 1, pageSize: 2, totalResults: 3, items: [f('2'), f('3')]));
    expect(b.items.map((e) => e.id), ['1', '2', '3']);
    expect(b.page, 1);
    expect(b.hasMore, isFalse);
  });

  group('relativeTime', () {
    final l10n = AppLocalizationsTr();
    final now = DateTime(2026, 10, 28, 15);
    test('az önce / dk / saat', () {
      expect(relativeTime(l10n, now.subtract(const Duration(seconds: 20)), now: now), 'az önce');
      expect(relativeTime(l10n, now.subtract(const Duration(minutes: 12)), now: now), '12 dk önce');
      expect(relativeTime(l10n, now.subtract(const Duration(hours: 2)), now: now), '2 saat önce');
    });
    test('takvim gününe göre dün / gün önce', () {
      expect(relativeTime(l10n, DateTime(2026, 10, 27, 23), now: DateTime(2026, 10, 28, 1)), 'dün');
      expect(relativeTime(l10n, DateTime(2026, 10, 24, 9), now: now), '4 gün önce');
    });
  });
}

class _NeverRepo implements FoodsRepository {
  @override
  Future<SearchFoodsUsecaseOutput> search(SearchFoodsUsecaseInput input) => fail('repository çağrılmamalıydı');
}
