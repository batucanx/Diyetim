import '../entities/food_entity.dart';

abstract class FoodsDataSource {
  Future<FoodSearchPageEntity> search({required String query, required int page, required int pageSize});
}
