import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets('TextField: etiket ve değer; onChanged', (tester) async {
    String? last;
    await pumpDy(tester, DyTextField(label: 'Ad', onChanged: (v) => last = v));
    await tester.enterText(find.byType(TextField), 'Elif');
    expect(last, 'Elif');
    expect(find.bySemanticsLabel(RegExp('Ad')), findsWidgets);
  });

  testWidgets('hata: mesaj görünür, canlı bölge, ipucuna eklenir', (tester) async {
    await pumpDy(tester, const DyTextField(label: 'Kilo', error: 'Bu değer çok düşük görünüyor.', description: 'kg cinsinden'));
    expect(find.text('Bu değer çok düşük görünüyor.'), findsOneWidget);
    final s = tester.getSemantics(find.byType(TextField));
    expect(s.hint, contains('Bu değer çok düşük görünüyor.'));
    expect(s.hint, contains('kg cinsinden'));
  });

  testWidgets('locked: salt okunur, neden görünür', (tester) async {
    await pumpDy(tester, const DyTextField(label: 'Porsiyon', initialValue: '1 kase', state: DyComponentState.locked, lockedReason: 'Diyetisyenin gramaj değişikliğini kapattı.'));
    expect(tester.widget<TextField>(find.byType(TextField)).readOnly, isTrue);
    expect(find.text('Diyetisyenin gramaj değişikliğini kapattı.'), findsOneWidget);
  });

  testWidgets('disabled: devre dışı', (tester) async {
    await pumpDy(tester, const DyTextField(label: 'Ad', state: DyComponentState.disabled));
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
  });

  testWidgets('SearchField: temizle butonu ve Escape', (tester) async {
    await pumpDy(tester, const DySearchField(label: 'Besin ara'));
    await tester.enterText(find.byType(TextField), 'yulaf');
    await tester.pump();
    expect(find.bySemanticsLabel('Aramayı temizle'), findsOneWidget);
    await tester.tap(find.byType(DyIconButton));
    await tester.pump();
    expect(find.text('yulaf'), findsNothing);
    await tester.enterText(find.byType(TextField), 'tavuk');
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(find.text('tavuk'), findsNothing);
  });

  testWidgets('NumberField: Türkçe ondalık ve ok tuşlarıyla sınırlı adım', (tester) async {
    double? v = 190;
    await pumpDy(tester, StatefulBuilder(builder: (context, set) => DyNumberField(label: 'Gramaj', unit: 'g', value: v, step: 10, min: 0, max: 200, onChanged: (x) => set(() => v = x))));
    await tester.tap(find.byType(TextField));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(v, 200);
    await tester.enterText(find.byType(TextField), '6,5');
    expect(v, 6.5);
    await tester.enterText(find.byType(TextField), 'abc');
    expect(find.text('abc'), findsNothing);
  });

  testWidgets('Textarea: sayaç ve sınır', (tester) async {
    await pumpDy(tester, const DyTextarea(label: 'Not', maxLength: 10));
    await tester.enterText(find.byType(TextField), 'Harika bir tabak');
    await tester.pump();
    expect(find.text('10 / 10'), findsOneWidget);
  });

  testWidgets('%200 metin ölçeği ve 320 px: alanlar taşmaz', (tester) async {
    await pumpDy(tester, const Column(children: [
      DyTextField(label: 'Diyetisyenime bugünkü tüm öğünlerimi onay için gönder', initialValue: 'uzun değer'),
      DyNumberField(label: 'Gramaj', unit: 'g', value: 150),
      DySearchField(label: 'Besin ara', hideLabel: false),
    ]), textScale: 2.0, width: 320);
    expect(tester.takeException(), isNull);
  });

  testWidgets('expectTextContrast düşük kontrastı yakalar', (tester) async {
    await pumpDy(tester, const ColoredBox(color: Color(0xFFFFFFFF), child: Text('soluk', style: TextStyle(color: Color(0xFFBBBBBB)))));
    expect(() => expectTextContrast(tester), throwsA(isA<TestFailure>()));
  });

  testWidgets('kontrast kılavuzu (light ve dark)', (tester) async {
    for (final b in Brightness.values) {
      final h = tester.ensureSemantics();
      await pumpDy(tester, const Column(children: [
        DyTextField(label: 'Ad', description: 'Profilinde görünür'),
        DyTextField(label: 'Kilo', error: 'Geçersiz değer'),
        DyTextField(label: 'Porsiyon', state: DyComponentState.locked, lockedReason: 'Kapalı', initialValue: '1 kase'),
      ]), brightness: b);
      // 12 px açıklama metninde piksel örneklemesi kenar yumuşatmasını ölçüyor (4,35); gerçek çift 6,24:1. Bkz. expectTextContrast.
      expectTextContrast(tester);
      h.dispose();
    }
  });
}
