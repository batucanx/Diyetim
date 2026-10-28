import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

export 'package:dy_testing/dy_testing.dart' show expectTextContrast;

/// Testlerde component'i Diyetim temasıyla, istenen tema / metin ölçeği / genişlikte çizer.
Future<void> pumpDy(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.light,
  double textScale = 1.0,
  double width = 390,
  double height = 844,
  bool disableAnimations = false,
  /// Sürekli animasyon (ör. iskelet parıltısı) varken false: pumpAndSettle hiç bitmez.
  bool settle = true,
}) async {
  tester.view.physicalSize = Size(width, height) * tester.view.devicePixelRatio;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: Size(width, height), textScaler: TextScaler.linear(textScale), disableAnimations: disableAnimations),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: DyTheme.light(),
        darkTheme: DyTheme.dark(),
        themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
        home: Scaffold(body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(DySpacing.xl), child: child))),
      ),
    ),
  );
  settle ? await tester.pumpAndSettle() : await tester.pump();
}

/// Klavyeyle odak taşır.
Future<void> tab(WidgetTester tester, [int times = 1]) async {
  for (var i = 0; i < times; i++) {
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  }
  await tester.pump();
}
