# Veri sunumu: Card · ListItem · Avatar · AvatarGroup · ProgressBar · ProgressRing · StatCard · Chip · DataTable · Pagination · FilterBar

Bu grup, alan kartlarının (öğün, randevu, danışan, tahlil) ve panel listelerinin tabanıdır. Alan kartları Faz 3'te bu component'lerin üzerine kurulur; burada alan bilgisi (kalori hesabı, hedef kuralları) yoktur.

| İhtiyaç | Component | Platform |
| --- | --- | --- |
| Gruplanmış içerik kutusu | Card + CardHeader | ikisi |
| Satır listesi (öğünler, bildirimler) | List + ListItem | ikisi |
| Kişi (danışan, diyetisyen) | Avatar, AvatarGroup | ikisi |
| Hedefe göre ilerleme (makro, su) | ProgressBar | ikisi |
| Ana hedef (günlük kalori) | ProgressRing | ikisi |
| Tek metrik ve değişimi | StatCard | ikisi |
| Filtre / seçim etiketi | Chip; mobilde DyFilterChips, panelde FilterBar | ikisi |
| Çok sütunlu kayıt listesi | DataTable | yalnız web (panel) |
| Sayfalama | Pagination | yalnız web (panel) |

DataTable ve Pagination danışan uygulamasında kullanılmaz: mobilde liste + sonsuz kaydırma (ListItem) tercih edilir. Bu bilinçli bir platform farkıdır (bkz. [platform paritesi](../platform-parity.md)).

## API

| Component | React | Flutter |
| --- | --- | --- |
| Card | `Card({ variant: 'flat'\|'raised'\|'hero', interactive?, href?, onClick?, selected?, padding?: 'compact'\|'default'\|'hero', as? })` | `DyCard(child, variant: DyCardVariant, padding: DyCardPadding?, onTap?, selected?, semanticLabel?, state, lockedReason)` |
| CardHeader | `CardHeader({ title, subtitle?, action?, headingLevel=3 })` | `DyCardHeader(title, subtitle, action)` |
| List / ListItem | `List({ label?, children })`, `ListItem({ title, description?, leading?, trailing?, onClick?, href?, selected?, divider=true })` | `DyList(children, dividers, semanticLabel)`, `DyListItem(title, description, leading, trailing, onTap, selected, showChevron, state, lockedReason, maxDescriptionLines=2)` |
| Avatar | `Avatar({ name, src?, size: 'sm'\|'md'\|'lg'\|'xl', verified?, status?, decorative? })`, `initials(name)` | `DyAvatar(name, image: ImageProvider?, size: DyAvatarSize, verified, decorative, onSurface)`, `dyInitials(name)` |
| AvatarGroup | `AvatarGroup({ people: {name, src?}[], max=3, label, size })` | `DyAvatarGroup(people: List<DyAvatarPerson>, label, max=3, size)` |
| ProgressBar | `ProgressBar({ value: number\|null, max=100, label, valueText?, tone, showLabel?, size: 'sm'\|'md' })` | `DyProgressBar(value: double?, label, max=100, valueText, tone: DyProgressTone, showLabel, compact)` |
| ProgressRing | `ProgressRing({ value, max=100, label, valueText?, size: 'md'\|'lg', tone: 'primary'\|'warning', children? })` | `DyProgressRing(value, label, max, valueText, size: DyProgressRingSize, tone: DyProgressTone, child)` |
| StatCard | `StatCard({ label, value: number\|null, unit?, fractionDigits=1, delta?, deltaUnit?, deltaIntent, deltaContext?, icon?, footer?, visibility? })` | `DyStatCard(label, value, unit, fractionDigits, delta, deltaUnit, deltaIntent: DyDeltaIntent, deltaContext, icon, footer, visibility)`; `DyStatCard.formatDelta()` |
| Chip | `Chip({ selected?, icon?, removable?, onClick, children })` | `DyChip(label, selected, onSelected, icon, count, onRemove, state, lockedReason)` |
| Filtre grubu | `FilterBar({ search?, filters?: { label, options: {value,label,count?}[], value, onChange }, extra?, onClearAll?, resultText? })` | `DyFilterChips(label, options: List<DyFilterOption>, values: Set<String>, onChanged, showClear)` |
| DataTable | `DataTable<R>({ caption, hideCaption?, columns: Column<R>[], rows, rowKey, rowLabel?, onRowClick?, sort?, onSortChange?, selected?, onSelectedChange?, state: 'ready'\|'loading'\|'error', errorKind?, onRetry?, empty?, density })` | — |
| Pagination | `Pagination({ page, pageCount, onChange, label?, summary? })`, `pageWindow(page, count)` | — |

