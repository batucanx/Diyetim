import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets('StatusTag tüm öğün durumları çeviri metniyle', (tester) async {
    await pumpDy(tester, Wrap(children: [for (final s in DyMealStatus.values) DyStatusTag(s.style)]));
    expect(find.text('Onay bekliyor'), findsOneWidget);
    expect(find.text('Diyetisyen girdi'), findsOneWidget);
  });

  testWidgets('DyStrings çeviriyi geçersiz kılar, eksik anahtar Türkçeye düşer', (tester) async {
    await pumpDy(tester, DyStrings(overrides: const {'mealStatus.approved': 'Approved'}, child: Column(children: [DyStatusTag(DyMealStatus.approved.style), DyStatusTag(DyMealStatus.skipped.style)])));
    expect(find.text('Approved'), findsOneWidget);
    expect(find.text('Atlandı'), findsOneWidget);
  });

  testWidgets('SourceTag ve Badge', (tester) async {
    await pumpDy(tester, Column(children: [
      for (final s in DyDataSource.values) DySourceTag(s),
      const DyBadge(count: 150, label: '150 okunmamış bildirim'),
      const DyBadge(count: 0, label: 'yok'),
    ]));
    expect(find.text('AI tahmini'), findsOneWidget);
    expect(find.bySemanticsLabel('150 okunmamış bildirim'), findsOneWidget);
    expect(find.text('99+'), findsOneWidget);
    expect(find.bySemanticsLabel('yok'), findsNothing);
  });

  testWidgets('Alert: hata canlı bölge, kapatılabilir', (tester) async {
    var closed = false;
    await pumpDy(tester, DyAlert(title: 'Kaydedilemedi', tone: DyFeedbackTone.error, message: 'Tekrar dene.', onDismiss: () => closed = true));
    expect(find.text('Kaydedilemedi'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Kapat'));
    expect(closed, isTrue);
  });

  testWidgets('Toast: Geri al eylemi', (tester) async {
    var undone = false;
    await pumpDy(tester, Builder(builder: (context) => DyButton(label: 'Göster', onPressed: () => DyToast.show(context, message: 'Öğün kaydedildi', actionLabel: 'Geri al', onAction: () => undone = true))));
    await tester.tap(find.text('Göster'));
    await tester.pumpAndSettle();
    expect(find.text('Öğün kaydedildi'), findsOneWidget);
    await tester.tap(find.text('Geri al'));
    expect(undone, isTrue);
  });

  for (final kind in DyErrorKind.values) {
    testWidgets('ErrorState ${kind.wire}: varsayılan metin ve eylem', (tester) async {
      var n = 0;
      await pumpDy(tester, DyErrorState(kind: kind, onAction: () => n++));
      await tester.tap(find.byType(DyButton));
      expect(n, 1);
      expect(find.byType(Text), findsAtLeastNWidgets(3));
    });
  }

  testWidgets('OfflineState bekleyen sayı', (tester) async {
    await pumpDy(tester, DyOfflineState(pendingCount: 3, onRetry: () {}));
    expect(find.textContaining('3 değişiklik gönderilmeyi bekliyor'), findsOneWidget);
  });

  testWidgets('LoadingRegion: iskelet → içerik', (tester) async {
    const region = DyLoadingRegion(loading: true, label: 'Öğünler', skeleton: DySkeleton(shape: DySkeletonShape.text, lines: 2), child: Text('İçerik'));
    await pumpDy(tester, region, settle: false);
    expect(find.byType(DySkeleton), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Öğünler: Yükleniyor')), findsOneWidget);
    expect(tester.hasRunningAnimations, isTrue, reason: 'parıltı çalışır');
  });

  testWidgets('LoadingRegion: hareketi azalt açıkken parıltı durur', (tester) async {
    await pumpDy(tester, const DyLoadingRegion(loading: true, label: 'Öğünler', skeleton: DySkeleton(), child: Text('İçerik')), disableAnimations: true);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('EmptyState %200 ölçekte taşmaz; kontrast kılavuzu', (tester) async {
    for (final b in Brightness.values) {
      final h = tester.ensureSemantics();
      await pumpDy(tester, Column(children: [
        DyEmptyState(title: 'Bugün için öğün yok', description: 'Diyetisyenin henüz bugünün planını yayınlamadı.', action: DyButton(label: 'Besin ara', onPressed: () {})),
        const DyAlert(title: 'Plan güncellendi', tone: DyFeedbackTone.info),
        const DyAlert(title: 'Fotoğraf gerekli', tone: DyFeedbackTone.warning),
      ]), brightness: b, textScale: 2.0, width: 320, height: 2000);
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      expectTextContrast(tester);
      h.dispose();
    }
  });
}
