# Durum ve geri bildirim: Tag · StatusTag · SourceTag · Badge · Tooltip · Alert · Banner · Toast · Snackbar · EmptyState · ErrorState · OfflineState · LoadingRegion

Hangi geri bildirim ne zaman:

| Durum | Component | Neden |
| --- | --- | --- |
| Bir nesnenin durumu (öğün onay bekliyor) | StatusTag | Kalıcı, nesneye bağlı |
| Verinin kaynağı | SourceTag | Güven ilkesi |
| Sayı (okunmamış, kuyruk) | Badge | |
| Kısa ek açıklama | Tooltip | Zorunlu bilgi değil |
| Sayfa içi kalıcı mesaj | Alert | Kullanıcı okuyana kadar kalır |
| Sayfa üstü sistem durumu (çevrimdışı, bakım) | Banner / OfflineState | Tam genişlik, kalıcı |
| Eylemin sonucu (kaydedildi) | Toast | 4 sn, kendiliğinden kapanır |
| Geri alınabilir eylem | Snackbar (Toast + eylem) | 6 sn, "Geri al" |
| İçerik yok | EmptyState | Ne oldu, neden, ne yapılabilir |
| İçerik yüklenemedi | ErrorState | Sakin, eylemli |
| Yükleniyor | LoadingRegion + Skeleton | Layout kaymaz |

Hatalar toast ile gösterilmez (Flutter'da `assert`, web'de tip: `tone` yalnızca success · info).

## API

| Component | React | Flutter |
| --- | --- | --- |
| Tag | `Tag({ tone: StatusTone, icon?, children })` | `DyTag(label, tone: DyStatusTone, icon)` |
| StatusTag | `StatusTag({ kind: 'meal' \| 'appointment' \| 'lab', status })` | `DyStatusTag(DyMealStatus.x.style)` |
| SourceTag | `SourceTag({ source: DataSource })` | `DySourceTag(DyDataSource.x)` |
| Badge | `Badge({ count, label, max=99, tone })` | `DyBadge(count, label, max, tone)` |
| Tooltip | `Tooltip({ content, children, placement, delay })` | `DyTooltip(message, child)` |
| Alert / Banner | `Alert({ tone: FeedbackTone, title, children, actions, onDismiss, variant })`, `Banner` | `DyAlert(title, tone, message, actions, onDismiss, banner)` |
| Toast | `ToastProvider` + `useToast()({ message, tone, action?, duration? })` | `DyToast.show(context, message, tone, actionLabel, onAction, duration)` |
| EmptyState | `EmptyState({ icon, title, description, action, secondaryAction, size, headingLevel })` | `DyEmptyState(title, description, icon, action, secondaryAction, compact)` |
| ErrorState | `ErrorState({ kind: ErrorKind, title?, description?, onAction, actionLabel?, retrying, size, headingLevel })` | `DyErrorState(kind, title, description, onAction, actionLabel, retrying, compact)` |
| OfflineState | `OfflineState({ pendingCount, onRetry, retrying })` | `DyOfflineState(pendingCount, onRetry, retrying)` |
| LoadingRegion | `LoadingRegion({ loading, skeleton, children, label })` | `DyLoadingRegion(loading, skeleton, child, label)` |

Durum → ton, ikon ve çeviri anahtarı eşlemesi `spec/contracts.json` `statusStyles` içindedir; iki platforma üretilir ve test edilir (her enum değeri eşlenmiş, her ikon sette var). Varsayılan metinler `spec/i18n/tr.json`; uygulama `StringsProvider` / `DyStrings` ile kendi çevirisini verir.

`ErrorKind`: network · server · permission · timeout · processing · not-found. Her birinin varsayılan başlık, açıklama ve eylem metni vardır; permission ve not-found eylemi ikincil buton ("Geri dön").

## Durumlar ve davranış

- Tag/StatusTag: ikon + metin zorunlu; renk tek gösterge değil. Uzun metin satır kaydırır.
- Badge: 0 iken render edilmez; `max` üstü "99+". Erişilebilir ad `label`'dan.
- Tooltip (web): fare 400 ms gecikmeyle, klavye odağında anında; Escape kapatır; `aria-describedby`. Dokunmatikte görünmez (Flutter: uzun basma).
- Alert: error ve warning `role="alert"` / canlı bölge; info ve success `role="status"`. En fazla iki eylem.
- Toast (web): aynı anda tek bildirim, kuyruk; fare üzerindeyken ve odaktayken süre durur; `aria-live="polite"` bölge. Mobilde alt navigasyonun üstünde, masaüstünde sağ altta. Flutter'da ScaffoldMessenger kuyruğu.
- ErrorState: `retrying` iken eylem butonu loading.
- LoadingRegion: `aria-busy`, yüklenirken "Öğünler: Yükleniyor" duyurusu.

## Uzun metin, hata, boş değer

Metinlerin tamamı satır kaydırır; %200 metin ölçeğinde 320 px'te taşma olmadığı web'de tarayıcı testiyle, Flutter'da widget testiyle (yazıldı) denetlenir.

## Token'lar

`color.*-subtle`, `*-strong`, `success`, `primary`, `text-muted`, `surface-inverse`, `text-on-inverse`, `surface-secondary`, `warning-subtle/strong` · `radius.sm/md/lg/full` · `shadow.medium/high` · `z.tooltip`, `z.toast` · `size.nav-bottom`, `size.control-lg`, `size.target-min` · `duration.fast/normal`, `ease.enter`.

## Desteklenmeyenler

Bildirim merkezi (geçmiş listesi), push bildirim tasarımı, birden fazla eşzamanlı toast, tooltip içinde etkileşimli içerik (bunun için Popover, Grup D), ilerleme yüzdeli yükleme (ProgressBar, Grup E).

## Testler

Web: `feedback.test.tsx`; katalog `tags`, `alerts`, `states` görselleri, Snackbar ve Tooltip tarayıcı testleri. Flutter: `feedback_test.dart`.