`Column<R>`: `key, header, cell?, align?, numeric?, sortable?, hideOnCompact?, width?`. `SortState`: `{ key, direction: 'ascending' | 'descending' } | null`. `deltaIntent`: `increase-is-good` · `decrease-is-good` · `neutral` (Dart: `DyDeltaIntent.increaseIsGood` …).

Tonlar (`ProgressBar.tone`, `DyProgressTone`): primary · success · warning · carb · protein · fat. Makro tonları `color.macro.*` token'larından gelir; ray (track) `color.macro-track`.

## Varyantlar ve durumlar

| Component | default | hover | focus | pressed | disabled | loading | locked | selected | error / empty |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Card (etkileşimli) | surface + kenarlık | elevated + hafif gölge | 2 px odak halkası | %99 ölçek | — | içerik Skeleton | Flutter: kilit nedeni okunur, tetiklenmez | primary kenarlık; web'de `aria-pressed` / bağlantıda `aria-current` | içerikte EmptyState |
| ListItem | | surface-secondary | odak halkası (içe) | | | Skeleton satırı | Flutter `state: locked` | primary-subtle zemin | |
| Avatar | baş harf | | | | | | | | foto hatasında baş harf |
| ProgressBar | dolum | | | | | `value: null` belirsiz | | | hedef aşımı: dolu kalır, metinde belirtilir |
| StatCard | | | | | | `value: null` → "—" | | | `visibility: hidden` → "Gizli", değişim gösterilmez |
| Chip | surface-secondary | surface-sunken | odak halkası | ölçek | %38 opaklık | | kilit nedeni | surface-inverse | |
| DataTable | | satır surface-secondary | sıralama butonu / satır bağlantısı odak halkası | | | `aria-busy`, iskelet satırlar | | primary-subtle satır, `aria-selected` | ErrorState (eylemli) · EmptyState |
| Pagination | | | odak halkası | | önceki/sonraki sınırda disabled | | | `aria-current="page"` | |

Disabled ile locked ayrıdır: disabled şu an kullanılamaz (ör. ilk sayfada "Önceki"); locked yetki/klinik ayarıyla kapalıdır ve nedeni okunur.

## Light / Dark

