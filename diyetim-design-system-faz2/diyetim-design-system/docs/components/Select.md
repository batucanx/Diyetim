# Select · MultiSelect

Sabit bir seçenek listesinden tek veya çoklu seçim. Sözleşme iki platformda aynıdır (seçenekler, değer, durumlar); sunum platforma uygundur:

- **React:** APG "select-only combobox": tetik butonu + açılır liste.
- **Flutter (mobil):** tetik alanı + alttan açılan sayfa (`showModalBottomSheet`); çoklu seçimde "Tamam" ile onay.

## API

| Özellik | React | Flutter |
| --- | --- | --- |
| Seçenekler | `options: SelectOption[]` (`value`, `label`, `description?`, `disabled?`) | `options: List<DySelectOption<T>>` (`enabled`) |
| Tek değer | `value` / `defaultValue` / `onChange(v \| null)` | `value` / `onChanged(T)` |
| Çoklu değer | `MultiSelect`: `value: V[]`, `onChange(V[])`, `summary?` | `DyMultiSelect`: `values: Set<T>`, `onChanged(Set<T>)` |
| Diğer | `label`, `placeholder`, `description`, `error`, `state`, `lockedReason`, `required`, `emptyText`, `name` | aynı (`name` yok), `confirmLabel` |

Özet metni: 1–2 seçimde etiketler, daha fazlasında "N seçili".

## Durumlar

default · hover · focus · açık · seçili · devre dışı seçenek (`opacity-disabled`, atlanır) · error · disabled · locked (açılmaz, neden okunur) · loading (ilerleme çizgisi, açılmaz) · boş liste (`emptyText`).

## Klavye ve erişilebilirlik (web)

↓/↑ açar ve gezer · Home/End · Enter/Space seçer (tekli kapanır, çoklu açık kalır) · Escape kapatır · Tab seçip çıkar · harf yazmak Türkçe yerel ayarla arar (`ş`, `ı` → "Ispanak", `i` → "İncir"; seçimden sonra arama tamponu sıfırlanır). `aria-expanded`, `aria-controls`, `aria-activedescendant`, `aria-multiselectable`, seçenekte `aria-selected`. Dışarı tıklama kapatır.

Flutter: tetik buton semantiği (değer okunur); sayfada her seçenek seçili/işaretli semantiği taşır; sayfa sürükleyerek veya geri hareketiyle kapanır.

## Responsive

React liste tetik genişliğinde, en fazla 6 satır yükseklikte, kaydırılır. Flutter sayfası içeriğe göre uzar, ekranın büyük bölümünü geçince kaydırılır.

## Uzun metin, hata, boş değer

Tetikteki uzun değer tek satırda üç noktayla kesilir (tam metin seçenek listesinde okunur). Seçenek etiketleri satır kaydırır. Boş liste açıklayıcı metin gösterir.

## Kullanım

```tsx
<Select label="Öğün tipi" options={meals} value={meal} onChange={setMeal} />
```

Yanlış: 5'ten az seçenek için Select (RadioGroup veya SegmentedControl daha hızlı); arama gerektiren uzun listeler için Select (besin araması `SearchField` + sonuç listesiyle yapılır, Faz 3).

## Token'lar

Alan token'ları (TextField ile aynı) + `color.surface-elevated`, `border-subtle`, `shadow.medium`, `z.dropdown`, `radius.md/sm`, `color.primary` (seçili işareti), `size.target-min` (seçenek yüksekliği).

## Desteklenmeyenler

Liste içinde arama (combobox + filtre), gruplu seçenekler, sanal kaydırma, Flutter'da açılır menü (masaüstü) bu fazda yok.

## Testler

Web: `select.test.tsx` (klavye, Türkçe arama, dışarı tıklama, axe açık/kapalı), görsel `select-open-*`. Flutter: `choice_test.dart` (sayfadan seçim, çoklu seçim özeti, locked).
