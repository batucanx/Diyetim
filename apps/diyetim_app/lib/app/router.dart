import 'package:go_router/go_router.dart';

import '../features/foods/presentation/views/food_search_view.dart';
import '../features/today/presentation/views/today_view.dart';

abstract final class Paths {
  static const today = '/';
  static const foodSearch = '/foods/search';
}

GoRouter createRouter() => GoRouter(
      initialLocation: Paths.today,
      routes: [
        GoRoute(path: Paths.today, builder: (_, _) => const TodayView()),
        GoRoute(path: Paths.foodSearch, builder: (_, _) => const FoodSearchView()),
      ],
    );
