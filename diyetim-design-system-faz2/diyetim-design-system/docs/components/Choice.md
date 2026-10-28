# Checkbox · RadioGroup · Switch · SegmentedControl

İkili ve tek seçimli kontroller. Hangisi ne zaman:

- **Checkbox:** kaydet butonuyla onaylanacak seçimler, koşul kabulü, listede çoklu seçim.
- **RadioGroup:** 2–5 seçenekten biri, seçenekler açıklama gerektiriyorsa.
- **Switch:** anında geçerli olan ayar (danışan yetkileri, görünürlük). Kaydet butonu gerektirmez.
- **SegmentedControl:** aynı içeriğin 2–5 görünümü arasında geçiş (Gün · Hafta · Ay).

## API

| Component | React | Flutter |
| --- | --- | --- |
| Checkbox | `label`, `description`, `checked`/`defaultChecked`, `indeterminate`, `onChange(bool)`, `state` (loading yok), `lockedReason`, `error` | `DyCheckbox`: `label`, `value: bool?` (null = karışık), `onChanged`, `description`, `state`, `lockedReason`, `error` |
| RadioGroup | `label` (legend), `options` (`value`, `label`, `description?`, `disabled?`), `value`/`defaultValue`, `onChange`, `description`, `error`, `state`, `lockedReason`, `required`, `orientation` | `DyRadioGroup<T>`: `options: List<DyRadioOption<T>>`, `value`, `onChanged`, `horizontal` |
| Switch | `label`, `description`, `checked`/`defaultChecked`, `onChange`, `state` (loading: sunucuya kaydediliyor), `lockedReason`, `labelPosition` | `DySwitch`: `label`, `value`, `onChanged`, `description`, `state`, `lockedReason` |
| SegmentedControl | `label`, `options` (`value`, `label`, `icon?`, `disabled?`), `value`/`defaultValue`, `onChange`, `state`, `fullWidth` | `DySegmentedControl<T>`: `segments`, `value`, `onChanged`, `state` |

## Durumlar

Hepsinde: default · hover · focus (2 px halka) · seçili · disabled (`opacity-disabled`) · locked (sunken zemin, kilit, neden; değer değişmez ama odaklanır). Checkbox ve RadioGroup: error (kırmızı kutu kenarı + mesaj). Switch: loading (yeni konumda, etkileşim kapalı, `aria-busy`). Checkbox: karışık durum.

## Klavye ve erişilebilirlik

- Checkbox: Space değiştirir (yerel input). Karışık durum `indeterminate` / Flutter "karışık" değeri.
- RadioGroup: Tab gruba girer, oklar seçer (web yerel; Flutter `CallbackShortcuts`, devre dışı seçeneği atlar ve sarar). `fieldset`/`legend`; Flutter grup etiketi.
- Switch: `role="switch"` + `aria-checked`; Flutter `toggled` semantiği. Space/Enter değiştirir.
- SegmentedControl: `role="radiogroup"`, gezici tabindex, ←/→/↑/↓, Home/End; seçim odağı izler.
- Görsel kontrol 20 px, dokunma alanı en az 44 px (görünmez genişletilmiş alan).

## Responsive

Seçim satırları tam genişlik; etiket ve açıklama satır kaydırır. SegmentedControl mobilde `fullWidth` eşit bölümler; panelde içerik genişliği.

## Uzun metin, hata, boş değer

Etiketler kesilmez; SegmentedControl'de uzun etiket bölüm içinde satır kaydırır (5'ten fazla bölüm desteklenmez). Hata mesajı grubun altında.

## Kullanım

```tsx
<Switch label="Kalori değerleri" description="Kapalıyken halka rakamsız gösterilir" checked={visible} onChange={setVisible} />
```

```dart
DySwitch(label: 'Kalori değerleri', description: 'Kapalıyken halka rakamsız gösterilir', value: visible, onChanged: setVisible)
```

Yanlış: kaydet gerektiren formda Switch; 6+ seçenekte SegmentedControl; RadioGroup'u etiketsiz kullanmak.

## Token'lar

`color.primary`, `border-strong`, `surface`, `surface-elevated`, `surface-sunken`, `text-secondary`, `text-on-primary`, `error`, `focus-ring`, `surface-secondary` · `radius.xs`, `radius.full`, `radius.md/sm` · `size.target-min/comfortable`, `size.control-md` · `shadow.low` · `duration.fast/normal`, `ease.emphasized`.

## Desteklenmeyenler

Checkbox grubu bileşeni (liste olarak yan yana Checkbox kullanılır), switch'te ikon veya metin etiketi, SegmentedControl'de çoklu seçim.

## Testler

Web: `choice.test.tsx`, katalog `choice-*` görselleri. Flutter: `choice_test.dart`, `golden_test.dart`.
