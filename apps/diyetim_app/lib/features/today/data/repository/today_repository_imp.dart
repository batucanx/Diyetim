import 'package:injectable/injectable.dart';

import '../../domain/data/today_datasource.dart';
import '../../domain/repository/today_repository.dart';
import '../../domain/usecases/get_today.dart';

@LazySingleton(as: TodayRepository)
class TodayRepositoryImp implements TodayRepository {
  const TodayRepositoryImp({required this._dataSource});
  final TodayDataSource _dataSource;

  @override
  Future<GetTodayUsecaseOutput> getToday(GetTodayUsecaseInput input) async => GetTodayUsecaseOutput(await _dataSource.getToday(date: input.date));
}
