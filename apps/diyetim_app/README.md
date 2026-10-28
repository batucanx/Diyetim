# Diyetim danışan uygulaması

Flutter (Android, iOS). Arayüz yalnız `dy_ui` component'leri ve token'larıyla kurulur (tasarım sistemi:
`diyetim-design-system-faz2/diyetim-design-system`). Kararlar: `docs/decisions/`, API sözleşmesi: `docs/api/openapi.yaml`.

## Çalıştırma

Backend henüz yok. Adres verilmezse uygulama sözleşmeye uyan sahte veriyle çalışır:

```bash
flutter run
```

Gerçek backend ile:

```bash
flutter run --dart-define=DIYETIM_API_BASE_URL=https://api.ornek.com
```

## Kod üretimi ve doğrulama

```bash
dart run build_runner build --delete-conflicting-outputs   # freezed, riverpod, injectable
flutter analyze
flutter test                                              # birim + ekran + kalite + golden
flutter test --update-goldens --tags golden               # görsel referansları yenile (sonra gözle incele)
```

## Yapı

```
lib/
  app/              MaterialApp, go_router, Riverpod yeniden deneme kuralı
  infrastructure/   Usecase tabanı, DI (get_it + injectable), AppConfig
  helpers/          Paket soyutlamaları: http (dio), url (url_launcher)
  features/<özellik>/{domain,data,presentation}   DDP katmanları
  shared/           Ekranlar arası küçük yardımcılar
  l10n/             app_tr.arb → gen/ (flutter gen-l10n)
```

- Ortamlar: `fake` (sahte veri kaynakları) ve `remote` (gerçek backend). Seçim `AppConfig.useFakeData`.
- Sahte veri kaynakları sözleşme JSON'unu gerçek ayrıştırıcıdan geçirir; besin değerleri yaklaşık örnektir.
- Riverpod 3'ün varsayılan 10 sessiz yeniden denemesi kapalı: yalnız ağ/zaman aşımı hatası bir kez, 1 sn sonra
  (`lib/app/provider_retry.dart`). Kota ve sunucu hataları kullanıcıya gösterilir.
- `flutter_screenutil` kullanılmaz (projenin `flutter-architecture` skill'inden bilinçli sapma): ölçüler token'lardan
  gelir, metin ölçeği sistem ayarına bırakılır.
