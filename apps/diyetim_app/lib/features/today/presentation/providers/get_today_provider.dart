import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructure/di/injection.dart';
import '../../domain/entities/today_entity.dart';
import '../../domain/usecases/get_today.dart';

part 'get_today_provider.g.dart';

@riverpod
class GetToday extends _$GetToday {
  @override
  Future<TodayEntity> build() => _fetchToday();

  Future<TodayEntity> _fetchToday() async {
    final output = await sl<GetTodayUsecase>()(const GetTodayUsecaseInput());
    return output.today;
  }

  /// Yenilerken eski içerik ekranda kalır (iskelet yalnız ilk yüklemede); yerleşim kaymaz.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
