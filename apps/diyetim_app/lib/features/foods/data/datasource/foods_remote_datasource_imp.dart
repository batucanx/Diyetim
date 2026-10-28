import 'package:injectable/injectable.dart';

import '../../../../helpers/http/http_helper.dart';
import '../../../../infrastructure/di/injection.dart';
import '../../domain/data/foods_datasource.dart';
import '../../domain/entities/food_entity.dart';
import '../dto/rest_food_model.dart';

@LazySingleton(as: FoodsDataSource, env: [Env.remote])
class FoodsRemoteDataSourceImp implements FoodsDataSource {
  const FoodsRemoteDataSourceImp({required this._http});
  final HttpHelper _http;

  @override
  Future<FoodSearchPageEntity> search({required String query, required int page, required int pageSize}) async {
    final json = await _http.getJson('/api/foods/search', query: {'q': query, 'page': page, 'pageSize': pageSize});
    return RestFoodModel.pageFromJson(json);
  }
}
