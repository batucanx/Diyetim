import 'package:injectable/injectable.dart';

import '../../domain/data/foods_datasource.dart';
import '../../domain/repository/foods_repository.dart';
import '../../domain/usecases/search_foods.dart';

@LazySingleton(as: FoodsRepository)
class FoodsRepositoryImp implements FoodsRepository {
  const FoodsRepositoryImp({required this._dataSource});
  final FoodsDataSource _dataSource;

  @override
  Future<SearchFoodsUsecaseOutput> search(SearchFoodsUsecaseInput input) async =>
      SearchFoodsUsecaseOutput(await _dataSource.search(query: input.query, page: input.page, pageSize: input.pageSize));
}
