import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final sl = GetIt.instance;

/// Ortamlar: `fake` (backend yokken, sözleşmeye uyan sahte veri) ve `remote` (gerçek backend).
abstract final class Env {
  static const fake = 'fake';
  static const remote = 'remote';
}

@InjectableInit()
void configureDependencies(String environment) => sl.init(environment: environment);
