# TextField · SearchField · NumberField · Textarea

Metin, arama, sayı ve çok satırlı not girişi. Hepsi aynı alan kabuğunu (`FieldShell` / `DyFieldShell`) kullanır: görünür etiket, açıklama, kilit nedeni, hata veya başarı mesajı.

## API (ortak)

| Özellik | React | Flutter | Not |
| --- | --- | --- | --- |
| Etiket | `label` | `label` | Her zaman görünür; `hideLabel` yalnızca arama çubuğu gibi bağlamı açık yerlerde |
| Değer | `value` / `defaultValue` / `onChange(string)` | `controller` / `initialValue` / `onChanged` | Kontrollü ve kontrolsüz |
| Açıklama | `description` | `description` | Alanın altında |
| Hata | `error: string` | `error: String?` | Verilince hata durumu; ne olduğunu ve nasıl düzeltileceğini söyler |
| Başarı | `success` | `success` | error ile birlikte verilmez |
| Durum | `state` | `state` | enabled · disabled · locked · loading |
| Kilit nedeni | `lockedReason` | `lockedReason` | |
| Zorunlu | `required` | `required` | Etikette `*` (ekran okuyucu yerel "zorunlu" bilgisini kullanır) |
| Ön ikon / son ek | `iconStart`, `suffix` | `leading`, `suffix` | Birim: kg, g |

**SearchField** (`DySearchField`): arama ikonu, temizle butonu (`clearLabel`), Escape temizler, Enter `onSubmit`. Web'de `role="searchbox"`.

**NumberField** (`DyNumberField`): `value: number | null`, `min`, `max`, `step`, `fractionDigits`, `unit`, `stepper`. Türkçe ondalık virgülü kabul eder ("6,5"); harf girişini reddeder; ↑/↓ ve −/+ adımlar sınır dışına çıkmaz. Elle yazılan sınır dışı değer silinmez: hata mesajını üst bileşen verir.

**Textarea** (`DyTextarea`): `rows`/`minLines`, `maxRows`/`maxLines`, `maxLength` ile sayaç ("46 / 200"). Sayaç sınırın %90'ına gelince `warning-strong` olur ve ekran okuyucuya duyurulur.

## Durumlar

| Durum | Görünüm | Davranış |
| --- | --- | --- |
| default | `surface-secondary` zemin, kenarsız | |
| hover | `border` kenar | |
| focused | `focus-ring` kenar + `primary-subtle` hale, zemin `surface` | |
| filled | Değer `text-primary` | |
| error | `error` kenar, altta ikon + mesaj | web `aria-invalid`, mesaj `role="alert"`; Flutter canlı bölge |
| disabled | `opacity-disabled` | Odaklanmaz |
| locked | `surface-sunken`, kilit ikonu, nedeni altta | Salt okunur, odaklanır, neden açıklamaya bağlı |
| loading | Alt kenarda ilerleme çizgisi | `aria-busy` |

## Klavye ve erişilebilirlik

Etiket `label for` (web) ya da birleşik semantik düğüm (Flutter) ile bağlıdır. Açıklama, kilit nedeni ve hata `aria-describedby` / `Semantics.hint` olarak okunur. NumberField web'de `role="spinbutton"` + `aria-valuenow/min/max/valuetext`; Flutter'da ayarlanabilir değer (artır/azalt hareketleri). Arama alanında Escape değeri siler.

## Responsive

Mobilde tam genişlik, tek sütun. Panelde formlar iki sütuna yerleşir (Faz 4 form düzeni). Alan yüksekliği 52; metin ölçeği büyüdükçe alan uzar, kırpmaz.

## Uzun metin, hata, boş değer

Uzun etiket satır kaydırır. Tek satırlık alanda uzun değer yatay kaydırılır (yerel davranış). Boş NumberField `null` döner. Hata mesajı alanın altında kalır; toast kullanılmaz.

## Kullanım

```tsx
<NumberField label="Gramaj" unit="g" value={g} onChange={setG} min={0} max={1000} step={10} />
<TextField label="Porsiyon" defaultValue="1 kase" state="locked" lockedReason="Diyetisyenin gramaj değişikliğini kapattı." />
```

```dart
DyNumberField(label: 'Gramaj', unit: 'g', value: g, step: 10, min: 0, max: 1000, onChanged: (v) => setState(() => g = v))
```

Yanlış: placeholder'ı etiket olarak kullanmak; yalnızca kırmızı kenarla hata bildirmek; kilitli alanı disabled göstermek.

## Token'lar

`color.surface-secondary`, `surface`, `surface-sunken`, `border`, `focus-ring`, `primary-subtle`, `error`, `error-strong`, `success-strong`, `text-primary/secondary/muted`, `warning-strong` · `size.control-lg`, `size.control-sm` · `radius.md` · `border.width-strong` · `spacing.xs–lg` · `typography.body`, `label`, `caption`.

## Desteklenmeyenler

Maske (telefon, IBAN), otomatik tamamlama önerileri, şifre göster/gizle butonu, tarih/saat girişi bu fazda yok. Tarih ve saat seçiciler Faz 3 randevu component'leriyle gelir.

## Testler

Web: `fields.test.tsx`; katalog `quality.spec.ts` (%200 ölçek, 320 px), `visual.spec.ts`. Flutter: `fields_test.dart`, `golden_test.dart`.
