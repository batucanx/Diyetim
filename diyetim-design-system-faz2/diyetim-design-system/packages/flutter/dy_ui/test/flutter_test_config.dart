import 'dart:async';

import 'package:dy_tokens/testing.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tüm testler gerçek Nunito ile çizilir (bkz. loadDyFonts).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadDyFonts();
  await testMain();
}
