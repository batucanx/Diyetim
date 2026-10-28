import '../entities/today_entity.dart';

abstract class TodayDataSource {
  Future<TodayEntity> getToday({DateTime? date});
}
