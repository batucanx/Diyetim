import 'dart:ui' show Tristate;

import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('dyInitials (React initials() ile aynı)', () {
    test('Türkçe büyük harf kuralları', () {
      expect(dyInitials('elif yıldız'), 'EY');
      expect(dyInitials('ismail ışık'), 'İI');
      expect(dyInitials('İsmail Işık'), 'İI');
      expect(dyInitials('ayşe'), 'A');
      expect(dyInitials('  '), '?');
    });
  });

  test('StatCard değişim biçimi: işaret, U+2212, NBSP birim', () {
    expect(DyStatCard.formatDelta(4, unit: 'puan'), '+4${DyFormat.nbsp}puan');
    expect(DyStatCard.formatDelta(-1.25), '−1,3');
    expect(DyStatCard.formatDelta(0), '0');
  });

  testWidgets('DyCard: etkileşimli kart buton semantiği, Enter ile tetiklenir', (tester) async {
    var taps = 0;
    await pumpDy(tester, DyCard(onTap: () => taps++, semanticLabel: 'Elif Yıldız', child: const Text('Elif')));
    expect(find.bySemanticsLabel('Elif Yıldız'), findsOneWidget);
    await tester.tap(find.byType(DyCard));
    expect(taps, 1);
    await tab(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(taps, 2);
  });

  testWidgets('DyCard: kilitli kart tetiklenmez', (tester) async {
    var taps = 0;
    await pumpDy(tester, DyCard(onTap: () => taps++, state: DyComponentState.locked, lockedReason: 'Yetki yok', child: const Text('Tahlil')));
    await tester.tap(find.byType(DyCard));
    expect(taps, 0);
  });

  testWidgets('DyListItem: tıklanabilir satır ve yön oku; statik satırda ok yok', (tester) async {
    var tapped = false;
    await pumpDy(tester, DyList(children: [
      DyListItem(title: 'Kahvaltı', description: 'Yulaf, yoğurt', onTap: () => tapped = true),
      const DyListItem(title: 'Akşam', trailing: Text('—')),
    ]));
    expect(find.byType(DyIcon), findsOneWidget);
    await tester.tap(find.text('Kahvaltı'));
    expect(tapped, isTrue);
  });

  testWidgets('DyAvatar: ad okunur, doğrulama rozeti, dekoratif mod', (tester) async {
    await pumpDy(tester, const Row(children: [DyAvatar(name: 'Zeynep Kaya', verified: true), DyAvatar(name: 'Ali Can', decorative: true)]));
    expect(find.bySemanticsLabel('Zeynep Kaya, doğrulanmış'), findsOneWidget);
    expect(find.text('ZK'), findsOneWidget);
    expect(find.bySemanticsLabel('Ali Can'), findsNothing);
  });

  testWidgets('DyAvatarGroup: +N özeti çeviri anahtarından', (tester) async {
    await pumpDy(tester, const DyAvatarGroup(label: 'Bugünkü randevular', max: 3, people: [
      DyAvatarPerson(name: 'A B'), DyAvatarPerson(name: 'C D'), DyAvatarPerson(name: 'E F'), DyAvatarPerson(name: 'G H'), DyAvatarPerson(name: 'I J'),
    ]));
    expect(find.text('+2'), findsOneWidget);
    expect(find.bySemanticsLabel('2 kişi daha'), findsOneWidget);
  });

  testWidgets('DyProgressBar: değer metni; hedef aşımında dolu kalır', (tester) async {
    await pumpDy(tester, const Column(children: [
      DyProgressBar(value: 68, max: 120, label: 'Protein', valueText: '68 / 120 g', showLabel: true, tone: DyProgressTone.protein),
      DyProgressBar(value: 150, max: 120, label: 'Karb.', valueText: '150 / 120 g'),
    ]));
    final sem = tester.getSemantics(find.bySemanticsLabel('Protein'));
    expect(sem.value, '68 / 120 g');
    final over = tester.widget<FractionallySizedBox>(find.descendant(of: find.bySemanticsLabel('Karb.'), matching: find.byType(FractionallySizedBox)));
    expect(over.widthFactor, 1.0);
  });

  testWidgets('DyProgressBar belirsiz: hareket azaltıldığında sabit, zamanlayıcı bırakmaz', (tester) async {
    await pumpDy(tester, const DyProgressBar(value: null, label: 'Yükleniyor'), disableAnimations: true);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('DyProgressRing: valuetext okunur, orta içerik semantikten çıkarılır', (tester) async {
    await pumpDy(tester, const DyProgressRing(value: 859, max: 1800, label: 'Kalori', valueText: '859 / 1.800 kcal', child: Text('%48')));
    expect(tester.getSemantics(find.bySemanticsLabel('Kalori')).value, '859 / 1.800 kcal');
  });

  testWidgets('DyStatCard: gizli metrikte değişim gösterilmez', (tester) async {
    await pumpDy(tester, const Column(children: [
      DyStatCard(label: 'Uyum', value: 86, unit: '%', delta: 4, deltaUnit: 'puan', deltaIntent: DyDeltaIntent.increaseIsGood),
      DyStatCard(label: 'Kilo', value: null, visibility: DyVisibility.hidden, delta: -1.2),
    ]));
    expect(find.text('+4${DyFormat.nbsp}puan'), findsOneWidget);
    expect(find.text('−1,2'), findsNothing);
    expect(find.text('Gizli'), findsOneWidget);
  });

  testWidgets('DyFilterChips: seçim, toggled semantiği ve Temizle', (tester) async {
    var values = <String>{};
    await pumpDy(tester, StatefulBuilder(builder: (context, set) => DyFilterChips(
          label: 'Durum',
          options: const [DyFilterOption(value: 'a', label: 'Dikkat', count: 4), DyFilterOption(value: 'n', label: 'Yeni')],
          values: values,
          onChanged: (v) => set(() => values = v),
        )));
    expect(find.text('Temizle'), findsNothing);
    await tester.tap(find.text('Dikkat'));
    await tester.pumpAndSettle();
    expect(values, {'a'});
    expect(tester.getSemantics(find.bySemanticsLabel('Dikkat, 4')).flagsCollection.isToggled, Tristate.isTrue);
    await tester.tap(find.text('Temizle'));
    await tester.pumpAndSettle();
    expect(values, isEmpty);
  });

  for (final b in Brightness.values) {
    testWidgets('Grup E %200 metin, 320 px: taşma yok (${b.name})', (tester) async {
      await pumpDy(tester, Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: DySpacing.md, children: [
        DyCard(child: Column(children: [
          DyCardHeader(title: 'Bugünkü plan', subtitle: '4 öğün · 1.800 kcal hedef', action: DyButton(label: 'Düzenle', size: DyButtonSize.sm, onPressed: () {})),
          DyListItem(title: 'Öğle yemeği', description: 'Diyetisyenime bugünkü tüm öğünlerimi onay için gönder; ğüşıöç İİ', trailing: const Text('540 kcal'), onTap: () {}),
        ])),
        const DyStatCard(label: 'Ortalama plana uyum', value: 86, unit: '%', delta: 0, deltaContext: 'geçen hafta ile aynı'),
        const DyProgressBar(value: 71, max: 60, label: 'Yağ', valueText: '71 / 60 g · hedefin üstünde', showLabel: true, tone: DyProgressTone.fat),
        const DyProgressRing(value: 859, max: 1800, label: 'Kalori', child: Text('941 kcal kaldı')),
        const DyAvatarGroup(label: 'Randevular', people: [DyAvatarPerson(name: 'Elif Yıldız'), DyAvatarPerson(name: 'Şule Demir'), DyAvatarPerson(name: 'İsmail Işık'), DyAvatarPerson(name: 'Ömer Çelik')]),
      ]), brightness: b, textScale: 2.0, width: 320, height: 2400);
      expect(tester.takeException(), isNull);
    });
  }
}
