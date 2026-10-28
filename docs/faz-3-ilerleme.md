# Faz 3 ilerleme

## 28 Ekim 2026 · Uygulama iskeleti, "Bugün" ve besin arama

### Kararlar

- [0001](decisions/0001-besin-veri-kaynagi.md) — FatSecret, backend üzerinden. **Basic plan yalnız ABD verisi verir**;
  Türkçe arama için Premier gerekir (ürün kararı açık). Atıf API'den gelir.
- [0002](decisions/0002-bugun-ekrani-hiyerarsisi.md) — "Bugün": önce diyetisyen notu, sonra öğünler.
- [API sözleşmesi](api/openapi.yaml) — `/api/today`, `/api/foods/search`, `/api/foods/{id}`. Gizli kalori için
  açık `caloriesVisibility` alanı (gizli ↔ bilinmiyor ayrımı).

### Uygulama (`apps/diyetim_app`)

DDP katmanları, Riverpod 3 (codegen), go_router, get_it/injectable, freezed, gen-l10n (tr). Backend yokken
sözleşmeye uyan sahte veri kaynakları.

- **Bugün:** diyetisyen notu kartı (yazar, göreli zaman, kaynak etiketi, 4 satır + "Devamını oku"), öğün listesi
  (durum etiketi, saat, kalori; gizli kalori "Gizli"), iskelet aynı yerleşimde, boş ve hata durumları.
- **Besin arama:** 300 ms gecikmeli arama (ara tuşlar backend'e gitmez), 2 harf alt sınırı, yeni arama yüklenirken
  eski sonuçlar kalır, sayfalama, sonuç yok, kota hatası (yeniden denenmez), atıf bağlantısı (yalnız https).

### Testler (gerçekten çalıştırıldı)

| | Sonuç |
| --- | --- |
| `flutter analyze` (uygulama) | sorun yok |
| Uygulama: birim 12, Bugün 9, besin arama 8, kalite 8 | **37 geçti** |
| Uygulama golden (Bugün, arama × light/dark) | 4 geçti, gözle incelendi |
| Tasarım sistemi `dy_ui` | 104 geçti (88 + 16 golden) |
| `dy_gallery` / `dy_health` | 8 / 3 geçti |
| Web Vitest | 206 geçti |

Kalite testleri: iki temada %200 metin + 320 px'te taşma yok; Android dokunma hedefi ve etiketli hedef kılavuzları;
kontrast (Bugün'de piksel + token, aramada token — 12 px sayaçta piksel örneklemesi kenar yumuşatmasını ölçüyor).

### Uygulama geliştirirken bulunan tasarım sistemi hataları (düzeltildi)

1. **`DyAppBar(large: true)` `Scaffold.appBar` içinde %100'de bile 14 px taşıyordu** — yükseklik h1'den türetiliyor,
   regresyon testi var. Kalan sınır: sabit yükseklik nedeniyle metin ölçeğiyle büyüyemez; uygulama şimdilik standart
   çubuk kullanıyor. Gerekli: kayan büyük başlık (sliver) bileşeni.
2. **Metin alanının dokunma/semantik alanı 40 px'ti** (çerçeve 52; Android 48 kılavuzu kalıyordu, çerçevenin üst/alt
   şeridi dokunuşu almıyordu). Tek satırlı alan artık çerçevenin kenarlık içini dolduruyor (49 px). Yan etki:
   `DyNumberField` 59 → 52 px, diğer alanlar ve web ile aynı geometri (golden gözle incelendi, yenilendi).
3. **`DyListItem` meta satırında karışık yükseklikteki öğeler üstten hizalanıyordu** (etiket + saat) — Flutter
   `WrapCrossAlignment.center`, web `align-items: center`.
4. Test yardımcıları `dy_testing` paketine taşındı (`loadDyFonts`, `expectTextContrast`); `dy_ui` ve uygulama ortak kullanır.

### Bilinçli sapmalar

- `flutter-architecture` skill'indeki `flutter_screenutil` kullanılmadı (ölçüler token'lardan).

### Açık kalanlar / sıradaki

- **Backend** (teknoloji seçimi): FatSecret OAuth, normalleştirme, önbellek, kota → `QUOTA_EXCEEDED`.
- **Premier başvurusu** ya da Türkçe besinler için ek kaynak.
- Kimlik doğrulama (API bearer token kaynağı belirsiz).
- Besin ayrıntısı + porsiyon seçimi + öğüne ekleme akışı (`/api/foods/{id}` sözleşmede hazır).
- Alt gezinme (İlerleme, Profil) ve kayan büyük başlık bileşeni.
- Web görsel referansları Linux'ta yenilenmeli: `field.css` (önceki tur) ve `data.css` meta hizası.
- Gerçek cihazda TalkBack/VoiceOver denemesi yapılmadı.
