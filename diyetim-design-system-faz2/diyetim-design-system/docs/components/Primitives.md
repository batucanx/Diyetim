# Primitives: Text · NumberDisplay · Icon · Surface · Stack · Skeleton · Pressable · Focus ring

Tüm component'lerin kurulduğu en alt katman. Uygulama kodu ham renk, boşluk veya font değeri yerine bunları kullanır.

## Text (`Text` / `DyText`)

Tüm metinlerin tek kapısı; serbest font boyutu veya renk kabul etmez.

| Özellik | React | Flutter |
| --- | --- | --- |
| Stil | `variant: TextStyleToken` (varsayılan body) | `style: DyTextStyle` |
| Ton | `tone: TextTone` | `tone: DyTextTone` |
| Satır sınırı | `maxLines` (üç nokta, tam metin `title`) | `maxLines` |
| Diğer | `as`, `align` | `textAlign`, `semanticsLabel` |

Başlık stilleri web'de `h1–h4`, Flutter'da `Semantics(header: true)`. Varsayılan olarak kırpmaz. Masaüstünde (≥ 1024) başlık ve gövde boyutları `expanded` ölçeğe geçer. CSS font boyutları `rem` cinsindendir: tarayıcı yazı boyutu ayarına uyar.

Tonlar: primary · secondary · muted · disabled · on-primary · on-inverse · link · error · success.

## NumberDisplay (`NumberDisplay` / `DyNumber`)

Sayıları Türkçe biçimde gösterir: `1.842`, `6,3`, `%48`; birim değerden U+00A0 ile ayrılır (Nunito U+202F içermez; doğrulandı).

| Özellik | React | Flutter |
| --- | --- | --- |
| Değer | `value: number \| null` | `value: num?` (konumsal) |
| Birim, stil, ton | `unit`, `variant` (numeric-xl/lg/sm…), `tone` | `unit`, `style`, `tone` |
| Biçim | `format: 'decimal' \| 'percent'`, `fractionDigits` | `format: DyNumberFormat`, `fractionDigits` |
| Bağlam | `label` ("Kalan kalori": görünmez, önce okunur) | `label` |
| Görünürlük | `visibility: 'visible' \| 'hidden'` | `visibility: DyVisibility` |
| Boş | `emptyLabel` (varsayılan "—"; ekran okuyucu "değer yok") | `emptyLabel` |

`hidden`: diyetisyen bu metriği gizledi; değer API'den gelmez, "Gizli" + göz kapalı ikonu gösterilir. Rakamlar eşit genişliktedir: Nunito'da `tnum` yok, ama varsayılan rakamlar 400–800 her ağırlıkta 600 birim (doğrulandı; tarayıcıda 111111 ile 888888 aynı genişlik).

## Icon (`Icon` / `DyIcon`)

`spec/icons.json` tek kaynaklı 42 ikon: 24 × 24 ızgara, 1,75 çizgi, yuvarlak uç. Web SVG, Flutter `CustomPainter` (yaylar kübik eğriye çevrilmiş Path komutları). Boyut sm 16 · md 20 · lg 24 · xl 32. `label` verilirse anlamlı (`role="img"` / image semantiği), verilmezse dekoratif. Renk çevredeki metin rengini izler.

## Surface (`Surface` / `DySurface`)

Zemin katmanı (`SurfaceLevel`: background · surface · elevated · secondary · sunken · inverse), derinlik (`Elevation`: none–modal), radius ve padding. surface ve elevated varsayılan olarak `border-subtle` kenarlıklıdır. Dark temada derinlik gölgeden çok yüzey tonu ve üst kenar ışığıyla gelir (Flutter: kenar rengine karıştırılır, çünkü yuvarlatılmış köşede tek kenar çizilemez).

## Stack · Gap

`Stack` (`DyStack`): dikey/yatay yerleşim, `gap` spacing token'ı, `align`, `justify`, `wrap` (büyük metin ölçeğinde taşmayı önler). `Gap` (`DyGap`): tek seferlik boşluk; mümkünse `gap` tercih edilir.

## Skeleton (`Skeleton` / `DySkeleton`)

Yüklenen içeriğin yerini birebir ölçüyle tutar: `shape` text · rect · circle, `width`, `height`, `lines`, `radius`. Ekran okuyucudan gizli; yükleme durumunu kapsayıcı bildirir (web: `aria-busy` + görsel olarak gizli "yükleniyor" metni). Hareketi azaltta shimmer durur (tarayıcı testiyle doğrulandı). Dönen yükleyici kullanılmaz.

## Pressable (`Pressable` / `DyPressable`) ve odak halkası

Tüm basılabilir öğelerin tabanı:

| Durum | Odaklanır mı | Tetiklenir mi | Bildirim |
| --- | --- | --- | --- |
| enabled | evet | evet | |
| disabled | hayır | hayır | devre dışı |
| locked | evet | hayır | neden (`lockedReason`) açıklama olarak |
| loading | evet | hayır | "yükleniyor" (`aria-busy`) |

Odak halkası: yalnızca klavye odağında, 2 px `focus-ring`, 2 px boşluk, şeklin köşelerini izler (web `:focus-visible`; Flutter `onShowFocusHighlight`). Kontrastı her yüzeyde ≥ 3:1 (token testi). Basma geri bildirimi %98 ölçek, `duration-instant`. Flutter'da `DyPressable` bir `builder(context, DyPressState)` alır: hovered · pressed · focused · state.

## Testler

Web: `primitives.test.tsx`, `format.test.ts`, `no-raw-values.test.ts`, katalog görselleri ve kalite testleri. Flutter: `primitives_test.dart`.

## Desteklenmeyenler

Text'te zengin metin (kalın/italik parçalar) için ayrı API yok; `Text` içinde `<strong>` (web) veya `Text.rich` (Flutter) kullanılır. Icon'da çok renkli ikon yok.
