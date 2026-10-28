import 'package:diyetim_app/app/app.dart';
import 'package:diyetim_app/app/provider_retry.dart';
import 'package:diyetim_app/app/router.dart';
import 'package:diyetim_app/infrastructure/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Her test sahte ortamla temiz bir DI ile başlar.
Future<void> resetDi() async {
  await sl.reset();
  configureDependencies(Env.fake);
}

/// Tek bir bağımlılığı (ör. hata veren veri kaynağı) değiştirir; [resetDi]'den sonra, ilk kullanımdan önce çağrılır.
void replaceDi<T extends Object>(T instance) {
  sl.unregister<T>();
  sl.registerSingleton<T>(instance);
}

/// Uygulamayı verilen konumda, tema / metin ölçeği / ekran boyutuyla çizer.
Future<void> pumpApp(
  WidgetTester tester, {
  String location = Paths.today,
  Brightness brightness = Brightness.light,
  double textScale = 1,
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size * tester.view.devicePixelRatio;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  tester.platformDispatcher.platformBrightnessTestValue = brightness;
  addTearDown(tester.platformDispatcher.clearAllTestValues);
  final router = GoRouter(initialLocation: location, routes: createRouter().configuration.routes);
  addTearDown(router.dispose);
  await tester.pumpWidget(ProviderScope(retry: providerRetry, child: DiyetimApp(router: router)));
}

/// Sahte veri kaynağının gecikmesini geçirir (iskelet animasyonu sürekli olduğu için pumpAndSettle kullanılmaz).
Future<void> pumpPast(WidgetTester tester, Duration latency) async {
  await tester.pump(latency + const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 400));
}
