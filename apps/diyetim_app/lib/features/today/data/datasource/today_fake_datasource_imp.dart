import 'package:injectable/injectable.dart';

import '../../../../infrastructure/di/injection.dart';
import '../../domain/data/today_datasource.dart';
import '../../domain/entities/today_entity.dart';
import '../dto/rest_today_model.dart';

/// Backend hazır olana kadar: sözleşmedeki JSON gerçek ayrıştırıcıdan geçer, böylece DTO da sınanır.
@LazySingleton(as: TodayDataSource, env: [Env.fake])
class TodayFakeDataSourceImp implements TodayDataSource {
  const TodayFakeDataSourceImp();

  static const latency = Duration(milliseconds: 600);

  @override
  Future<TodayEntity> getToday({DateTime? date}) async {
    await Future<void>.delayed(latency);
    final d = date ?? DateTime.now();
    return RestTodayModel.fromJson(sampleJson(d));
  }

  static Map<String, Object?> sampleJson(DateTime d) => {
        'date': d.toIso8601String().substring(0, 10),
        'dietitianNote': {
          'id': 'n1',
          'text': 'Bu hafta proteinin çok iyi gidiyor. Bugün kahvaltıda yumurtayı atlama; öğle yemeğinden sonra 20 dakika '
              'yürüyüş ekleyelim. Akşam karbonhidratı yarım porsiyon tut, su hedefin 2,5 litre. Cuma günkü görüşmede '
              'tartı sonucuna birlikte bakacağız.',
          'createdAt': d.subtract(const Duration(hours: 2)).toUtc().toIso8601String(),
          'author': {'name': 'Dyt. Elif Yıldız', 'avatarUrl': null, 'verified': true},
        },
        'meals': [
          {
            'id': 'm1', 'name': 'Kahvaltı', 'time': '08:30', 'status': 'approved', 'calories': 420,
            'items': [{'name': 'Haşlanmış yumurta', 'source': 'patient'}, {'name': 'Tam buğday ekmeği', 'source': 'patient'}, {'name': 'Beyaz peynir', 'source': 'verified'}],
          },
          {
            'id': 'm2', 'name': 'Ara öğün', 'time': '11:00', 'status': 'pending-review', 'calories': 180,
            'items': [{'name': 'Elma', 'source': 'patient'}, {'name': 'Ceviz', 'source': 'ai'}],
          },
          {
            'id': 'm3', 'name': 'Öğle yemeği', 'time': '13:00', 'status': 'planned', 'calories': 540,
            'items': [{'name': 'Mercimek çorbası', 'source': 'dietitian'}, {'name': 'Izgara tavuk', 'source': 'dietitian'}, {'name': 'Mevsim salata', 'source': 'dietitian'}],
          },
          {
            // Diyetisyen bu öğünün kalorisini gizledi.
            'id': 'm4', 'name': 'Akşam yemeği', 'time': '19:30', 'status': 'planned', 'caloriesVisibility': 'hidden',
            'items': [{'name': 'Zeytinyağlı taze fasulye', 'source': 'dietitian'}, {'name': 'Yoğurt', 'source': 'dietitian'}],
          },
        ],
      };
}
