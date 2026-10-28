import 'dart:async';

import 'package:dy_testing/dy_testing.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tüm testler gerçek Nunito ile çizilir (taşma ve golden ölçümleri gerçek genişlikleri kullanır).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadDyFonts();
  await testMain();
}
