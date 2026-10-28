import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/provider_retry.dart';
import 'infrastructure/app_config.dart';
import 'infrastructure/di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies(AppConfig.useFakeData ? Env.fake : Env.remote);
  runApp(const ProviderScope(retry: providerRetry, child: DiyetimApp()));
}
