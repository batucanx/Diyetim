# Faz 2 raporu: çekirdek component kütüphaneleri

Tarih: 28 Ekim 2026 · Depo: `diyetim-design-system` · Son commit'ler: `adc1604` (token hattı) → `7b662cc` (Grup E Flutter + entegrasyon)

## Özet

| | Durum |
| --- | --- |
| Faz 1 token doğrulaması | Tamam (aşağıda ölçülenler ve ölçülemeyenler) |
| Grup A — primitives | Web ✅ test edildi · Flutter ✅ yazıldı, analiz temiz, test çalıştırılamadı |
| Grup B — form kontrolleri | aynı |
| Grup C — durum ve geri bildirim | aynı |
| Grup D — navigasyon ve katmanlar | aynı |
| Grup E — veri sunumu | aynı (DataTable, Pagination yalnız web — bilinçli) |
| Entegrasyon denetimi ("Bugün" birleşimi) | Web tarayıcıda test edildi · Flutter testi yazıldı |
| Dokümantasyon | 8 component belgesi + parite + bu rapor |

"Tamam" yalnızca web için gerçek test sonucu demektir. Flutter tarafında hiçbir widget veya golden testi bu ortamda çalıştırılmadı; bunu "geçti" olarak sunmuyorum.

## Çalıştırılan testler (bu oturumda, son durum)

| Komut | Sonuç |
| --- | --- |
| `pnpm tokens:check` | 15 üretilmiş dosya kaynakla aynı |
| `pnpm test:tokens` (node --test) | **88 geçti, 0 başarısız** — kontrast (light/dark), CSS↔Dart parite, kaynak bütünlüğü, elle değiştirilmiş dosya tespiti |
| `pnpm typecheck` | temiz (ui, tokens, catalog) |
| `pnpm test:web` (Vitest + RTL + axe/jsdom) | **206 geçti**, 10 dosya — ham değer yasağı (42), biçim, primitives, button, alanlar, select, seçim, geri bildirim, navigasyon, veri |
| Playwright (Chromium) | **175 geçti** — 94 görsel referans (22 hikâye × light/dark × 390/1280 px + açık select ve dialog durumları), 81 kalite testi: axe kontrast dahil iki temada, %200 metin + 320 px taşma, metin kırpılması, tarayıcıda token paritesi, sistem dark modu, Nunito yüklenmesi, tabular rakam, 2 px odak halkası rengi, dokunma hedefi, hareket azaltma, Snackbar, Tooltip, Dialog odak tuzağı, Menu, Sidebar genişlikleri |
| `dart analyze` | dy_tokens, dy_ui, dy_health, dy_gallery: **sorun yok** (Dart 3.13.7 + Flutter stable kaynakları) |

Görsel referanslar her güncellemeden önce gözle incelendi; bu fazda referans incelemesi şu gerçek hataları yakaladı: dar ekranda tablo kart düzeni (etiket tekrarı, boş satır), seçili satırda avatarın kaybolması, mobilde yükleme iskeletinin görünmemesi ve satır ayraçlarının taşması, ProgressBar değerinin birimden bölünmesi, ListItem'da durum etiketinin başlığı sıkıştırması (→ yeni `meta` alanı). axe ise Chip sayaç kontrastını ve etkileşimli kart içindeki iç içe kontrolü buldu. Hepsi düzeltildi; hiçbir test devre dışı bırakılmadı veya eşik gevşetilmedi. Tek test değişikliği: taşma ölçümünün görsel olarak kırpılmış (ekran okuyucuya açık) kapsayıcıları saymaması — `.dy-visually-hidden` için zaten olan istisnanın aynısı.

## Faz 1 token doğrulaması

