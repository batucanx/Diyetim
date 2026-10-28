# Faz 2 raporu: çekirdek component kütüphaneleri

Tarih: 28 Ekim 2026 · Depo: `diyetim-design-system` · Son commit'ler: `adc1604` (token hattı) → `7b662cc` (Grup E Flutter + entegrasyon)

## Özet

| | Durum |
| --- | --- |
| Faz 1 token doğrulaması | Tamam (aşağıda ölçülenler ve ölçülemeyenler) |
| Grup A — primitives | Web ✅ test edildi · Flutter ✅ widget + golden testleri çalıştırıldı (28 Ekim doğrulama turu) |
| Grup B — form kontrolleri | aynı |
| Grup C — durum ve geri bildirim | aynı |
| Grup D — navigasyon ve katmanlar | aynı |
| Grup E — veri sunumu | aynı (DataTable, Pagination yalnız web — bilinçli) |
| Entegrasyon denetimi ("Bugün" birleşimi) | Web tarayıcıda test edildi · Flutter testi çalıştırıldı, geçti |
| Dokümantasyon | 8 component belgesi + parite + bu rapor |

İlk turda Flutter testleri çalıştırılamamıştı. 28 Ekim doğrulama turunda (aşağıda) gerçek Flutter motoruyla çalıştırıldı; ilk çalıştırmada 12 test başarısızdı, 3 gerçek component hatası bulundu ve düzeltildi.

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

## 28 Ekim doğrulama turu (Windows 11, Flutter 3.47.5 / Dart 3.13.4, Node 24, pnpm 10.18)

İlk turun en büyük açığı Flutter testlerinin hiç çalıştırılmamış olmasıydı. Bu turda gerçek Flutter motoruyla çalıştırıldı.

### Sonuçlar

| Komut | Sonuç |
| --- | --- |
| `flutter analyze` (4 paket) | sorun yok |
| `dy_ui`: `flutter test --exclude-tags golden` | **86 geçti** (ilk çalıştırma: 69 geçti, 12 başarısız) |
| `dy_ui`: `flutter test --tags golden` | **16 geçti** — referanslar ilk kez üretildi ve tek tek gözle incelendi (`test/goldens/`) |
| `dy_health`: `flutter test` | 3 geçti |
| `dy_gallery`: `flutter test` (Bugün entegrasyonu, 2 tema × 1,0/2,0 × 320/390 px) | **8 geçti** (ilk çalıştırma: 4 başarısız) |
| `tokens:check` | 15 üretilmiş dosya kaynakla aynı |
| `test:tokens` | 88 geçti |
| `typecheck` | temiz |
| `test:web` (Vitest + RTL) | 206 geçti (field.css değişikliğinden sonra yeniden) |
| Playwright | **çalıştırılmadı** — bkz. Doğrulanamayanlar |

### Bulunan ve düzeltilen gerçek hatalar

1. **Stilsiz metin Nunito'yu kullanmıyordu (Flutter).** `DyTheme`, `TextStyle.fontFamily`'yi (zaten `packages/dy_tokens/Nunito`) `package:` ile yeniden önekliyordu → `packages/dy_tokens/packages/dy_tokens/Nunito`. Uygulamada `Text('…')` ve Material bileşenleri sistem fontuna düşüyordu; golden'da halka içindeki "%48" kutu olarak çizilince fark edildi. Ham aile adı kullanılıyor; regresyon testi eklendi.
2. **Erişilebilir ad iki kez okunuyordu (Flutter).** `DyPressable` `semanticLabel` alınca içeriği de birleştiriyordu: "Elif Yıldız, Elif", "Profil, 2 yeni not, Profil". Belgedeki sözleşmeye uygun olarak ad verildiğinde görsel içerik semantikten çıkarılıyor; odak düğümü dışarıda kaldığı için locked/loading öğeler odaklanabilir kalıyor (ilk deneme bunu bozdu, testler yakaladı).
3. **Dark temada kilitli alan şeklini kaybediyordu (iki platform).** `surface-sunken` dark'ta `background` ile aynı (`#0D1211`); kilitli alan çerçevesiz kalıyordu (web referansında da aynı). Kilitli butondaki kalıp uygulandı: `border-subtle` kenar. Token değişmedi.

### Karar: Android'de 48 dp dokunma alanı

