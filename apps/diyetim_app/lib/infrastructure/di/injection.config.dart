// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:diyetim_app/features/foods/data/datasource/foods_fake_datasource_imp.dart'
    as _i498;
import 'package:diyetim_app/features/foods/data/datasource/foods_remote_datasource_imp.dart'
    as _i674;
import 'package:diyetim_app/features/foods/data/repository/foods_repository_imp.dart'
    as _i851;
import 'package:diyetim_app/features/foods/domain/data/foods_datasource.dart'
    as _i504;
import 'package:diyetim_app/features/foods/domain/repository/foods_repository.dart'
    as _i723;
import 'package:diyetim_app/features/foods/domain/usecases/search_foods.dart'
    as _i248;
import 'package:diyetim_app/features/today/data/datasource/today_fake_datasource_imp.dart'
    as _i464;
import 'package:diyetim_app/features/today/data/datasource/today_remote_datasource_imp.dart'
    as _i826;
import 'package:diyetim_app/features/today/data/repository/today_repository_imp.dart'
    as _i1029;
import 'package:diyetim_app/features/today/domain/data/today_datasource.dart'
    as _i173;
import 'package:diyetim_app/features/today/domain/repository/today_repository.dart'
    as _i482;
import 'package:diyetim_app/features/today/domain/usecases/get_today.dart'
    as _i249;
import 'package:diyetim_app/helpers/http/http_helper.dart' as _i186;
import 'package:diyetim_app/helpers/http/http_helper_impl.dart' as _i108;
import 'package:diyetim_app/helpers/url/url_helper.dart' as _i384;
import 'package:diyetim_app/helpers/url/url_helper_impl.dart' as _i279;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

const String _fake = 'fake';
const String _remote = 'remote';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i384.UrlHelper>(() => const _i279.UrlHelperImpl());
    gh.lazySingleton<_i504.FoodsDataSource>(
      () => const _i498.FoodsFakeDataSourceImp(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i173.TodayDataSource>(
      () => const _i464.TodayFakeDataSourceImp(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i186.HttpHelper>(
      () => _i108.HttpHelperImpl(),
      registerFor: {_remote},
    );
    gh.lazySingleton<_i173.TodayDataSource>(
      () => _i826.TodayRemoteDataSourceImp(http: gh<_i186.HttpHelper>()),
      registerFor: {_remote},
    );
    gh.lazySingleton<_i504.FoodsDataSource>(
      () => _i674.FoodsRemoteDataSourceImp(http: gh<_i186.HttpHelper>()),
      registerFor: {_remote},
    );
    gh.lazySingleton<_i482.TodayRepository>(
      () => _i1029.TodayRepositoryImp(dataSource: gh<_i173.TodayDataSource>()),
    );
    gh.lazySingleton<_i723.FoodsRepository>(
      () => _i851.FoodsRepositoryImp(dataSource: gh<_i504.FoodsDataSource>()),
    );
    gh.lazySingleton<_i249.GetTodayUsecase>(
      () => _i249.GetTodayUsecase(repository: gh<_i482.TodayRepository>()),
    );
    gh.lazySingleton<_i248.SearchFoodsUsecase>(
      () => _i248.SearchFoodsUsecase(repository: gh<_i723.FoodsRepository>()),
    );
    return this;
  }
}
