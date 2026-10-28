# Button · IconButton · Fab

Bir ekrandaki eylemleri önem sırasıyla gösterir. Ekranda en fazla bir `primary`; ikincil eylem `secondary`, vazgeç ve nötr eylemler `tertiary`, metin içi eylemler `ghost`, geri alınamayan eylemler `destructive` (her zaman onay ister).

## API

| Özellik | React `Button` | Flutter `DyButton` | Not |
| --- | --- | --- | --- |
| Etiket | `children: ReactNode` | `label: String` | Fiil ile başlar: "Öğünü kaydet" |
| Eylem | `onClick` | `onPressed` | |
| Varyant | `variant: ButtonVariant` | `variant: DyButtonVariant` | primary · secondary · tertiary · ghost · destructive |
| Boyut | `size: ButtonSize` | `size: DyButtonSize` | sm 36 (yalnızca panel tabloları) · md 44 · lg 52 |
| Durum | `state: ComponentState` | `state: DyComponentState` | enabled · disabled · locked · loading |
| Kilit nedeni | `lockedReason` | `lockedReason` | locked iken zorunlu |
| İkonlar | `iconStart`, `iconEnd: IconName` | `iconStart`, `iconEnd: DyIconData` | |
| Tam genişlik | `fullWidth` | `fullWidth` | Mobilde ana eylem |

`IconButton` / `DyIconButton`: `icon`, `label` (zorunlu erişilebilir ad), `variant` ghost · surface · primary, `size` md · lg (Flutter: `large`).
`Fab` / `DyFab`: `icon`, `label`. `surface-inverse` dolgu, `shadow-high`; ekranda en fazla bir tane.

## Durumlar

| Durum | Görünüm | Davranış |
| --- | --- | --- |
| default | Varyant zemini | |
| hover | primary → `primary-hover`; tertiary kenar → `border-strong`; ghost zemin → `primary-subtle` | Yalnızca imleçli cihazlarda |
| focus | 2 px `focus-ring`, 2 px boşluk, şekli izler | Yalnızca klavye odağında |
| pressed | %98 ölçek (`duration-instant`); primary → `primary-active` | Hareketi azaltta ölçek yok |
| disabled | `opacity-disabled` | Odaklanmaz, tetiklenmez |
| locked | `surface-sunken` zemin, kilit ikonu, `text-secondary` | Odaklanır, nedeni okunur, tetiklenmez |
| loading | Etiket görünmez ama genişlik korunur; ilerleme çizgisi | Odaklanır, "yükleniyor" bildirilir, tetiklenmez |

loading ile locked aynı anda olamaz: durum tek bir alandır (`ComponentState`), birleşik durum tip düzeyinde engellenir.

## Klavye ve erişilebilirlik

- Enter ve Space tetikler (web: yerel `<button>`; Flutter: `ActivateIntent`).
- disabled `disabled` özniteliği ile odak sırasından çıkar; locked ve loading `aria-disabled="true"` ile odakta kalır.
- locked nedeni `aria-describedby` (web) / `Semantics.hint` (Flutter) ile okunur; loading web'de `aria-busy`, Flutter'da "Yükleniyor" ipucu.
- Loading etiketi `opacity: 0` ile gizlenir; `visibility: hidden` erişilebilir adı sildiği için kullanılmaz (tarayıcı testiyle doğrulandı).
- Dokunma alanı en az 44 × 44; `sm` yalnızca imleçli panelde.

## Responsive

Mobilde ana eylem `size="lg"` ve `fullWidth`, ekran altına sabitlenir. Panelde içerik genişliğinde, sağ üstte. Etiket satır kaydırır; kesilmez.

## Uzun metin, hata, boş değer

Uzun Türkçe etiketler satır kaydırır (`overflow-wrap: anywhere`; Flutter `softWrap`); %200 metin ölçeğinde 320 px genişlikte taşma olmadığı tarayıcı testiyle doğrulanır. Butonun hata durumu yoktur; işlem hatası alanın veya sayfanın kendi hata göstergesindedir. Boş etiket desteklenmez (TypeScript ve Dart'ta zorunlu alan).

## Kullanım

```tsx
<Button size="lg" fullWidth onClick={save}>Öğünü kaydet</Button>
<Button variant="secondary" iconStart="plus">Plana ekle</Button>
<Button state="locked" lockedReason="Diyetisyenin plan dışı eklemeyi kapattı">Besin ekle</Button>
```

```dart
DyButton(label: 'Öğünü kaydet', size: DyButtonSize.lg, fullWidth: true, onPressed: save)
```

Yanlış: iki `primary` yan yana; locked yerine disabled kullanıp nedeni gizlemek; pill biçimi veya gradyan; `IconButton`'ı etiketsiz kullanmak.

## Token'lar

`color.primary`, `primary-hover`, `primary-active`, `primary-subtle`, `on-primary-subtle`, `text-on-primary`, `text-primary`, `text-link`, `border`, `border-strong`, `error`, `surface-sunken`, `text-secondary`, `surface-inverse`, `text-on-inverse`, `focus-ring` · `size.control-sm/md/lg`, `size.target-min`, `size.fab` · `radius.md`, `radius.full` · `spacing.xs–2xl` · `shadow.low`, `shadow.high` · `opacity.disabled` · `duration.instant/fast`, `ease.standard`.

## Desteklenmeyenler

Buton grubu, bölünmüş buton (split), sayaç rozeti ve bağlantı (`<a>`) olarak render etme bu fazda yok. Bağlantı gerekiyorsa `Text tone="link"` ile anchor kullanılır.

## Testler

Web: `packages/web/ui/src/test/button.test.tsx`, katalog `tests/quality.spec.ts` (axe, odak halkası, dokunma hedefi, taşma), `tests/visual.spec.ts`. Flutter: `packages/flutter/dy_ui/test/button_test.dart`, `golden_test.dart`.
