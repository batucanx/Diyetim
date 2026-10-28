import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../l10n/gen/app_localizations.dart';
import 'router.dart';

class DiyetimApp extends StatefulWidget {
  const DiyetimApp({super.key, this.router});

  /// Testlerde başka başlangıç konumu vermek için.
  final GoRouter? router;

  @override
  State<DiyetimApp> createState() => _DiyetimAppState();
}

class _DiyetimAppState extends State<DiyetimApp> {
  late final GoRouter _router = widget.router ?? createRouter();

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: DyTheme.light(),
        darkTheme: DyTheme.dark(),
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: _router,
      );
}
