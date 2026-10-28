import 'package:flutter/widgets.dart';

import 'generated/dy_strings.g.dart';

/// Component metinleri. Uygulama kendi çeviri tablosunu [DyStrings] ile verir; eksik anahtarlar Türkçeye düşer.
class DyStrings extends InheritedWidget {
  const DyStrings({super.key, required this.overrides, required super.child});

  final Map<String, String> overrides;

  /// `DyStrings.of(context).t('offline.pending', {'count': 3})`
  static DyStringTable of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<DyStrings>();
    return DyStringTable(w?.overrides ?? const {});
  }

  @override
  bool updateShouldNotify(DyStrings old) => old.overrides != overrides;
}

class DyStringTable {
  const DyStringTable(this.overrides);
  final Map<String, String> overrides;

  String t(String key, [Map<String, Object> params = const {}]) {
    final raw = overrides[key] ?? DyStringsTr.table[key];
    assert(raw != null, 'Bilinmeyen metin anahtarı: $key');
    return (raw ?? key).replaceAllMapped(RegExp(r'\{(\w+)\}'), (m) => '${params[m.group(1)] ?? m.group(0)}');
  }
}
