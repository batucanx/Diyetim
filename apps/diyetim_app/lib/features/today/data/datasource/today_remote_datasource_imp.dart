import 'package:injectable/injectable.dart';

import '../../../../helpers/http/http_helper.dart';
import '../../../../infrastructure/di/injection.dart';
import '../../domain/data/today_datasource.dart';
import '../../domain/entities/today_entity.dart';
import '../dto/rest_today_model.dart';

@LazySingleton(as: TodayDataSource, env: [Env.remote])
class TodayRemoteDataSourceImp implements TodayDataSource {
  const TodayRemoteDataSourceImp({required this._http});
  final HttpHelper _http;

  @override
  Future<TodayEntity> getToday({DateTime? date}) async {
    final json = await _http.getJson('/api/today', query: {if (date != null) 'date': date.toIso8601String().substring(0, 10)});
    return RestTodayModel.fromJson(json);
  }
}
