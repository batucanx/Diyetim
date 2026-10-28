import 'package:injectable/injectable.dart';

import '../../../../infrastructure/usecase.dart';
import '../entities/food_entity.dart';
import '../repository/foods_repository.dart';

class SearchFoodsUsecaseInput extends Input {
  const SearchFoodsUsecaseInput({required this.query, this.page = 0, this.pageSize = 20});
  final String query;
  final int page;
  final int pageSize;
}

class SearchFoodsUsecaseOutput extends Output {
  const SearchFoodsUsecaseOutput(this.page);
  final FoodSearchPageEntity page;
}

@lazySingleton
class SearchFoodsUsecase extends Usecase<SearchFoodsUsecaseInput, SearchFoodsUsecaseOutput> {
  const SearchFoodsUsecase({required this._repository});
  final FoodsRepository _repository;

  /// Sözleşmedeki alt sınır (docs/api/openapi.yaml: q minLength 2).
  static const minQueryLength = 2;

  /// Boşlukları sadeleştirir; istek atılmaya değer mi kararı tek yerde.
  static String normalize(String raw) => raw.trim().replaceAll(RegExp(r'\s+'), ' ');

  @override
  Future<SearchFoodsUsecaseOutput> call(SearchFoodsUsecaseInput input) {
    final q = normalize(input.query);
    if (q.length < minQueryLength) throw ArgumentError.value(input.query, 'query', 'en az $minQueryLength karakter');
    return _repository.search(SearchFoodsUsecaseInput(query: q, page: input.page, pageSize: input.pageSize));
  }
}