Tüm renkler semantic token'dan gelir; makro renkleri dark temada kendi açık tonlarına geçer (wheat.200, sky.300, plum.400). Seçili satırdaki avatar zemini `surface`'a döner, böylece `primary-subtle` satırda kaybolmaz (React CSS ile; Flutter'da `DyAvatar(onSurface: c.primarySubtle)`). Kontrast her iki temada tarayıcıda axe ile ölçüldü (Chip sayaç rengi bu sırada düzeltildi).

## Responsive

- DataTable < 600 px: başlık satırı görsel olarak gizlenir (ekran okuyucuya açık kalır), her satır karta dönüşür: seçim kutusu + birincil hücre başlık satırında, diğer hücreler "etiket — değer" çiftleri; `hideOnCompact` sütunlar gizlenir.
- Pagination < 600 px: sayfa numaraları yerine "3 / 12" ve önceki/sonraki.
- FilterBar: çipler satır kaydırır; mobil Flutter karşılığı `DyFilterChips` yatay kaydırır.
- StatCard ızgarası kullanım yerindedir (katalogda `auto-fit` örneği).
- Avatar Flutter'da metin ölçeği 1,3 ile sınırlanır; daire bozulmaz, ad ekran okuyucudan okunur.

## Klavye ve erişilebilirlik

- Etkileşimli Card: `role="button"` + Enter/Space; `href` ile gerçek bağlantı. İçinde ikinci etkileşimli öğe olmamalı: React geliştirme modunda konsol uyarısı verir (axe `nested-interactive` bulgusundan sonra eklendi). Eylem gerekiyorsa kartı etkileşimsiz bırakıp eylemi `CardHeader action` alanına koyun.
- ListItem: tıklanabilir satır buton/bağlantı; statik satır `li`.
- Avatar: `role="img"` + ad; `decorative` iken gizli. AvatarGroup `role="group"` + etiket, "+N" için "N kişi daha".
- ProgressBar/Ring: `role="progressbar"`, `aria-valuenow` max ile sınırlı, `aria-valuetext` (ör. "68 / 120 g"); halkanın orta içeriği okunmaz. Belirsiz durumda `aria-valuenow` yok.
- StatCard: `section` + `aria-label`; değişim ikon + metin (renk tek gösterge değil), eksi işareti U+2212.
- Chip: `aria-pressed` (Flutter `toggled`).
- DataTable: `caption`, `scope="col"`, sıralanabilir başlıkta buton + `aria-sort` (none → ascending → descending → none), satır seçiminde "Elif Yıldız seç" etiketli onay kutuları, tümünü seç karışık durumu. Satıra tıklama ilk hücredeki buton üzerinden — klavyeyle erişilir, satır `::after` ile tüm alanı tıklanabilir yapar.
- Pagination: `nav` + etiket, "Sayfa 3" butonları, `aria-current`.
- FilterBar: `role="search"`, filtre grubu `role="group"`, sonuç metni `aria-live="polite"`.

## Uzun metin, hata, boş değer

- ListItem açıklaması iki satırdan sonra kısaltılır (`maxDescriptionLines`); başlık kısaltılmaz.
- DataTable hücreleri satır kaydırır; sayısal sütunlar tabular rakam ve sağa hizalı.
- %200 metin ölçeğinde 320 px'te yatay taşma yok: web'de Playwright ile (cards, progress, table, table-states) ölçüldü; Flutter'da widget testi yazıldı (çalıştırılamadı, bkz. Faz 2 raporu).
- Boş değer "—"; gizli değer "Gizli" + göz ikonu ve sunucudan hiç gelmez (karar 15).

## Do / Don't

- Do: makro ilerlemesinde `valueText` ile birimli metin ver ("142 / 220 g"). Don't: yalnızca yüzde ver.
- Do: hedef aşımını metinle söyle ("hedefin üstünde"). Don't: yalnızca kırmızı renk kullan.
- Do: tablodaki satır eylemlerini satır seçimine ve toplu eylem çubuğuna bağla. Don't: her satıra ayrı buton dizisi koy.
- Do: düşüşün iyi olduğu metriklerde `deltaIntent="decrease-is-good"`. Don't: yönü renge göre tahmin ettir.

## Token'lar

`color.surface`, `surface-elevated`, `surface-secondary`, `surface-sunken`, `surface-inverse`, `text-on-inverse`, `primary`, `primary-subtle`, `on-primary-subtle`, `border-subtle`, `macro.carb/protein/fat`, `macro-track`, `success-strong`, `error-strong`, `text-muted`, `text-link`, `focus-ring` · `radius.sm/lg/xl/full` · `spacing.2xs–2xl` · `size.control-sm`, `target-min`, `target-comfortable`, `fab` · `border.width-hairline/strong`, `focus-width/offset` · `duration.fast/deliberate`, `ease.emphasized`, `ease.standard`.

## Desteklenmeyenler (bilinçli)

- DataTable: sütun yeniden boyutlandırma, sanal kaydırma, satır içi düzenleme, sütun sabitleme yok. 500+ satır için sunucu tarafı sayfalama beklenir.
- Grafikler (kilo trendi, haftalık uyum) bu grupta değil: Faz 3'te `dataviz` kurallarıyla ayrı component.
- Flutter'da DataTable/Pagination yok (danışan uygulamasında gerekmiyor).
- React `Chip` sayaç propu almaz (sayaç `FilterBar` seçeneğinde); Flutter `DyChip.count` vardır. React `ListItem.href` vardır; Flutter'da gezinme `onTap` ile yapılır.
- Avatar çevrimiçi/durum noktası (`status`) yalnız React'te; Flutter karşılığı Faz 3'te danışan listesiyle birlikte eklenecek.
