import 'package:diyetim_app/features/today/data/datasource/today_fake_datasource_imp.dart';
import 'package:diyetim_app/features/today/data/dto/rest_today_model.dart';
import 'package:diyetim_app/features/today/domain/data/today_datasource.dart';
import 'package:diyetim_app/features/today/domain/entities/today_entity.dart';
import 'package:diyetim_app/features/today/presentation/widgets/dietitian_note_card.dart';
import 'package:diyetim_app/helpers/http/exceptions/api_exception.dart';
import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

const _latency = TodayFakeDataSourceImp.latency;

void main() {
  setUp(resetDi);

  testWidgets('önce iskelet, sonra içerik; diyetisyen notu öğünlerin üstünde (karar 0002)', (tester) async {
    await pumpApp(tester);
    await tester.pump();
    expect(find.byType(DySkeleton), findsWidgets);
    expect(find.bySemanticsLabel(RegExp('Bugünün planı: Yükleniyor')), findsOneWidget);

    await pumpPast(tester, _latency);
    expect(find.byType(DySkeleton), findsNothing);
    final noteY = tester.getTopLeft(find.text('Diyetisyeninden not')).dy;
    final cardY = tester.getTopLeft(find.byType(DietitianNoteCard)).dy;
    final mealsY = tester.getTopLeft(find.text('Öğünler')).dy;
    expect(noteY, lessThan(cardY));
    expect(cardY, lessThan(mealsY));
    expect(find.text('Dyt. Elif Yıldız'), findsOneWidget);
    expect(find.text('2 saat önce'), findsOneWidget);
    expect(find.text('Kahvaltı'), findsOneWidget);
  });

  testWidgets('not yoksa bölüm hiç çizilmez', (tester) async {
    final json = TodayFakeDataSourceImp.sampleJson(DateTime.now())..['dietitianNote'] = null;
    replaceDi<TodayDataSource>(_StaticToday(RestTodayModel.fromJson(json)));
    await pumpApp(tester);
    await pumpPast(tester, Duration.zero);
    expect(find.text('Diyetisyeninden not'), findsNothing);
    expect(find.byType(DietitianNoteCard), findsNothing);
    expect(find.text('Öğünler'), findsOneWidget);
  });

  testWidgets('öğün yoksa boş durum', (tester) async {
    final json = TodayFakeDataSourceImp.sampleJson(DateTime.now())..['meals'] = <Object?>[];
    replaceDi<TodayDataSource>(_StaticToday(RestTodayModel.fromJson(json)));
    await pumpApp(tester);
    await pumpPast(tester, Duration.zero);
    expect(find.text('Bugün için öğün yok'), findsOneWidget);
  });

  testWidgets('gizli kalori "Gizli" okunur, değer yazılmaz; durum ve kalori satırda', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester);
    await pumpPast(tester, _latency);
    await tester.scrollUntilVisible(find.text('Akşam yemeği'), 200);
    final dinner = find.ancestor(of: find.text('Akşam yemeği'), matching: find.byType(DyListItem));
    expect(find.descendant(of: dinner, matching: find.text('Gizli')), findsOneWidget);
    expect(find.descendant(of: dinner, matching: find.textContaining('kcal')), findsNothing);
    final breakfast = find.ancestor(of: find.text('Kahvaltı'), matching: find.byType(DyListItem));
    expect(find.descendant(of: breakfast, matching: find.byType(DyStatusTag)), findsOneWidget);
    expect(find.descendant(of: breakfast, matching: find.textContaining('420')), findsOneWidget);
    handle.dispose();
  });

  testWidgets('uzun not 4 satırda kesilir, "Devamını oku" ile açılır ve kapanır', (tester) async {
    await pumpApp(tester, size: const Size(320, 844));
    await pumpPast(tester, _latency);
    Text noteText() => tester.widget<Text>(find.textContaining('Bu hafta proteinin'));
    expect(noteText().maxLines, DietitianNoteCard.collapsedLines);
    await tester.tap(find.text('Devamını oku'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(noteText().maxLines, isNull);
    await tester.tap(find.text('Daha az göster'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(noteText().maxLines, DietitianNoteCard.collapsedLines);
  });

  testWidgets('kısa notta "Devamını oku" görünmez', (tester) async {
    final json = TodayFakeDataSourceImp.sampleJson(DateTime.now());
    (json['dietitianNote']! as Map<String, Object?>)['text'] = 'Su hedefin 2,5 litre.';
    replaceDi<TodayDataSource>(_StaticToday(RestTodayModel.fromJson(json)));
    await pumpApp(tester);
    await pumpPast(tester, Duration.zero);
    expect(find.text('Devamını oku'), findsNothing);
  });

  testWidgets('ağ hatası: bir kez sessizce yeniden denenir, sonra hata durumu; "Tekrar dene" yeniden yükler', (tester) async {
    final source = _FailingToday(failures: 2);
    replaceDi<TodayDataSource>(source);
    await pumpApp(tester);
    await pumpPast(tester, Duration.zero);
    expect(find.byType(DyErrorState), findsNothing, reason: 'ilk hatada 1 sn sonra tek yeniden deneme');
    await pumpPast(tester, const Duration(seconds: 1));
    expect(source.calls, 2);
    expect(find.byType(DyErrorState), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(source.calls, 2, reason: 'ikinci yeniden deneme yok');
    await tester.tap(find.text('Tekrar dene'));
    await pumpPast(tester, _latency);
    expect(source.calls, 3);
    expect(find.byType(DyErrorState), findsNothing);
    expect(find.text('Kahvaltı'), findsOneWidget);
  });

  testWidgets('sunucu hatası yeniden denenmez', (tester) async {
    final source = _FailingToday(failures: 99, code: ApiErrorCode.internal);
    replaceDi<TodayDataSource>(source);
    await pumpApp(tester);
    await pumpPast(tester, const Duration(seconds: 3));
    expect(source.calls, 1);
    expect(find.byType(DyErrorState), findsOneWidget);
  });

  testWidgets('arama ikonu besin aramasına götürür', (tester) async {
    await pumpApp(tester);
    await pumpPast(tester, _latency);
    await tester.tap(find.bySemanticsLabel('Besin ara'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Ne yedin?'), findsOneWidget);
  });
}

class _StaticToday implements TodayDataSource {
  _StaticToday(this.today);
  final TodayEntity today;
  @override
  Future<TodayEntity> getToday({DateTime? date}) async => today;
}

class _FailingToday implements TodayDataSource {
  _FailingToday({required this.failures, this.code = ApiErrorCode.network});
  final int failures;
  final ApiErrorCode code;
  int calls = 0;
  @override
  Future<TodayEntity> getToday({DateTime? date}) async {
    calls++;
    if (calls <= failures) throw ApiException(code);
    return const TodayFakeDataSourceImp().getToday(date: date);
  }
}
