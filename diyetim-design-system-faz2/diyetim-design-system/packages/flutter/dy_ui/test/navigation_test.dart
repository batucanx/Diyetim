import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  const dests = [
    DyNavDestination(label: 'Bugün', icon: DyIcons.home),
    DyNavDestination(label: 'Plan', icon: DyIcons.plan),
    DyNavDestination(label: 'İlerleme', icon: DyIcons.chart),
    DyNavDestination(label: 'Profil', icon: DyIcons.user, badge: 2, badgeLabel: '2 yeni not'),
  ];

  testWidgets('AppBar: başlık header, geri butonu', (tester) async {
    var back = 0;
    await pumpDy(tester, DyAppBar(title: 'Öğün detayı', onBack: () => back++));
    expect(tester.getSemantics(find.text('Öğün detayı')), matchesSemantics(label: 'Öğün detayı', isHeader: true));
    await tester.tap(find.bySemanticsLabel('Geri'));
    expect(back, 1);
  });

  testWidgets('BottomNavigation: seçim, seçili semantiği, orta eylem, rozet etikette', (tester) async {
    var sel = 0, cam = 0;
    await pumpDy(tester, StatefulBuilder(builder: (c, set) => DyBottomNavigation(
          destinations: dests,
          selectedIndex: sel,
          onSelected: (i) => set(() => sel = i),
          centerAction: DyIcons.camera,
          centerActionLabel: 'Öğün fotoğrafı çek',
          onCenterAction: () => cam++,
        )));
    await tester.tap(find.text('İlerleme'));
    await tester.pump();
    expect(sel, 2);
    await tester.tap(find.bySemanticsLabel('Öğün fotoğrafı çek'));
    expect(cam, 1);
    expect(find.bySemanticsLabel('Profil, 2 yeni not'), findsOneWidget);
  });

  testWidgets('Tabs: dokunma ve ok tuşları, devre dışı atlanır', (tester) async {
    var sel = 0;
    await pumpDy(tester, StatefulBuilder(builder: (c, set) => DyTabs(
          label: 'Danışan',
          selectedIndex: sel,
          onSelected: (i) => set(() => sel = i),
          tabs: const [DyTab(label: 'Özet'), DyTab(label: 'Günlük', count: 3, countLabel: '3 öğün onay bekliyor'), DyTab(label: 'Plan', enabled: false), DyTab(label: 'Tahliller')],
        )));
    await tester.tap(find.text('Günlük'));
    await tester.pump();
    expect(sel, 1);
    await tab(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(sel, 3);
  });

  testWidgets('Dialog.confirm: onay true, vazgeç false', (tester) async {
    bool? result;
    await pumpDy(tester, Builder(builder: (context) => DyButton(label: 'Sil', onPressed: () async {
          result = await DyDialog.confirm(context, title: 'Randevu iptal edilsin mi?', description: 'Danışana bildirim gidecek.', confirmLabel: 'İptal et', destructive: true);
        })));
    await tester.tap(find.text('Sil'));
    await tester.pumpAndSettle();
    expect(find.text('Randevu iptal edilsin mi?'), findsOneWidget);
    await tester.tap(find.text('İptal et'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
    await tester.tap(find.text('Sil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('BottomSheet başlık ve içerik', (tester) async {
    await pumpDy(tester, Builder(builder: (context) => DyButton(label: 'Filtreler', onPressed: () => DyBottomSheet.show<void>(context, title: 'Filtrele', body: const Text('İçerik')))));
    await tester.tap(find.text('Filtreler'));
    await tester.pumpAndSettle();
    expect(tester.getSemantics(find.text('Filtrele')), matchesSemantics(label: 'Filtrele', isHeader: true));
  });

  testWidgets('Menu: açılır, seçim çalışır', (tester) async {
    var edited = 0;
    await pumpDy(tester, DyMenu(
      entries: [DyMenuEntry(label: 'Düzenle', icon: DyIcons.note, onSelected: () => edited++), DyMenuEntry(label: 'Sil', destructive: true, onSelected: () {})],
      builder: (context, controller) => DyIconButton(icon: DyIcons.more, label: 'Diğer eylemler', onPressed: () => controller.isOpen ? controller.close() : controller.open()),
    ));
    await tester.tap(find.bySemanticsLabel('Diğer eylemler'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Düzenle'));
    await tester.pumpAndSettle();
    expect(edited, 1);
  });

  testWidgets('BottomNavigation %200 ölçek ve 320 px: taşma yok; dokunma hedefi', (tester) async {
    final h = tester.ensureSemantics();
    await pumpDy(tester, DyBottomNavigation(destinations: dests, selectedIndex: 0, onSelected: (_) {}), textScale: 2.0, width: 320);
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    h.dispose();
  });

  testWidgets('AppBar large: Scaffold.appBar yuvasında %100 ölçekte taşmaz (iki tema)', (tester) async {
    for (final b in Brightness.values) {
      await tester.pumpWidget(MaterialApp(
        theme: b == Brightness.light ? DyTheme.light() : DyTheme.dark(),
        home: Scaffold(appBar: DyAppBar(title: 'Bugün', large: true, actions: [DyIconButton(icon: DyIcons.search, label: 'Ara', onPressed: () {})]), body: const SizedBox()),
      ));
      expect(tester.takeException(), isNull);
      expect(find.text('Bugün'), findsOneWidget);
    }
  });
}
