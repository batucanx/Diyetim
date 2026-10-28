import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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

/// Metin kontrastını token renkleri üzerinden ölçer: her metnin stil rengi, üstündeki ilk opak yüzeyle
/// (yarı saydam katmanlar harmanlanarak) karşılaştırılır. 4,5:1; büyük metin (≥ 24 px ya da ≥ 18,66 px kalın) 3:1.
/// `textContrastGuideline` ekran görüntüsünden piksel örneklediği için ince, küçük Nunito harflerinde
/// kenar yumuşatmasını metin rengi sanır; bu yardımcı onun yerine değil, onun yanılabildiği yerde kullanılır.
/// Opaklığı düşürülmüş (devre dışı) metin WCAG 1.4.3 kapsamı dışında olduğu için atlanır.
void expectTextContrast(WidgetTester tester) {
  final failures = <String>[];
  for (final e in tester.elementList(find.byType(RichText))) {
    final p = e.renderObject! as RenderParagraph;
    if (!p.hasSize || p.size.isEmpty) continue;
    final style = p.text.style;
    final fg = style?.color;
    if (fg == null) continue;
    var dimmed = false;
    final layers = <Color>[];
    RenderObject? r = p.parent;
    while (r != null) {
      if (r is RenderOpacity && r.opacity < 1 || r is RenderAnimatedOpacity && r.opacity.value < 1) dimmed = true;
      final c = switch (r) {
        RenderDecoratedBox(decoration: BoxDecoration(:final color?)) => color,
        RenderPhysicalModel(:final color) || RenderPhysicalShape(:final color) => color,
        _ => null,
      };
      if (c != null && c.a > 0) {
        layers.add(c);
        if (c.a == 1) break;
      }
      r = r.parent;
    }
    if (dimmed) continue;
    var bg = layers.isNotEmpty && layers.last.a == 1 ? layers.removeLast() : Theme.of(e).scaffoldBackgroundColor;
    for (final c in layers.reversed) {
      bg = Color.alphaBlend(c, bg);
    }
    // Nominal boyut: ölçek büyütmesi "büyük metin" eşiğine geçirmez (temkinli).
    final size = style!.fontSize ?? 14;
    final bold = (style.fontWeight ?? FontWeight.w400).value >= 700;
    final min = size >= 24 || (size >= 18.66 && bold) ? 3.0 : 4.5;
    double lum(Color c) => c.computeLuminance();
    final hi = lum(Color.alphaBlend(fg, bg)), lo = lum(bg);
    final ratio = (hi > lo ? hi + 0.05 : lo + 0.05) / (hi > lo ? lo + 0.05 : hi + 0.05);
    if (ratio < min) failures.add('"${p.text.toPlainText()}": ${ratio.toStringAsFixed(2)} < $min (metin $fg, zemin $bg)');
  }
  expect(failures, isEmpty, reason: 'Kontrast yetersiz metinler');
}
