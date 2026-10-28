import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets('Checkbox: dokunma değiştirir; checked semantiği', (tester) async {
    var v = false;
    await pumpDy(tester, StatefulBuilder(builder: (c, set) => DyCheckbox(label: 'Hatırlatma al', value: v, onChanged: (x) => set(() => v = x))));
    await tester.tap(find.text('Hatırlatma al'));
    await tester.pump();
    expect(v, isTrue);
    expect(tester.getSemantics(find.byType(DyPressable)), matchesSemantics(label: 'Hatırlatma al', hasCheckedState: true, isChecked: true, hasEnabledState: true, isEnabled: true, isFocusable: true, hasTapAction: true));
  });

  testWidgets('Checkbox locked değişmez', (tester) async {
    var n = 0;
    await pumpDy(tester, DyCheckbox(label: 'Fotoğraf zorunlu', value: true, state: DyComponentState.locked, lockedReason: 'Klinik ayarı', onChanged: (_) => n++));
    await tester.tap(find.text('Fotoğraf zorunlu'));
    expect(n, 0);
    expect(find.text('Klinik ayarı'), findsOneWidget);
  });

  testWidgets('RadioGroup: seçim ve ok tuşu', (tester) async {
    String v = 'online';
    await pumpDy(tester, StatefulBuilder(builder: (c, set) => DyRadioGroup<String>(
          label: 'Görüşme tipi',
          value: v,
          onChanged: (x) => set(() => v = x),
          options: const [DyRadioOption(value: 'online', label: 'Online'), DyRadioOption(value: 'clinic', label: 'Yüz yüze'), DyRadioOption(value: 'phone', label: 'Telefon', enabled: false)],
        )));
    await tester.tap(find.text('Yüz yüze'));
    await tester.pump();
    expect(v, 'clinic');
    await tab(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(v, 'online', reason: 'devre dışı seçenek atlanır ve başa sarar');
  });

  testWidgets('Switch: toggled semantiği; loading değişmez', (tester) async {
    var v = false;
    await pumpDy(tester, StatefulBuilder(builder: (c, set) => Column(children: [
          DySwitch(label: 'Kalori değerleri', value: v, onChanged: (x) => set(() => v = x)),
          DySwitch(label: 'Kaydediliyor', value: true, state: DyComponentState.loading, onChanged: (_) => fail('tetiklenmemeli')),
        ])));
    await tester.tap(find.text('Kalori değerleri'));
    await tester.pump();
    expect(v, isTrue);
    await tester.tap(find.text('Kaydediliyor'));
  });

  testWidgets('SegmentedControl: seçim ve ok tuşları', (tester) async {
    var v = 'w';
    await pumpDy(tester, StatefulBuilder(builder: (c, set) => DySegmentedControl<String>(
          label: 'Dönem',
          value: v,
          onChanged: (x) => set(() => v = x),
          segments: const [DySegment(value: 'd', label: 'Gün'), DySegment(value: 'w', label: 'Hafta'), DySegment(value: 'm', label: 'Ay')],
        )));
    await tester.tap(find.text('Ay'));
    await tester.pumpAndSettle();
    expect(v, 'm');
    await tab(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(v, 'd');
  });

  testWidgets('Select: alttan açılan sayfadan seçim', (tester) async {
    String? v;
    await pumpDy(tester, StatefulBuilder(builder: (c, set) => DySelect<String>(
          label: 'Öğün tipi',
          value: v,
          onChanged: (x) => set(() => v = x),
          options: const [DySelectOption(value: 'b', label: 'Kahvaltı'), DySelectOption(value: 'l', label: 'Öğle yemeği')],
        )));
    await tester.tap(find.text('Seçin'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Öğle yemeği'));
    await tester.pumpAndSettle();
    expect(v, 'l');
    expect(find.text('Öğle yemeği'), findsOneWidget);
  });

  testWidgets('MultiSelect: seçimler ve özet', (tester) async {
    var v = <String>{};
    await pumpDy(tester, StatefulBuilder(builder: (c, set) => DyMultiSelect<String>(
          label: 'Kategoriler',
          values: v,
          onChanged: (x) => set(() => v = x),
          options: const [DySelectOption(value: 'a', label: 'Süt'), DySelectOption(value: 'b', label: 'Sebze'), DySelectOption(value: 'c', label: 'Tahıl')],
        )));
    await tester.tap(find.text('Seçin'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Süt'));
    await tester.tap(find.text('Sebze'));
    await tester.tap(find.text('Tahıl'));
    await tester.pump();
    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
    expect(v, {'a', 'b', 'c'});
    expect(find.text('3 seçili'), findsOneWidget);
  });

  testWidgets('Select locked açılmaz', (tester) async {
    await pumpDy(tester, const DySelect<String>(label: 'Öğün', value: null, state: DyComponentState.locked, lockedReason: 'Diyetisyen belirledi', options: [DySelectOption(value: 'b', label: 'Kahvaltı')]));
    await tester.tap(find.text('Seçin'));
    await tester.pumpAndSettle();
    expect(find.text('Kahvaltı'), findsNothing);
  });

  testWidgets('dokunma hedefi ve kontrast kılavuzları', (tester) async {
    for (final b in Brightness.values) {
      final h = tester.ensureSemantics();
      await pumpDy(tester, Column(children: [
        DyCheckbox(label: 'A', value: true, onChanged: (_) {}),
        DySwitch(label: 'B', value: false, onChanged: (_) {}),
        DyRadioGroup<String>(label: 'C', value: 'x', onChanged: (_) {}, options: const [DyRadioOption(value: 'x', label: 'X'), DyRadioOption(value: 'y', label: 'Y')]),
      ]), brightness: b);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      h.dispose();
    }
  });
}
