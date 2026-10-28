import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('DyFormat', () {
    test('Türkçe sayı biçimi', () {
      expect(DyFormat.number(1842), '1.842');
      expect(DyFormat.number(6.34), '6,3');
      expect(DyFormat.number(1234567.5), '1.234.567,5');
      expect(DyFormat.number(150.0), '150');
      expect(DyFormat.percent(0.48), '%48');
    });
    test('girdi ayrıştırma', () {
      expect(DyFormat.parse('6,5'), 6.5);
      expect(DyFormat.parse('1.842'), 1842);
      expect(DyFormat.parse('1.842,5'), 1842.5);
      expect(DyFormat.parse('abc'), isNull);
      expect(DyFormat.parse(''), isNull);
    });
    test('Türkçe küçük harf', () => expect(DyFormat.lowerTr('İNCİR Işık'), 'incir ışık'));
  });

  group('DyText', () {
    testWidgets('başlıklar header semantiği taşır, renk tondan gelir', (tester) async {
      await pumpDy(tester, const DyText('Bugün', style: DyTextStyle.h1));
      expect(tester.getSemantics(find.text('Bugün')), matchesSemantics(label: 'Bugün', isHeader: true));
      final text = tester.widget<Text>(find.text('Bugün'));
      expect(text.style!.color, DyColors.light.textPrimary);
      expect(text.style!.fontSize, 28);
    });
    testWidgets('dark temada tonlar dark renkleri kullanır', (tester) async {
      await pumpDy(tester, const DyText('Not', tone: DyTextTone.muted), brightness: Brightness.dark);
      expect(tester.widget<Text>(find.text('Not')).style!.color, DyColors.dark.textMuted);
    });
    testWidgets('masaüstü genişliğinde expanded ölçek', (tester) async {
      await pumpDy(tester, const DyText('Başlık', style: DyTextStyle.h1), width: 1280);
      expect(tester.widget<Text>(find.text('Başlık')).style!.fontSize, 32);
    });
    testWidgets('varsayılan olarak kırpmaz; maxLines ile üç nokta', (tester) async {
      await pumpDy(tester, const DyText('Uzun metin', maxLines: 1));
      expect(tester.widget<Text>(find.text('Uzun metin')).overflow, TextOverflow.ellipsis);
    });
  });

  group('DyNumber', () {
    testWidgets('birim ve bağlam etiketiyle okunur', (tester) async {
      await pumpDy(tester, const DyNumber(941, unit: 'kcal', label: 'Kalan kalori', style: DyTextStyle.numericXl));
      expect(find.bySemanticsLabel('Kalan kalori: 941 kcal'), findsOneWidget);
      expect(find.textContaining('941'), findsOneWidget);
    });
    testWidgets('gizli metrik değeri göstermez', (tester) async {
      await pumpDy(tester, const DyNumber(null, visibility: DyVisibility.hidden, label: 'Kilo'));
      expect(find.text('Gizli'), findsOneWidget);
      expect(find.bySemanticsLabel('Kilo: Gizli'), findsOneWidget);
    });
    testWidgets('null değer: tire ve "değer yok"', (tester) async {
      await pumpDy(tester, const DyNumber(null, unit: 'mg/dL'));
      expect(find.text('—'), findsOneWidget);
      expect(find.bySemanticsLabel('değer yok'), findsOneWidget);
    });
  });

  group('DyIcon', () {
    testWidgets('etiketsiz ikon dekoratif, etiketli ikon görsel olarak okunur', (tester) async {
      await pumpDy(tester, const Column(children: [DyIcon(DyIcons.search), DyIcon(DyIcons.lock, semanticLabel: 'Kilitli')]));
      expect(find.bySemanticsLabel('Kilitli'), findsOneWidget);
      expect(tester.getSize(find.byType(DyIcon).first), const Size(DyIconSize.md, DyIconSize.md));
    });
    test('tüm ikonların komut listesi geçerli', () {
      for (final icon in DyIcons.all) {
        expect(icon.ops, isNotEmpty, reason: icon.name);
        expect(icon.ops.first, 0, reason: '${icon.name} moveTo ile başlamalı');
      }
    });
  });

  group('DySurface', () {
    testWidgets('dark temada yükseltilmiş yüzey kenar ışığı ve dark rengi alır', (tester) async {
      await pumpDy(tester, const DySurface(elevation: DyElevation.low, padding: EdgeInsets.all(DySpacing.xl), child: SizedBox(height: 40)), brightness: Brightness.dark);
      final box = tester.widget<DecoratedBox>(find.descendant(of: find.byType(DySurface), matching: find.byType(DecoratedBox)).first);
      final d = box.decoration as BoxDecoration;
      expect(d.color, DyColors.dark.surface);
      expect(d.boxShadow, DyShadows.dark.low);
    });
  });

  group('DyPressable durumları', () {
    testWidgets('enabled: dokunma ve Enter tetikler', (tester) async {
      var n = 0;
      await pumpDy(tester, DyPressable(onPressed: () => n++, semanticLabel: 'Bas', builder: (_, __) => const Text('Bas')));
      await tester.tap(find.text('Bas'));
      await tab(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(n, 2);
    });
    testWidgets('disabled: tetiklenmez, odaklanmaz', (tester) async {
      var n = 0;
      await pumpDy(tester, DyPressable(onPressed: () => n++, state: DyComponentState.disabled, builder: (_, __) => const Text('Bas')));
      await tester.tap(find.text('Bas'));
      expect(n, 0);
      expect(tester.getSemantics(find.byType(DyPressable)), matchesSemantics(isButton: true, hasEnabledState: true, isEnabled: false));
    });
    testWidgets('locked: odaklanır, nedeni ipucu olarak okunur, tetiklenmez', (tester) async {
      var n = 0;
      await pumpDy(tester, DyPressable(onPressed: () => n++, state: DyComponentState.locked, lockedReason: 'Diyetisyenin kapattı', semanticLabel: 'Besin ekle', builder: (_, __) => const Text('Besin ekle')));
      await tester.tap(find.text('Besin ekle'));
      await tab(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(n, 0);
      expect(tester.getSemantics(find.byType(DyPressable)), matchesSemantics(isButton: true, label: 'Besin ekle', hint: 'Diyetisyenin kapattı', hasEnabledState: true, isFocusable: true, isFocused: true));
    });
    testWidgets('klavye odağında odak halkası çizilir', (tester) async {
      await pumpDy(tester, DyPressable(onPressed: () {}, builder: (_, __) => const Text('Bas')));
      await tab(tester);
      final paint = find.descendant(of: find.byType(DyPressable), matching: find.byType(CustomPaint)).first;
      expect(tester.widget<CustomPaint>(paint).foregroundPainter, isNotNull);
    });
  });

  group('DySkeleton', () {
    testWidgets('ekran okuyucudan gizli; hareketi azaltta animasyon durur', (tester) async {
      await pumpDy(tester, const DySkeleton(shape: DySkeletonShape.text, lines: 3), disableAnimations: true);
      expect(find.byType(DySkeleton), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
