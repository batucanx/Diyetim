import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  for (final variant in DyButtonVariant.values) {
    testWidgets('DyButton ${variant.wire} etiketle çizilir ve tetiklenir', (tester) async {
      var n = 0;
      await pumpDy(tester, DyButton(label: 'Öğünü kaydet', variant: variant, onPressed: () => n++));
      await tester.tap(find.text('Öğünü kaydet'));
      expect(n, 1);
    });
  }

  testWidgets('loading: etiket erişilebilir adda kalır, "Yükleniyor" ipucu, tetiklenmez', (tester) async {
    var n = 0;
    await pumpDy(tester, DyButton(label: 'Kaydet', state: DyComponentState.loading, onPressed: () => n++));
    await tester.tap(find.byType(DyButton));
    expect(n, 0);
    expect(tester.getSemantics(find.byType(DyPressable)), matchesSemantics(isButton: true, label: 'Kaydet', hint: 'Yükleniyor', hasEnabledState: true, isFocusable: true));
    expect(find.byType(DyProgressSweep), findsOneWidget);
  });

  testWidgets('locked: kilit ikonu ve neden', (tester) async {
    await pumpDy(tester, DyButton(label: 'Besin ekle', state: DyComponentState.locked, lockedReason: 'Plan dışı ekleme kapalı', onPressed: () {}));
    expect(find.byWidgetPredicate((w) => w is DyIcon && w.icon == DyIcons.lock), findsOneWidget);
    expect(tester.getSemantics(find.byType(DyPressable)), matchesSemantics(isButton: true, label: 'Besin ekle', hint: 'Plan dışı ekleme kapalı', hasEnabledState: true, isFocusable: true));
  });

  testWidgets('uzun Türkçe etiket %200 metin ölçeğinde kırpılmaz, taşmaz', (tester) async {
    const label = 'Diyetisyenime bugünkü tüm öğünlerimi onay için gönder ve bildirim aç';
    await pumpDy(tester, DyButton(label: label, fullWidth: true, size: DyButtonSize.lg, onPressed: () {}), textScale: 2.0, width: 320);
    expect(tester.takeException(), isNull);
    final text = tester.widget<Text>(find.text(label));
    expect(text.maxLines, isNull);
    expect(text.softWrap, isTrue);
  });

  testWidgets('IconButton ve Fab erişilebilir ad taşır, dokunma alanı ≥ 44', (tester) async {
    await pumpDy(tester, Row(children: [
      DyIconButton(icon: DyIcons.bell, label: 'Bildirimler', onPressed: () {}),
      DyFab(icon: DyIcons.camera, label: 'Öğün fotoğrafı çek', onPressed: () {}),
    ]));
    expect(find.bySemanticsLabel('Bildirimler'), findsOneWidget);
    expect(find.bySemanticsLabel('Öğün fotoğrafı çek'), findsOneWidget);
    expect(tester.getSize(find.byType(DyIconButton)).height, greaterThanOrEqualTo(DySize.targetMin));
  });

  testWidgets('erişilebilirlik kılavuzları (light ve dark)', (tester) async {
    for (final b in Brightness.values) {
      final handle = tester.ensureSemantics();
      await pumpDy(tester, Column(children: [
        DyButton(label: 'Kaydet', onPressed: () {}),
        DyButton(label: 'Ekle', variant: DyButtonVariant.secondary, onPressed: () {}),
        DyButton(label: 'Vazgeç', variant: DyButtonVariant.tertiary, onPressed: () {}),
        DyButton(label: 'İptal', variant: DyButtonVariant.destructive, onPressed: () {}),
        DyIconButton(icon: DyIcons.x, label: 'Kapat', onPressed: () {}),
      ]), brightness: b);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    }
  });
}
