import 'package:dy_ui/dy_ui.dart' show DyDataSource, DyMealStatus, DyVisibility;

import '../../../../shared/wire.dart';
import '../../domain/entities/today_entity.dart';

/// `GET /api/today` yanıtı (docs/api/openapi.yaml → Today). Bilinmeyen durum değeri hata değildir:
/// daha yeni bir backend yeni durum eklerse öğün `logged` olarak gösterilir.
abstract final class RestTodayModel {
  static TodayEntity fromJson(Map<String, Object?> j) => TodayEntity(
        date: DateTime.parse(j['date']! as String),
        dietitianNote: switch (j['dietitianNote']) { final Map<String, Object?> n => _note(n), _ => null },
        meals: [for (final m in (j['meals'] as List<Object?>? ?? const [])) _meal(m! as Map<String, Object?>)],
      );

  static DietitianNoteEntity _note(Map<String, Object?> n) {
    final author = n['author']! as Map<String, Object?>;
    return DietitianNoteEntity(
      id: n['id']! as String,
      text: n['text']! as String,
      createdAt: DateTime.parse(n['createdAt']! as String),
      authorName: author['name']! as String,
      authorAvatarUrl: author['avatarUrl'] as String?,
      authorVerified: author['verified'] as bool? ?? false,
    );
  }

  static MealEntity _meal(Map<String, Object?> m) => MealEntity(
        id: m['id']! as String,
        name: m['name']! as String,
        time: m['time'] as String?,
        status: byWire(DyMealStatus.values, m['status'] as String?, (s) => s.wire) ?? DyMealStatus.logged,
        caloriesVisibility: byWire(DyVisibility.values, m['caloriesVisibility'] as String?, (v) => v.wire) ?? DyVisibility.visible,
        // Gizliyken yanlışlıkla gelen değer de gösterilmez.
        calories: m['caloriesVisibility'] == 'hidden' ? null : (m['calories'] as num?)?.toDouble(),
        items: [
          for (final i in (m['items'] as List<Object?>? ?? const []).cast<Map<String, Object?>>())
            MealItemEntity(name: i['name']! as String, source: byWire(DyDataSource.values, i['source'] as String?, (s) => s.wire)),
        ],
      );
}