`size.target-min` 44 px; Android kılavuzu 48 dp. Karar (28 Ekim, kullanıcı): Flutter'da yalnız Android'de dokunma alanı görünmez biçimde 48 dp'ye büyür; görsel boyut ve odak halkası 44 kalır; iOS ve web değişmez. Etki: Android'de bileşenler arası boşluk ~4 px artar. Android ve iOS için ayrı test var.

### Test altyapısı düzeltmeleri (eşik gevşetilmedi)

- **Testler kare test fontuyla çalışıyordu.** Raporda geçen "font yükleme yardımcısı" yoktu. `dy_tokens/testing.dart` → `loadDyFonts()`; üç paketin `flutter_test_config.dart`'ı tüm testleri Nunito ile çalıştırıyor. Taşma ölçümleri artık gerçek genişlikleri kullanıyor (ör. "540 kcal" 224 → 107 px).
- Flutter 3.47 semantiği: odaklanabilir düğümler `focus` eylemi taşıyor (`hasFocusAction: true` eklendi — beklenti daha kesin); `isToggled` artık `Tristate`.
- Sürekli animasyonlu durumlar (iskelet parıltısı, buton yükleme çizgisi) `pumpAndSettle` ile beklenemez → `pumpDy(settle: false)`; ayrıca hareket azaltma açıkken parıltının durduğu test edildi.
- `textContrastGuideline` piksel örnekliyor; 12 px ince Nunito'da kenar yumuşatmasını metin rengi sanıp 4,35 ölçtü (gerçek çift `text-muted`/`surface` dark 5,88, `background` 6,24). Bu tek yerde token renklerinden ölçen `expectTextContrast` kullanılıyor; diğer üç testte piksel kılavuzunun yanına eklendi. Yardımcının düşük kontrastı yakaladığını kanıtlayan negatif test var.
- Bugün entegrasyon testi, 2,0x ölçekte görünür alan dışına taşan içeriği kaydırarak denetliyor.

### Gözle incelemede not edilenler (değiştirilmedi)

- Golden'larda gölgeler keskin çizilir: `flutter_test` `debugDisableShadows = true` kullanır (belirlenimci golden). Cihazda token gölgesi bulanıktır.
- %200 metinde buton ikonları (kilit, artı) ve onay kutusu metinle büyümüyor; web'de de sabit. Faz 3'te ikon ölçeklemesi kararı.
- `DyListItem` %200 metin + 320 px'te sağdaki değer içerik sütununu ~85 px'e sıkıştırıyor (web aynı). Büyük ölçekte değerin alta geçmesi iki platformda birlikte tasarlanmalı.

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

1. ~~Flutter widget, semantik ve golden testleri çalıştırılmadı.~~ 28 Ekim turunda çalıştırıldı (yukarıda). Golden'lar Windows'ta üretildi; Linux/macOS CI'da küçük piksel farkları beklenir — CI platformu seçilince orada yeniden üretilmeli.
1a. **Playwright bu turda çalıştırılmadı.** Görsel referanslar Linux'ta üretilmiş ve platform eki taşımıyor; Windows Chromium'u farklı yazı çizer, 0,002 toleransla karşılaştırma anlamsız olur. Ayrıca `field.css` değişikliği nedeniyle `textfield-*` (4 referans) Linux'ta yeniden üretilmeli.
2. **Flutter'da gerçek cihazda %200 ölçek, TalkBack/VoiceOver** denenmedi.
3. **Widgetbook çalışırken** görülmedi (yalnız analiz; widgetbook 3.25 API'sine göre yazıldı).
4. **Web'de ekran okuyucu ile elle test** yapılmadı; axe ve rol/ad testleri var, NVDA/VoiceOver denemesi yok.
5. Görsel referanslar yalnız Chromium'da; Safari/Firefox çalıştırılmadı.

## Teknik borç

- Web paketinin `exports` alanı tip ve CSS için `src/`'yi gösteriyor (monorepo içi kullanım için yeterli); yayımlanacaksa `dist` tipleri ve derlenmiş CSS'e geçmeli.
- Katalog özel bir Vite uygulaması (Storybook değil). Belgeler Markdown'da; etkileşimli prop tablosu yok.
- Golden ve web görsel referansları farklı işletim sistemlerinde üretildi; CI platformu sabitlenmeli.
- `pubspec.lock` dosyaları (pub get ile oluştu) commit edilmedi; kütüphane paketleri için politika belirlenmeli.
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
