import 'package:diyetim_app/app/router.dart';
import 'package:diyetim_app/features/foods/data/datasource/foods_fake_datasource_imp.dart';
import 'package:diyetim_app/features/foods/presentation/views/food_search_view.dart';
import 'package:diyetim_app/features/today/data/datasource/today_fake_datasource_imp.dart';
import 'package:dy_testing/dy_testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

/// Ekran düzeyi kalite: %200 metin + 320 px'te taşma yok; iki temada erişilebilirlik kılavuzları; golden.
void main() {
  setUp(resetDi);

  Future<void> showToday(WidgetTester tester, {required Brightness b, double scale = 1, Size size = const Size(390, 844)}) async {
    await pumpApp(tester, brightness: b, textScale: scale, size: size);
    await pumpPast(tester, TodayFakeDataSourceImp.latency);
  }

  Future<void> showSearch(WidgetTester tester, {required Brightness b, double scale = 1, Size size = const Size(390, 844)}) async {
    await pumpApp(tester, location: Paths.foodSearch, brightness: b, textScale: scale, size: size);
    await tester.pump();
    await tester.enterText(find.byType(EditableText), 'mercimek');
    await tester.pump(FoodSearchView.debounce);
    await pumpPast(tester, FoodsFakeDataSourceImp.latency);
  }

  for (final b in Brightness.values) {
    testWidgets('Bugün ${b.name}: %200 metin, 320 px, uzun kaydırma — taşma yok', (tester) async {
      await showToday(tester, b: b, scale: 2, size: const Size(320, 640));
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(find.text('Akşam yemeği'), 300);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Besin arama ${b.name}: %200 metin, 320 px — taşma yok', (tester) async {
      await showSearch(tester, b: b, scale: 2, size: const Size(320, 640));
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(find.text('Powered by fatsecret'), 300, scrollable: find.byType(Scrollable).last);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Bugün ${b.name}: erişilebilirlik kılavuzları', (tester) async {
      final handle = tester.ensureSemantics();
      await showToday(tester, b: b);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      expectTextContrast(tester);
      handle.dispose();
    });

    testWidgets('Besin arama ${b.name}: erişilebilirlik kılavuzları', (tester) async {
      final handle = tester.ensureSemantics();
      await showSearch(tester, b: b);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // 12 px sonuç sayısında piksel örneklemesi kenar yumuşatmasını ölçüyor (en koyu piksel #8B8885, gerçek renk
      // text-secondary #54524F, 7,6:1). Token renkleriyle ölçülür; bkz. dy_testing.expectTextContrast.
      expectTextContrast(tester);
      handle.dispose();
    });

    testWidgets('golden Bugün ${b.name}', (tester) async {
      await showToday(tester, b: b);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/today_${b.name}.png'));
    }, tags: ['golden']);

    testWidgets('golden besin arama ${b.name}', (tester) async {
      await showSearch(tester, b: b);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/food_search_${b.name}.png'));
    }, tags: ['golden']);
  }
}
