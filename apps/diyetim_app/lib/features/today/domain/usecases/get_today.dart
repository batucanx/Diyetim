import 'package:injectable/injectable.dart';

import '../../../../infrastructure/usecase.dart';
import '../entities/today_entity.dart';
import '../repository/today_repository.dart';

class GetTodayUsecaseInput extends Input {
  const GetTodayUsecaseInput({this.date});
  final DateTime? date;
}

class GetTodayUsecaseOutput extends Output {
  const GetTodayUsecaseOutput(this.today);
  final TodayEntity today;
}

@lazySingleton
class GetTodayUsecase extends Usecase<GetTodayUsecaseInput, GetTodayUsecaseOutput> {
  const GetTodayUsecase({required this._repository});
  final TodayRepository _repository;

  @override
  Future<GetTodayUsecaseOutput> call(GetTodayUsecaseInput input) => _repository.getToday(input);
}
