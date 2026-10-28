# Platform paritesi: Flutter ↔ React

İki platform component kodunu paylaşmaz. Paylaşılan şey sözleşmedir; sözleşme tek kaynaktan üretilir ve testle korunur.

## Tek kaynaktan üretilenler

| Kaynak | Web çıktısı | Flutter çıktısı | Koruma |
| --- | --- | --- | --- |
| `tokens/*.json` (DTCG) | `tokens.css` (CSS değişkenleri, light/dark, `prefers-color-scheme`, `prefers-reduced-motion`), `tokens.ts`, `resolved.json` | `DyColors` (ThemeExtension), `DySpacing`, `DyRadius`, `DySize`, `DyDuration`, `DyEasing`, `DyShadows`, tipografi | parite testi (CSS ↔ Dart ↔ resolved), tarayıcıda hesaplanan değer = `resolved.json`, kontrast testleri |
| `spec/contracts.json` | TS enum/union tipleri, `statusStyles` | Dart enum'ları, `.style` eşlemeleri | her enum değeri eşlenmiş, her ikon sette var |
| `spec/icons.json` | SVG path verisi | Dart path opcode listeleri (`DyIcons`) | ikon adları iki tarafta aynı |
| `spec/i18n/tr.json` | `useStrings().t(key, params)` | `DyStrings.of(context).t(key, params)` | eksik anahtar Türkçeye düşer |

Üretilmiş dosyaların başında kaynak hash'i vardır; elle değiştirilirse `pnpm tokens:check` başarısız olur (test: "üretilmiş bir dosya elle değiştirilirse tokens:check başarısız olur").

Token değişikliği akışı bu fazda gerçekten denendi: `radius.lg` 18 → 20 px yapıldı; `tokens:check` eski çıktıları reddetti; `tokens:build` sonrası `--radius-lg: 20px` (CSS) ve `DyRadius.lg = 20.0` (Dart) üretildi; 88 token testi ve tarayıcıdaki token paritesi testi geçti; değişiklik geri alındı.

## Ortak davranış kuralları

- Durum enum'ı: `enabled · disabled · loading · locked` (+ seçim/hata ayrı prop). disabled ≠ locked: locked nedenini okutur, tetiklenmez.
- Gizli değer (`visibility: hidden`) "Gizli" + göz ikonu; değişim/ek bilgi gösterilmez; veri sunucudan hiç gelmez.
- Sayı biçimi tr-TR: `1.842`, `6,3`, `%48`, eksi U+2212 (StatCard değişimi), sayı–birim arası U+00A0. Tabular rakam: Nunito'da `tnum` yok, varsayılan rakamlar 400–800 ağırlıklarda eşit genişlikte (600 birim) — doğrulandı.
- Baş harfler Türkçe kurallarla (`i → İ`, `ı → I`): `initials()` / `dyInitials()` aynı test vektörleriyle.
- Hareket azaltma: web'de süreler 0, Flutter'da `context.dy.duration()` 0; belirsiz ilerleme sabit durur.
- Dokunma hedefi en az 44 px (`size.target-min`).

## Bilinçli farklar

| Konu | Web (panel) | Flutter (danışan uygulaması) | Neden |
| --- | --- | --- | --- |
| Select | Açılır liste, typeahead | Alttan açılan sayfa | Mobil kalıbı |
| Tooltip | Hover 400 ms / odakta anında | Uzun basma | Dokunmatik |
| Toast | Kendi kuyruğu, sağ alt / nav üstü | ScaffoldMessenger SnackBar | Platform kalıbı |
| Sidebar, TopBar, Breadcrumb | Var | Yok | Danışan uygulamasında gerekmiyor |
| DataTable, Pagination | Var | Yok; liste + sonsuz kaydırma | Mobilde tablo kullanılmıyor |
| FilterBar | Arama + çipler + temizle + canlı sonuç | `DyFilterChips` (yatay kaydırma) + ayrı `DySearchField` | Ekran genişliği |
| Card etkileşimi | `href` (bağlantı) veya `onClick` | `onTap` | Gezinme platforma göre |
| ListItem | `href` desteği var | Yok (`onTap`) | Aynı |
| Chip sayaç | `FilterBar` seçeneğinde | `DyChip.count` | Flutter'da çip tek başına da sayaç taşıyor |
| Avatar durum noktası | `status` var | Faz 3 | Danışan listesiyle birlikte |
| Etkileşimli kart içinde ikinci kontrol | Geliştirme modunda konsol uyarısı | Yalnız dokümantasyon kuralı | Flutter'da DOM benzeri denetim yok |
| Dar ekran tablo | CSS ile kart düzeni | — | — |
| Avatar metin ölçeği | Tarayıcı ölçeği | 1,3 ile sınırlı (daire bozulmasın), ad semantikte | Sabit boyutlu daire |

## Doğrulama durumu

| | Web | Flutter |
| --- | --- | --- |
| Statik analiz | `tsc` temiz | `dart analyze` temiz (4 paket, gerçek Flutter kaynaklarına karşı) |
| Davranış testleri | Vitest + RTL: 206 geçti | Widget testleri yazıldı, **çalıştırılamadı** (ortamda Flutter motoru yok) |
| Görsel referans | Playwright: 94 referans, light/dark × mobil/masaüstü | Golden testleri yazıldı (4 grup × 2 tema × 2 ölçek), **üretilmedi** |
| Erişilebilirlik | axe (jsdom + gerçek tarayıcıda kontrast dahil), klavye, odak halkası | Semantik testleri yazıldı, çalıştırılamadı |
| %200 metin, 320 px | Tarayıcıda ölçüldü, taşma yok | Widget testi yazıldı, çalıştırılamadı |
