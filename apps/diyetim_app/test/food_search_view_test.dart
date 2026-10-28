import 'package:diyetim_app/app/router.dart';
import 'package:diyetim_app/features/foods/data/datasource/foods_fake_datasource_imp.dart';
import 'package:diyetim_app/features/foods/domain/data/foods_datasource.dart';
import 'package:diyetim_app/features/foods/domain/entities/food_entity.dart';
import 'package:diyetim_app/features/foods/presentation/views/food_search_view.dart';
import 'package:diyetim_app/helpers/http/exceptions/api_exception.dart';
import 'package:diyetim_app/helpers/url/url_helper.dart';
import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

const _latency = FoodsFakeDataSourceImp.latency;

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(EditableText), text);
  await tester.pump(FoodSearchView.debounce);
}

void main() {
  setUp(resetDi);

  testWidgets('başta ipucu; 1 harfte istek yok', (tester) async {
    final source = _CountingFoods();
    replaceDi<FoodsDataSource>(source);
    await pumpApp(tester, location: Paths.foodSearch);
    await tester.pump();
    expect(find.text('Ne yedin?'), findsOneWidget);
    await _type(tester, 'm');
    await pumpPast(tester, _latency);
    expect(source.queries, isEmpty);
    expect(find.text('Ne yedin?'), findsOneWidget);
  });

  testWidgets('yazma durunca tek istek; sonuçlar, sayı ve atıf', (tester) async {
    final source = _CountingFoods();
    replaceDi<FoodsDataSource>(source);
    await pumpApp(tester, location: Paths.foodSearch);
    await tester.pump();
    for (final partial in ['me', 'mer', 'merc']) {
      await tester.enterText(find.byType(EditableText), partial);
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pump(FoodSearchView.debounce);
    await pumpPast(tester, _latency);
    expect(source.queries, ['merc'], reason: 'ara tuşlar backend\'e gitmez');
    expect(find.text('4 sonuç'), findsOneWidget);
    expect(find.text('Mercimek çorbası'), findsOneWidget);
    expect(find.text('Powered by fatsecret'), findsOneWidget);
    expect(find.text('1 kase (250 g) başına'), findsOneWidget);
  });

  testWidgets('Türkçe büyük harfle arama (İ/I) eşleşir', (tester) async {
    await pumpApp(tester, location: Paths.foodSearch);
    await tester.pump();
    await _type(tester, 'IZGARA');
    await pumpPast(tester, _latency);
    expect(find.text('Izgara tavuk göğsü'), findsOneWidget);
  });

  testWidgets('sonuç yoksa boş durum, sorgu metinde', (tester) async {
    await pumpApp(tester, location: Paths.foodSearch);
    await tester.pump();
    await _type(tester, 'xyzq');
    await pumpPast(tester, _latency);
    expect(find.text('“xyzq” için sonuç yok'), findsOneWidget);
  });

  testWidgets('kota dolu: özel metin, yeniden deneme yok, "Tekrar dene" yeniden ister', (tester) async {
    final source = _CountingFoods(fail: const ApiException(ApiErrorCode.quotaExceeded));
    replaceDi<FoodsDataSource>(source);
    await pumpApp(tester, location: Paths.foodSearch);
    await tester.pump();
    await _type(tester, 'mercimek');
    await pumpPast(tester, const Duration(seconds: 2));
    expect(find.text('Besin arama şu an yoğun'), findsOneWidget);
    expect(source.queries.length, 1, reason: 'kota hatası otomatik yeniden denenmez');
    source.fail = null;
    await tester.tap(find.text('Tekrar dene'));
    await pumpPast(tester, _latency);
    expect(source.queries.length, 2);
    expect(find.text('Mercimek çorbası'), findsOneWidget);
  });

  testWidgets('yeni arama yüklenirken eski sonuçlar kalır (iskelete dönmez)', (tester) async {
    await pumpApp(tester, location: Paths.foodSearch);
    await tester.pump();
    await _type(tester, 'mercimek');
    await pumpPast(tester, _latency);
    await _type(tester, 'yulaf');
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(DySkeleton), findsNothing);
    expect(find.text('Mercimek çorbası'), findsOneWidget);
    expect(find.byType(DyProgressSweep), findsOneWidget);
    await pumpPast(tester, _latency);
    expect(find.text('Yulaf ezmesi'), findsOneWidget);
    expect(find.text('Mercimek çorbası'), findsNothing);
  });

  testWidgets('"Daha fazla göster" sonraki sayfayı ekler, sonra kaybolur', (tester) async {
    replaceDi<FoodsDataSource>(_PagedFoods());
    // Uzun ekran: tüm satırlar kaydırmadan kurulur.
    await pumpApp(tester, location: Paths.foodSearch, size: const Size(390, 3600));
    await tester.pump();
    await _type(tester, 'besin');
    await pumpPast(tester, Duration.zero);
    expect(find.text('Besin 19'), findsOneWidget);
    expect(find.text('Besin 20'), findsNothing);
    await tester.tap(find.text('Daha fazla göster'));
    await pumpPast(tester, Duration.zero);
    expect(find.text('Besin 24'), findsOneWidget);
    expect(find.text('Daha fazla göster'), findsNothing);
  });

  testWidgets('atıf bağlantısı yalnız https açar ve bağlantı olarak okunur', (tester) async {
    final urls = _RecordingUrl();
    replaceDi<UrlHelper>(urls);
    final handle = tester.ensureSemantics();
    await pumpApp(tester, location: Paths.foodSearch);
    await tester.pump();
    await _type(tester, 'elma');
    await pumpPast(tester, _latency);
    final node = tester.getSemantics(find.bySemanticsLabel('Powered by fatsecret (bağlantı)'));
    expect(node.flagsCollection.isLink, isTrue);
    await tester.tap(find.text('Powered by fatsecret'));
    expect(urls.opened, [Uri.parse('https://www.fatsecret.com')]);
    handle.dispose();
  });
}

class _CountingFoods implements FoodsDataSource {
  _CountingFoods({this.fail});
  ApiException? fail;
  final queries = <String>[];
  @override
  Future<FoodSearchPageEntity> search({required String query, required int page, required int pageSize}) async {
    queries.add(query);
    if (fail != null) throw fail!;
    return const FoodsFakeDataSourceImp().search(query: query, page: page, pageSize: pageSize);
  }
}

class _PagedFoods implements FoodsDataSource {
  @override
  Future<FoodSearchPageEntity> search({required String query, required int page, required int pageSize}) async {
    const total = 25;
    final from = page * pageSize;
    return FoodSearchPageEntity(
      query: query,
      page: page,
      pageSize: pageSize,
      totalResults: total,
      items: [
        for (var i = from; i < (from + pageSize).clamp(0, total); i++)
          FoodSummaryEntity(id: '$i', name: 'Besin $i', defaultServing: const ServingEntity(id: 's', description: '100 g', calories: 100, carbohydrate: 10, protein: 5, fat: 2)),
      ],
    );
  }
}

class _RecordingUrl implements UrlHelper {
  final opened = <Uri>[];
  @override
  Future<bool> openExternal(Uri url) async {
    opened.add(url);
    return true;
  }
}
