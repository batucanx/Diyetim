import 'package:dy_gallery/integration_today.dart';
import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A–E gruplarının birlikte çalıştığını denetler: iki tema × metin ölçeği 1,0 / 2,0 × 320 / 390 px.
void main() {
  for (final b in Brightness.values) {
    for (final scale in [1.0, 2.0]) {
      for (final width in [320.0, 390.0]) {
        testWidgets('Bugün entegrasyonu ${b.name} ${scale}x ${width.toInt()}px: taşma ve istisna yok', (tester) async {
          tester.view.physicalSize = Size(width, 844) * tester.view.devicePixelRatio;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(MediaQuery(
            data: MediaQueryData(size: Size(width, 844), textScaler: TextScaler.linear(scale), disableAnimations: true),
            child: MaterialApp(theme: DyTheme.light(), darkTheme: DyTheme.dark(), themeMode: b == Brightness.dark ? ThemeMode.dark : ThemeMode.light, home: const IntegrationToday()),
          ));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.bySemanticsLabel('Kalori'), findsOneWidget);
          expect(find.text('Onay bekliyor'), findsOneWidget);
          await tester.scrollUntilVisible(find.text('Gizli'), 200);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
