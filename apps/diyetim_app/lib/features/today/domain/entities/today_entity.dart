import 'package:dy_ui/dy_ui.dart' show DyDataSource, DyMealStatus, DyVisibility;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'today_entity.freezed.dart';

/// Bugünün içeriği. Sıra karar 0002'dedir: önce diyetisyen notu, sonra öğünler.
@freezed
abstract class TodayEntity with _$TodayEntity {
  const factory TodayEntity({required DateTime date, DietitianNoteEntity? dietitianNote, required List<MealEntity> meals}) = _TodayEntity;
}

@freezed
abstract class DietitianNoteEntity with _$DietitianNoteEntity {
  const factory DietitianNoteEntity({
    required String id,
    required String text,
    required DateTime createdAt,
    required String authorName,
    String? authorAvatarUrl,
    @Default(false) bool authorVerified,
  }) = _DietitianNoteEntity;
}

@freezed
abstract class MealEntity with _$MealEntity {
  const factory MealEntity({
    required String id,
    required String name,
    String? time,
    required DyMealStatus status,

    /// Gizliyse [calories] her zaman null'dır (değer istemciye inmez).
    @Default(DyVisibility.visible) DyVisibility caloriesVisibility,

    /// null + visible: değer henüz bilinmiyor.
    double? calories,
    required List<MealItemEntity> items,
  }) = _MealEntity;
}

@freezed
abstract class MealItemEntity with _$MealItemEntity {
  const factory MealItemEntity({required String name, DyDataSource? source}) = _MealItemEntity;
}