| Kontrol | Sonuç | Nasıl |
| --- | --- | --- |
| DTCG tek kaynak | ✅ | `tokens/*.json` → 15 dosya; renk rampaları ayrı üreteçten yalnız `primitive.color.json`'a |
| Dart ↔ CSS paritesi | ✅ | token testleri + tarayıcıda `getComputedStyle` = `resolved.json` |
| Üretilmiş dosyaya elle müdahale engeli | ✅ | hash başlığı + `--check`; testle kanıtlandı |
| Token değişikliğinin iki platforma akışı | ✅ | `radius.lg` 18→20 denendi, geri alındı (bkz. parite belgesi) |
| Light/Dark | ✅ web | iki tema tüm hikâyelerde görsel referans + axe |
| Otomatik kontrast | ✅ | token düzeyinde 4.5:1 / 3:1 çiftleri + tarayıcıda axe |
| Nunito Türkçe karakterler | ✅ | 18 karakterin tümü var (fontTools raporu) |
| Tabular rakam | ✅ (not ile) | `tnum` özelliği yok; varsayılan rakamlar 400–800'de eşit genişlik (600 birim) — pratikte tabular |
| U+202F | ⚠️ yok | Nunito'da dar bölünmez boşluk yok → yalnız U+00A0 kullanılıyor |
| %200 metin ölçeği | ✅ web · ⏳ Flutter | tarayıcıda 320 px'te ölçüldü; Flutter widget testleri yazıldı |
| Uzun Türkçe metin, dar ekran | ✅ web | `LONG` örnek metni tüm ilgili hikâyelerde; kırpılma testi |

## Doğrulanamayanlar (açıkça)

1. **Flutter widget, semantik ve golden testleri çalıştırılmadı.** Ortamda Flutter motoru (`flutter_tester`) yok; testler gerçek Flutter kaynaklarına karşı derleme düzeyinde analiz edildi. İlk iş: `cd packages/flutter/dy_ui && flutter test`, ardından `flutter test --update-goldens --tags golden` ve referansların gözle incelenmesi. `dy_gallery` içindeki entegrasyon testi de aynı şekilde.
2. **Flutter'da gerçek cihazda %200 ölçek, TalkBack/VoiceOver** denenmedi.
3. **Widgetbook çalışırken** görülmedi (yalnız analiz; widgetbook 3.25 API'sine göre yazıldı).
4. **Web'de ekran okuyucu ile elle test** yapılmadı; axe ve rol/ad testleri var, NVDA/VoiceOver denemesi yok.
5. Görsel referanslar yalnız Chromium'da; Safari/Firefox çalıştırılmadı.

## Teknik borç

- Web paketinin `exports` alanı tip ve CSS için `src/`'yi gösteriyor (monorepo içi kullanım için yeterli); yayımlanacaksa `dist` tipleri ve derlenmiş CSS'e geçmeli.
- Katalog özel bir Vite uygulaması (Storybook değil). Belgeler Markdown'da; etkileşimli prop tablosu yok.
- Flutter golden'ları için font yükleme yardımcısı test ortamında doğrulanmadı.
- İngilizce çeviri dosyası yok; anahtar yapısı hazır (`spec/i18n/tr.json`).
- React Avatar `status` noktasının Flutter karşılığı yok.
- Etkileşimli kart içinde ikinci kontrol Flutter'da yalnız belge kuralı (web'de geliştirme uyarısı).
- DataTable: sanal kaydırma, sütun boyutlandırma, satır içi düzenleme yok.
- Görsel referanslar 0,002 piksel farkı toleransıyla karşılaştırılıyor; çok küçük ağırlık değişiklikleri (ör. Chip sayaç kalınlığı) bu toleransın altında kalabiliyor — bu fazda ilgili referanslar elle yenilendi.

## Faz 3 bağımlılıkları

- **Besin veri kaynağı kararı** (TÜRKOMP / FatSecret Platform API / USDA FoodData Central): besin arama sonuç satırı, porsiyon birimleri ve makro alanları buna bağlı. Lisans ve doğruluk değerlendirmesi bekleniyor.
- **Tarih/saat seçiciler** ve randevu takvimi: bu fazın kapsamında değildi.
- **Grafikler** (kilo trendi, haftalık uyum): ayrı component; renkler `macro.*` ve semantic token'lardan.
- **Alan kartları**: öğün kartı, randevu kartı, tahlil değeri satırı (`dy_health`); `Card`, `ListItem.meta`, `StatusTag`, `SourceTag`, `ProgressRing` üzerine.
- **AI tahmin kalıbı**: etiket + güven + düzenlenebilir değer (karar 13); `SourceTag ai` hazır, güven göstergesi tasarlanacak.
- **Gizli değerler**: istemci "Gizli" gösterimi hazır; API'nin bu alanları hiç göndermemesi backend sözleşmesinde yazılmalı.
- Gerçek "Bugün" ekranının içerik hiyerarşisi (buradaki birleşim yalnız entegrasyon denetimidir, tasarım değildir).
