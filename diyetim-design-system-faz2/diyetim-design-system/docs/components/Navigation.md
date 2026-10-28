# Navigasyon ve katmanlar: AppBar · TopBar · Sidebar · BottomNavigation · Tabs · Breadcrumb · Dialog · ConfirmDialog · BottomSheet · Popover · Menu

## Platform kapsamı

| Component | React (panel) | Flutter (danışan) | Not |
| --- | --- | --- | --- |
| Sidebar | ✓ | — | Yalnızca diyetisyen paneli |
| TopBar, Breadcrumb | ✓ | — | Panel masaüstü başlığı |
| AppBar | ✓ (dar ekran) | ✓ `DyAppBar` | |
| BottomNavigation | ✓ (dar ekran) | ✓ `DyBottomNavigation` | Danışanda orta eylem: öğün fotoğrafı |
| Tabs | ✓ | ✓ `DyTabs` | |
| Dialog, ConfirmDialog | ✓ | ✓ `DyDialog.show`, `DyDialog.confirm` | |
| BottomSheet | ✓ | ✓ `DyBottomSheet.show` | |
| Popover, Menu | ✓ | ✓ `DyPopover`, `DyMenu` | Flutter: MenuAnchor tabanlı |

Mobil ve masaüstü aynı dili paylaşır ama ölçeklenmiş kopyalar değildir: panelde dar ekranda Sidebar gizlenir; yerine AppBar menü butonu ve BottomNavigation gelir.

## API özeti

- **Sidebar** `({ items: NavItem[], activeId, onNavigate?, collapsed?, header?, footer?, label? })`. `NavItem`: `id`, `label`, `icon`, `href?`, `badge?`, `badgeLabel?`. Etkin öğe `aria-current="page"`.
- **TopBar** `({ title, breadcrumb?, actions?, children? })`: sayfanın tek `h1`'i.
- **Breadcrumb** `({ items: { label, href?, onClick? }[] })`: son öğe `aria-current="page"`; dar ekranda yalnızca son iki seviye.
- **AppBar** `({ title, onBack?, onMenu?, actions? })` · Flutter `DyAppBar(title, onBack, actions, large)`.
  - `large` (Flutter): `Scaffold.appBar` içinde sabit yükseklik bildirir (h1 satır yüksekliği + `spacing.md`); metin ölçeği büyüyünce taşar. Metin ölçeklenen ekranlarda büyük başlık kaydırılan içeriğe konmalı. Faz 3: kayan büyük başlık (sliver) bileşeni.
- **BottomNavigation** `({ items, activeId, onNavigate?, centerAction? })` · Flutter `DyBottomNavigation(destinations, selectedIndex, onSelected, centerAction, centerActionLabel, onCenterAction)`.
- **Tabs** `({ label, items: { value, label, content, count?, countLabel?, disabled? }[], value?, onChange? })` · Flutter `DyTabs(label, tabs, selectedIndex, onSelected)`.
- **Dialog** `({ open, onClose, title, description?, children?, footer?, sheetOnCompact=true, dismissible=true, initialFocusRef?, size })`.
- **ConfirmDialog** `({ open, title, description, confirmLabel, cancelLabel, tone: 'default' | 'destructive', pending?, onConfirm, onCancel })` · Flutter `DyDialog.confirm(...) → Future<bool?>`.
- **BottomSheet** Dialog API'si, her genişlikte alttan · Flutter `DyBottomSheet.show(context, title, body, action)`.
- **Popover** `({ trigger, children | (close) => …, label, align })` · **Menu** `({ trigger, items: { id, label, icon?, destructive?, disabled?, onSelect }[], label, align })`.

## Responsive

| Öğe | < 600 | 600–1023 | ≥ 1024 |
| --- | --- | --- | --- |
| Sidebar | gizli | 72 px ray (etiketler ekran okuyucuya açık) | 264 px; `collapsed` ile 72 px |
| Dialog | alttan sayfa, eylemler tam genişlik ve ters sıralı (birincil üstte) | ortada kart | ortada kart |
| Breadcrumb | son iki seviye | tümü | tümü |
| Tabs | yatay kaydırılır | yatay kaydırılır | tek satır |

Bu davranışlar tarayıcı testleriyle doğrulanır (Sidebar genişliği 390/800/1280 px'te ölçülür; Dialog dar ekranda alta yapışık, masaüstünde ortada).

## Klavye ve erişilebilirlik

- Dialog: açılınca ilk odaklanabilir öğe (ConfirmDialog yıkıcıysa "Vazgeç"); Tab ve Shift+Tab içeride döner; Escape kapatır (pending iken kapanmaz); kapanınca odak açan öğeye döner; arka plan kaydırması kilitlenir; `aria-modal`, başlık ve açıklama bağlı.
- Tabs: APG; ←/→, Home/End, otomatik etkinleştirme, gezici tabindex; panel `aria-labelledby`.
- Menu: APG menu button; ↓/↑/Enter/Space açar, oklar gezer, devre dışı atlanır, harfle arama, Escape kapatır ve odağı geri verir.
- Popover: modal değil; Escape ve dışarı tıklama kapatır, odak tetikleyiciye döner.
- Sidebar: `nav` işareti; dar rayda bağlantılar erişilebilir adını korur, fareyle tooltip.
- BottomNavigation: hedefler en az 48 × 48; rozet sayısı bağlantının adına eklenir.

## Uzun metin, hata, boş değer

Navigasyon etiketleri kısa olmalı (1–2 kelime); uzun etiket alt gezinmede tek satırda kesilir, kenar çubuğunda satır kaydırır. Dialog içeriği uzunsa gövde kaydırılır, başlık ve eylemler görünür kalır.

## Token'lar

`color.surface-elevated`, `scrim`, `border-subtle`, `primary`, `surface-secondary`, `surface-inverse`, `text-on-inverse` · `radius.xl`, `radius.2xl`, `radius.md`, `radius.full` · `shadow.modal/high/medium` · `z.modal`, `z.dropdown`, `z.sticky` · `size.sidebar`, `size.sidebar-rail`, `size.app-bar`, `size.nav-bottom`, `size.target-comfortable` · `duration.normal`, `ease.emphasized`.

## Desteklenmeyenler

İç içe menüler, sekmelerin manuel etkinleştirme modu, Sidebar'da açılır alt gruplar, sürüklenerek yüksekliği ayarlanan web BottomSheet, tam ekran Dialog.

## Testler

Web: `navigation.test.tsx` (21 test); katalog `tabs`, `shell`, `shell-collapsed`, `mobilenav`, `layers`, `dialog-open` görselleri; tarayıcıda odak tuzağı, alttan sayfa konumu, Menu ve Sidebar responsive testleri. Flutter: `navigation_test.dart`.
