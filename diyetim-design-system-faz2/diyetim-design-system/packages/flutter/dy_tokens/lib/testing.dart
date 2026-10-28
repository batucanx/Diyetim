/// Test yardımcıları. Uygulama kodundan içe aktarılmaz.
library;

import 'package:flutter/services.dart';

import 'src/generated/dy_typography.g.dart';

/// Nunito'yu test ortamına yükler. Varsayılan test fontu her harfi 1 em kare çizdiği için
/// taşma, kırpılma ve golden testleri gerçek genişlikleri ölçmez. `flutter_test_config.dart` içinden çağrılır.
Future<void> loadDyFonts() async {
  final loader = FontLoader('packages/${DyTypeScale.fontPackage}/${DyTypeScale.fontFamily}');
  for (final w in const ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    loader.addFont(rootBundle.load('packages/${DyTypeScale.fontPackage}/fonts/Nunito-$w.ttf'));
  }
  await loader.load();
}
