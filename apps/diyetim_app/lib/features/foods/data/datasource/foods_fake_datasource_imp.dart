import 'package:dy_ui/dy_ui.dart' show DyFormat;
import 'package:injectable/injectable.dart';

import '../../../../infrastructure/di/injection.dart';
import '../../domain/data/foods_datasource.dart';
import '../../domain/entities/food_entity.dart';
import '../dto/rest_food_model.dart';

/// Backend hazır olana kadar. Yanıt sözleşme JSON'u olarak kurulur ve gerçek ayrıştırıcıdan geçer.
/// Basic plan davranışını taklit eder: atıf dolu gelir.
@LazySingleton(as: FoodsDataSource, env: [Env.fake])
class FoodsFakeDataSourceImp implements FoodsDataSource {
  const FoodsFakeDataSourceImp();

  static const latency = Duration(milliseconds: 400);

  // (ad, marka, porsiyon, gram, kcal, karbonhidrat, protein, yağ). Yaklaşık örnek değerler; besin verisi kaynağı değildir.
  static const _foods = <(String, String?, String, double, double, double, double, double)>[
    ('Mercimek çorbası', null, '1 kase (250 g)', 250, 140, 20.5, 8.1, 3.2),
    ('Kırmızı mercimek (haşlanmış)', null, '100 g', 100, 116, 20.1, 9.0, 0.4),
    ('Yeşil mercimek (haşlanmış)', null, '100 g', 100, 116, 20.0, 9.0, 0.4),
    ('Mercimek köftesi', null, '1 adet (35 g)', 35, 62, 9.8, 2.6, 1.6),
    ('Yulaf ezmesi', null, '1 porsiyon (40 g)', 40, 152, 26.4, 5.3, 2.8),
    ('Yulaflı bisküvi', 'Örnek Marka', '2 adet (30 g)', 30, 141, 19.8, 2.4, 5.7),
    ('Izgara tavuk göğsü', null, '100 g', 100, 165, 0, 31.0, 3.6),
    ('Tavuk sote', null, '1 porsiyon (200 g)', 200, 290, 8.4, 34.2, 13.0),
    ('Haşlanmış yumurta', null, '1 adet (50 g)', 50, 78, 0.6, 6.3, 5.3),
    ('Beyaz peynir', null, '1 dilim (30 g)', 30, 93, 0.4, 5.1, 7.8),
    ('Ayran', null, '1 bardak (200 ml)', 200, 76, 5.6, 3.8, 4.2),
    ('Elma', null, '1 orta boy (180 g)', 180, 94, 25.0, 0.5, 0.3),
  ];

  @override
  Future<FoodSearchPageEntity> search({required String query, required int page, required int pageSize}) async {
    await Future<void>.delayed(latency);
    final q = DyFormat.lowerTr(query);
    final hits = [
      for (final (i, f) in _foods.indexed)
        if (DyFormat.lowerTr(f.$1).contains(q))
          {
            'id': 'fake:$i',
            'name': f.$1,
            'brand': f.$2,
            'defaultServing': {
              'id': 'fake:$i:0', 'description': f.$3, 'metricAmount': f.$4, 'metricUnit': f.$3.contains('ml') ? 'ml' : 'g',
              'calories': f.$5, 'carbohydrate': f.$6, 'protein': f.$7, 'fat': f.$8,
            },
          },
    ];
    return RestFoodModel.pageFromJson({
      'query': query,
      'page': page,
      'pageSize': pageSize,
      'totalResults': hits.length,
      'items': hits.skip(page * pageSize).take(pageSize).toList(),
      'attribution': {'text': 'Powered by fatsecret', 'url': 'https://www.fatsecret.com'},
    });
  }
}
