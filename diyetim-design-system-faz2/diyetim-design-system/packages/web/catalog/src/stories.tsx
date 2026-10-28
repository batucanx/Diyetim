import { useState, type ReactNode } from 'react';
import {
  Text, NumberDisplay, Icon, Surface, Stack, Skeleton, Pressable, Button, IconButton, Fab, TextField, SearchField, NumberField,
  Textarea, Select, MultiSelect, Checkbox, RadioGroup, Switch, SegmentedControl, type SelectOption,
  Tag, StatusTag, SourceTag, Badge, Tooltip, Alert, Banner, ToastProvider, useToast, EmptyState, ErrorState, OfflineState, LoadingRegion,
  Dialog, ConfirmDialog, Popover, Menu, Tabs, Sidebar, TopBar, Breadcrumb, AppBar, BottomNavigation, type NavItem,
  Card, CardHeader, List, ListItem, Avatar, AvatarGroup, ProgressBar, ProgressRing, StatCard, Chip, DataTable, Pagination, FilterBar,
  type Column, type SortState,
} from '@diyetim/ui';
import { MealStatus, AppointmentStatus, LabValueStatus } from '@diyetim/tokens';

export const LONG = 'Diyetisyenime bugünkü tüm öğünlerimi onay için gönder; ğüşıöç İİ harfleri kırpılmadan görünmeli';

const meals: SelectOption[] = [
  { value: 'breakfast', label: 'Kahvaltı' }, { value: 'lunch', label: 'Öğle yemeği' },
  { value: 'dinner', label: 'Akşam yemeği', disabled: true }, { value: 'snack', label: 'Ara öğün', description: 'İkindi veya gece' },
];

function NumberFieldDemo() {
  const [v, setV] = useState<number | null>(150);
  return <NumberField label="Gramaj" unit="g" value={v} onChange={setV} min={0} max={1000} step={10} description="Hızlı seçim: 50 · 100 · 150 · 200 g" />;
}

type Row = { id: string; name: string; status: (typeof MealStatus)[number]; adherence: number; last: string };
const ROWS: Row[] = [
  { id: '1', name: 'Elif Yıldız', status: 'pending-review', adherence: 86, last: '12:45' },
  { id: '2', name: 'Batuhan Kaya', status: 'needs-correction', adherence: 72, last: '09:10' },
  { id: '3', name: 'Şule Demir-Öztürkoğlu', status: 'approved', adherence: 91, last: '13:20' },
  { id: '4', name: 'İsmail Işık', status: 'logged', adherence: 64, last: 'Dün' },
];
const COLS: Column<Row>[] = [
  { key: 'name', header: 'Danışan', sortable: true, cell: (r) => <Stack direction="horizontal" gap="sm" align="center"><Avatar name={r.name} size="sm" />{r.name}</Stack> },
  { key: 'status', header: 'Son öğün', cell: (r) => <StatusTag kind="meal" status={r.status} /> },
  { key: 'adherence', header: 'Uyum', numeric: true, sortable: true, cell: (r) => `%${r.adherence}` },
  { key: 'last', header: 'Son kayıt', numeric: true, hideOnCompact: true },
];

function TableDemo({ state }: { state?: 'loading' | 'error' }) {
  const [sort, setSort] = useState<SortState>({ key: 'adherence', direction: 'descending' });
  const [sel, setSel] = useState<Set<string>>(new Set(['2']));
  const [page, setPage] = useState(3);
  const [q, setQ] = useState('');
  const [f, setF] = useState<string[]>(['attention']);
  const rows = [...ROWS].sort((a, b) => !sort ? 0 : (sort.direction === 'ascending' ? 1 : -1) * (sort.key === 'adherence' ? a.adherence - b.adherence : a.name.localeCompare(b.name, 'tr')));
  return (
    <Stack gap="lg">
      <FilterBar search={{ label: 'Danışan ara', value: q, onChange: setQ, placeholder: 'Ad, telefon veya e-posta' }}
        filters={{ label: 'Durum', options: [{ value: 'attention', label: 'Dikkat gerektiren', count: 4 }, { value: 'pending', label: 'Onay bekleyen', count: 12 }, { value: 'new', label: 'Yeni' }], value: f, onChange: setF }}
        onClearAll={() => { setQ(''); setF([]); }} resultText="4 danışan" extra={<Button size="sm" variant="secondary" iconStart="plus">Davet et</Button>} />
      <DataTable caption="Danışanlar" columns={COLS} rows={state ? [] : rows} rowKey={(r) => r.id} rowLabel={(r) => r.name} sort={sort} onSortChange={setSort}
        selected={sel} onSelectedChange={setSel} onRowClick={() => {}} state={state} errorKind="network" onRetry={() => {}} />
      <Pagination page={page} pageCount={12} onChange={setPage} summary="41–60 / 248 danışan" />
    </Stack>
  );
}

function ToastDemo() {
  const toast = useToast();
  return (
    <Stack direction="horizontal" gap="md" wrap>
      <Button variant="secondary" onClick={() => toast({ message: 'Öğle öğünü kaydedildi', action: { label: 'Geri al', onAction: () => {} } })}>Snackbar göster</Button>
      <Button variant="tertiary" onClick={() => toast({ message: 'Plan güncellendi', tone: 'info' })}>Toast göster</Button>
    </Stack>
  );
}

const PATIENT_NAV: NavItem[] = [
  { id: 'today', label: 'Bugün', icon: 'home' }, { id: 'plan', label: 'Plan', icon: 'plan' },
  { id: 'progress', label: 'İlerleme', icon: 'chart' }, { id: 'profile', label: 'Profil', icon: 'user' },
];

const NAV: NavItem[] = [
  { id: 'queue', label: 'Onay kuyruğu', icon: 'checkCircle', badge: 12, badgeLabel: '12 öğün onay bekliyor' },
  { id: 'patients', label: 'Danışanlar', icon: 'users' },
  { id: 'calendar', label: 'Takvim', icon: 'calendar' },
  { id: 'plans', label: 'Diyet planları', icon: 'plan' },
  { id: 'settings', label: 'Ayarlar', icon: 'settings' },
];

function DialogDemo({ initialOpen = false, confirm = false }: { initialOpen?: boolean; confirm?: boolean }) {
  const [open, setOpen] = useState(initialOpen);
  return (
    <>
      <Button variant={confirm ? 'destructive' : 'secondary'} onClick={() => setOpen(true)}>{confirm ? 'Randevuyu iptal et' : 'Not ekle'}</Button>
      {confirm ? (
        <ConfirmDialog open={open} tone="destructive" title="Randevu iptal edilsin mi?" description="15 Ekim 10:30 randevusu iptal edilecek ve danışana bildirim gidecek." confirmLabel="İptal et" onConfirm={() => setOpen(false)} onCancel={() => setOpen(false)} />
      ) : (
        <Dialog open={open} onClose={() => setOpen(false)} title="Öğün notu" description="Elif bu notu öğle öğününde görecek." footer={<><Button variant="tertiary" onClick={() => setOpen(false)}>Vazgeç</Button><Button onClick={() => setOpen(false)}>Kaydet</Button></>}>
          <Textarea label="Not" defaultValue="Harika bir tabak! Akşam karbonhidratı hafif tutalım." maxLength={200} />
        </Dialog>
      )}
    </>
  );
}

export interface Story { id: string; group: 'A' | 'B' | 'C' | 'D' | 'E'; title: string; render: () => ReactNode }

export const stories: Story[] = [
  { id: 'text', group: 'A', title: 'Text', render: () => (
    <Stack gap="sm">
      <Text variant="display">Günaydın, Elif</Text>
      <Text variant="h1">Bugünkü beslenmen</Text><Text variant="h2">Öğle yemeği</Text><Text variant="h3">Tavuklu kinoa tabağı</Text>
      <Text variant="h4">Diyetisyen notu</Text>
      <Text variant="body-lg">Diyetisyenin planını güncelledi; akşam öğününde değişiklik var.</Text>
      <Text>Tabağının fotoğrafını çek, diyetisyenin onaylasın.</Text>
      <Text variant="body-sm" tone="secondary">Son eşitleme 12:46 · Değişiklikler anında geçerli</Text>
      <Text variant="caption" tone="muted">140 g · Izgara · 14:20</Text>
      <Text variant="label">Öğün ekle</Text>
      <Text maxLines={2}>{LONG} {LONG}</Text>
    </Stack>
  ) },
  { id: 'number', group: 'A', title: 'NumberDisplay', render: () => (
    <Stack gap="md">
      <NumberDisplay value={941} unit="kcal" variant="numeric-xl" label="Kalan kalori" />
      <NumberDisplay value={68.4} unit="kg" variant="numeric-lg" label="Kilo" />
      <Stack direction="horizontal" gap="lg" wrap>
        <NumberDisplay value={1842} unit="kcal" /><NumberDisplay value={6.3} unit="g" /><NumberDisplay value={0.48} format="percent" />
        <NumberDisplay value={null} unit="mg/dL" /><NumberDisplay value={null} visibility="hidden" label="Kilo" />
      </Stack>
      <Stack gap="2xs"><NumberDisplay value={111111} unit="kcal" variant="numeric-lg" /><NumberDisplay value={888888} unit="kcal" variant="numeric-lg" /></Stack>
    </Stack>
  ) },
  { id: 'icon', group: 'A', title: 'Icon', render: () => (
    <Stack direction="horizontal" gap="lg" wrap align="center">
      {(['home', 'plan', 'camera', 'chart', 'user', 'search', 'lock', 'eyeOff', 'spark', 'calendar', 'bell', 'checkCircle'] as const).map((n) => <Icon key={n} name={n} size="lg" />)}
      <Icon name="lock" size="sm" /><Icon name="lock" size="md" /><Icon name="lock" size="lg" /><Icon name="lock" size="xl" label="Kilitli" />
    </Stack>
  ) },
  { id: 'surface', group: 'A', title: 'Surface ve Stack', render: () => (
    <Stack gap="lg">
      {(['none', 'low', 'medium', 'high'] as const).map((e) => (
        <Surface key={e} elevation={e} padding="xl" radius="lg"><Text variant="h4">elevation-{e}</Text><Text variant="body-sm" tone="muted">surface · radius-lg · padding xl</Text></Surface>
      ))}
      <Surface level="secondary" padding="lg" radius="md"><Text variant="body-sm">surface-secondary</Text></Surface>
      <Surface level="sunken" padding="lg" radius="md"><Text variant="body-sm" tone="secondary">surface-sunken (kilitli alan)</Text></Surface>
      <Surface level="inverse" padding="lg" radius="md"><Text variant="body-sm" tone="on-inverse">surface-inverse</Text></Surface>
    </Stack>
  ) },
  { id: 'skeleton', group: 'A', title: 'Skeleton', render: () => (
    <Surface padding="xl" aria-busy="true">
      <span className="dy-visually-hidden">Öğün yükleniyor</span>
      <Stack direction="horizontal" gap="lg" align="center">
        <Skeleton shape="rect" width="var(--size-fab)" height="var(--size-fab)" radius="md" />
        <div style={{ flex: 1 }}><Skeleton shape="text" lines={3} /></div>
        <Skeleton shape="circle" width="var(--size-control-sm)" height="var(--size-control-sm)" />
      </Stack>
    </Surface>
  ) },
  { id: 'pressable', group: 'A', title: 'Pressable ve odak halkası', render: () => (
    <Stack direction="horizontal" gap="md" wrap>
      <Pressable className="dy-focus-ring" data-testid="press">Basılabilir alan</Pressable>
      <Pressable state="locked" lockedReason="Diyetisyenin kapattı">Kilitli</Pressable>
    </Stack>
  ) },
  { id: 'button', group: 'B', title: 'Button', render: () => (
    <Stack gap="md">
      <Stack direction="horizontal" gap="md" wrap>
        <Button size="lg">Öğünü kaydet</Button><Button variant="secondary" size="lg" iconStart="plus">Plana ekle</Button><Button variant="tertiary" size="lg">Vazgeç</Button>
      </Stack>
      <Stack direction="horizontal" gap="md" wrap>
        <Button>Onayla</Button><Button variant="ghost" iconStart="note">Not ekle</Button><Button variant="destructive">Randevuyu iptal et</Button>
        <Button size="sm" variant="tertiary">Panel</Button>
      </Stack>
      <Stack direction="horizontal" gap="md" wrap>
        <Button state="loading">Kaydediliyor</Button><Button state="disabled">Devre dışı</Button><Button state="locked" lockedReason="Plan dışı ekleme kapalı">Besin ekle</Button>
      </Stack>
      <Button fullWidth size="lg">{LONG}</Button>
      <Stack direction="horizontal" gap="md" align="center">
        <IconButton icon="chevronLeft" label="Geri" /><IconButton icon="bell" label="Bildirimler" variant="surface" /><IconButton icon="plus" label="Ekle" variant="primary" /><Fab icon="camera" label="Öğün fotoğrafı çek" />
      </Stack>
    </Stack>
  ) },
  { id: 'textfield', group: 'B', title: 'TextField, SearchField, NumberField, Textarea', render: () => (
    <Stack gap="lg">
      <SearchField label="Besin ara" hideLabel placeholder="Yulaf, tavuk, mercimek…" defaultValue="yulaf" />
      <TextField label="Ad" placeholder="Adın" description="Diyetisyenin seni bu adla görür." />
      <NumberFieldDemo />
      <TextField label="Kilo" defaultValue="6,84" suffix="kg" error="Bu değer çok düşük görünüyor. 68,4 mü olacaktı?" />
      <TextField label="E-posta" defaultValue="elif@ornek.com" success="Doğrulandı" />
      <TextField label="Porsiyon" defaultValue="1 kase (200 g)" state="locked" lockedReason="Diyetisyenin gramaj değişikliğini kapattı." />
      <TextField label="Telefon" state="disabled" placeholder="Devre dışı" />
      <TextField label="Kod" state="loading" defaultValue="483 920" />
      <TextField label={LONG} defaultValue={LONG} />
      <Textarea label="Diyetisyen notu" maxLength={200} defaultValue="Harika bir tabak! Protein dengen çok başarılı." />
    </Stack>
  ) },
  { id: 'select', group: 'B', title: 'Select ve MultiSelect', render: () => (
    <Stack gap="lg">
      <Select label="Öğün tipi" options={meals} defaultValue="lunch" />
      <Select label="Öğün tipi (boş)" options={meals} placeholder="Öğün seçin" />
      <MultiSelect label="Kategoriler" options={meals} defaultValue={['breakfast', 'snack']} />
      <Select label="Hata" options={meals} error="Öğün tipi seçin." />
      <Select label="Kilitli" options={meals} defaultValue="breakfast" state="locked" lockedReason="Diyetisyen belirledi" />
    </Stack>
  ) },
  { id: 'select-open', group: 'B', title: 'Select (açık liste)', render: () => <Select label="Öğün tipi" options={meals} defaultValue="lunch" /> },
  { id: 'choice', group: 'B', title: 'Checkbox, RadioGroup, Switch, SegmentedControl', render: () => (
    <Stack gap="lg">
      <Checkbox label="Hatırlatma al" description="Öğün saatinden 15 dk önce" defaultChecked />
      <Checkbox label="Tümünü seç" indeterminate />
      <Checkbox label="Fotoğraf zorunlu" defaultChecked state="locked" lockedReason="Klinik ayarı" />
      <Checkbox label="Koşulları kabul ediyorum" error="Devam etmek için onaylayın." />
      <RadioGroup label="Görüşme tipi" options={[{ value: 'online', label: 'Online (15 dk)' }, { value: 'clinic', label: 'Yüz yüze' }, { value: 'p', label: 'Telefon', disabled: true }]} defaultValue="online" />
      <Surface padding="lg">
        <Stack gap="md">
          <Switch label="Kilo ve BMI" description="Danışan kendi kilosunu görür" defaultChecked />
          <Switch label="Kalori değerleri" description="Kapalıyken halka rakamsız gösterilir" />
          <Switch label="Öğün fotoğrafı zorunlu" defaultChecked state="locked" lockedReason="Klinik ayarı" />
          <Switch label="Kaydediliyor" defaultChecked state="loading" />
        </Stack>
      </Surface>
      <SegmentedControl label="Dönem" options={[{ value: 'd', label: 'Gün' }, { value: 'w', label: 'Hafta' }, { value: 'm', label: 'Ay' }]} defaultValue="w" fullWidth />
    </Stack>
  ) },
  { id: 'tags', group: 'C', title: 'Tag, StatusTag, SourceTag, Badge', render: () => (
    <Stack gap="md">
      <Stack direction="horizontal" gap="sm" wrap>{MealStatus.map((st) => <StatusTag key={st} kind="meal" status={st} />)}</Stack>
      <Stack direction="horizontal" gap="sm" wrap>{AppointmentStatus.map((st) => <StatusTag key={st} kind="appointment" status={st} />)}</Stack>
      <Stack direction="horizontal" gap="sm" wrap>{LabValueStatus.map((st) => <StatusTag key={st} kind="lab" status={st} />)}</Stack>
      <Stack direction="horizontal" gap="lg" wrap><SourceTag source="patient" /><SourceTag source="dietitian" /><SourceTag source="ai" /><SourceTag source="verified" /></Stack>
      <Stack direction="horizontal" gap="md" align="center"><Badge count={3} label="3 bildirim" /><Badge count={12} label="12 öğün onay bekliyor" tone="error" /><Badge count={240} label="240 bildirim" tone="neutral" /><Tag tone="info" icon="info">{LONG}</Tag></Stack>
    </Stack>
  ) },
  { id: 'alerts', group: 'C', title: 'Alert, Banner, Tooltip', render: () => (
    <Stack gap="md">
      <Alert tone="info" title="Diyetisyenin planını güncelledi">Akşam öğününde değişiklik var.</Alert>
      <Alert tone="success" title="Tahlil yüklendi" onDismiss={() => {}}>12 değer okundu, 1 değer belirsiz.</Alert>
      <Alert tone="warning" title="Fotoğraf gerekli" actions={<Button size="sm" variant="tertiary" iconStart="camera">Fotoğraf çek</Button>}>Bu öğün fotoğrafsız onaylanamaz.</Alert>
      <Alert tone="error" title="Kaydedilemedi">Bağlantı koptu. Girdiğin bilgiler kaybolmadı.</Alert>
      <Banner tone="info" title="Bakım: 02.00–03.00 arası panel salt okunur olacak" />
      <Stack direction="horizontal" gap="md"><Tooltip content="Öğün fotoğrafı çek"><IconButton icon="camera" label="Kamera" variant="surface" /></Tooltip></Stack>
    </Stack>
  ) },
  { id: 'states', group: 'C', title: 'EmptyState, ErrorState, OfflineState, LoadingRegion', render: () => (
    <Stack gap="lg">
      <OfflineState pendingCount={3} onRetry={() => {}} />
      <Surface radius="lg"><EmptyState size="compact" headingLevel={3} title="Bugün için öğün yok" description="Diyetisyenin henüz bugünün planını yayınlamadı. Plan dışı besin ekleyebilirsin." action={<Button iconStart="search">Besin ara</Button>} /></Surface>
      <Surface radius="lg"><ErrorState size="compact" headingLevel={3} kind="network" onAction={() => {}} /></Surface>
      <Surface radius="lg"><ErrorState size="compact" headingLevel={3} kind="permission" onAction={() => {}} /></Surface>
      <Surface padding="xl"><LoadingRegion loading label="Öğünler" skeleton={<Skeleton shape="text" lines={3} />}><p>İçerik</p></LoadingRegion></Surface>
    </Stack>
  ) },
  { id: 'toast', group: 'C', title: 'Toast ve Snackbar', render: () => <ToastProvider><ToastDemo /></ToastProvider> },
  { id: 'tabs', group: 'D', title: 'Tabs ve Breadcrumb', render: () => (
    <Stack gap="lg">
      <Breadcrumb items={[{ label: 'Panel', href: '#' }, { label: 'Danışanlar', href: '#' }, { label: 'Elif Yıldız' }]} />
      <Tabs label="Danışan detayı" defaultValue="gunluk" items={[
        { value: 'ozet', label: 'Özet', content: <Text tone="secondary">Özet içerik</Text> },
        { value: 'gunluk', label: 'Günlük akış', count: 3, countLabel: '3 öğün onay bekliyor', content: <Text tone="secondary">Günlük akış içerik</Text> },
        { value: 'plan', label: 'Plan', content: <Text tone="secondary">Plan</Text> },
        { value: 'tahlil', label: 'Tahliller', content: <Text tone="secondary">Tahliller</Text> },
        { value: 'yetki', label: 'Yetki ve görünürlük', content: <Text tone="secondary">Yetkiler</Text> },
      ]} />
    </Stack>
  ) },
  { id: 'shell', group: 'D', title: 'Sidebar ve TopBar (panel)', render: () => (
    <div style={{ display: 'flex', height: 'calc(var(--size-sidebar) * 2)', border: 'var(--border-width-hairline) solid var(--color-border-subtle)', borderRadius: 'var(--radius-lg)', overflow: 'hidden' }}>
      <Sidebar items={NAV} activeId="queue" header={<Text variant="h4">Diyetim Klinik</Text>} footer={<Text variant="caption" tone="muted">Dyt. Zeynep Kaya</Text>} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <TopBar title="Onay kuyruğu" breadcrumb={<Breadcrumb items={[{ label: 'Panel', href: '#' }, { label: 'Onay kuyruğu' }]} />} actions={<><Menu label="Kuyruk eylemleri" trigger={<IconButton icon="more" label="Diğer eylemler" />} items={[{ id: 'a', label: 'Tümünü onayla', icon: 'checkCircle', onSelect: () => {} }, { id: 'b', label: 'Dışa aktar', icon: 'file', onSelect: () => {} }]} /><Button size="sm" iconStart="filter" variant="tertiary">Filtrele</Button></>} />
      </div>
    </div>
  ) },
  { id: 'shell-collapsed', group: 'D', title: 'Sidebar dar ray', render: () => (
    <div style={{ display: 'flex', height: 'calc(var(--size-sidebar) * 1.6)' }}><Sidebar items={NAV} activeId="patients" collapsed /></div>
  ) },
  { id: 'mobilenav', group: 'D', title: 'AppBar ve BottomNavigation (dar ekran)', render: () => (
    <div style={{ maxWidth: 'calc(var(--size-sidebar) * 1.6)', border: 'var(--border-width-hairline) solid var(--color-border-subtle)', borderRadius: 'var(--radius-xl)', overflow: 'hidden', background: 'var(--color-background)' }}>
      <AppBar title="Onay kuyruğu" onMenu={() => {}} actions={<IconButton icon="search" label="Ara" />} />
      <div style={{ height: 'calc(var(--size-sidebar) * 0.8)' }} />
      <BottomNavigation items={NAV.slice(0, 4)} activeId="queue" centerAction={{ icon: 'checkCircle', label: 'Hızlı onay', onClick: () => {} }} />
      <div style={{ height: 'var(--spacing-md)' }} />
    </div>
  ) },
  { id: 'layers', group: 'D', title: 'Dialog, ConfirmDialog, Popover, Menu', render: () => (
    <Stack direction="horizontal" gap="md" wrap>
      <DialogDemo /><DialogDemo confirm />
      <Popover label="Filtreler" trigger={<Button variant="tertiary" iconStart="filter">Filtrele</Button>}>{(close) => (<Stack gap="md"><Select label="Öğün tipi" options={meals} /><Button onClick={close}>Uygula</Button></Stack>)}</Popover>
      <Menu label="Öğün eylemleri" trigger={<Button variant="ghost" iconEnd="chevronDown">Eylemler</Button>} items={[{ id: 'e', label: 'Düzenle', icon: 'note', onSelect: () => {} }, { id: 'c', label: 'Kopyala', disabled: true, onSelect: () => {} }, { id: 'x', label: 'Sil', icon: 'x', destructive: true, onSelect: () => {} }]} />
    </Stack>
  ) },
  { id: 'cards', group: 'E', title: 'Card, ListItem, Avatar', render: () => (
    <Stack gap="lg">
      <Card variant="hero"><CardHeader title="Bugünkü plan" subtitle="4 öğün · 1.800 kcal hedef" action={<Button size="sm" variant="tertiary">Düzenle</Button>} />
        <List label="Öğünler">
          <ListItem leading={<Icon name="leaf" />} title="Kahvaltı" description="Yulaf, yoğurt, ceviz" trailing="320 kcal" meta={<StatusTag kind="meal" status={'approved'} />} onClick={() => {}} />
          <ListItem leading={<Icon name="flame" />} title="Öğle yemeği" description={LONG} trailing="540 kcal" meta={<StatusTag kind="meal" status={'pending-review'} />} onClick={() => {}} />
          <ListItem leading={<Icon name="clock" />} title="Akşam yemeği" description="Henüz kaydedilmedi" trailing="—" />
        </List>
      </Card>
      <Stack direction="horizontal" gap="md" wrap>
        <Card interactive onClick={() => {}} aria-label="Elif Yıldız danışan kartı"><Stack direction="horizontal" gap="md" align="center"><Avatar name="Elif Yıldız" verified /><Stack gap="2xs"><Text variant="h4">Elif Yıldız</Text><Text variant="caption" tone="muted">3 öğün onay bekliyor</Text></Stack></Stack></Card>
        <Card variant="raised" selected><Stack direction="horizontal" gap="md" align="center"><AvatarGroup label="Bugünkü randevular" people={[{ name: 'Elif Yıldız' }, { name: 'Batuhan Kaya' }, { name: 'Şule Demir' }, { name: 'İsmail Işık' }, { name: 'Ömer Çelik' }]} max={3} /><Text variant="body-sm" tone="secondary">5 randevu</Text></Stack></Card>
      </Stack>
      <Stack direction="horizontal" gap="sm" wrap><Avatar name="Zeynep Kaya" size="sm" /><Avatar name="Zeynep Kaya" /><Avatar name="Zeynep Kaya" size="lg" /><Avatar name="Zeynep Kaya" size="xl" /></Stack>
    </Stack>
  ) },
  { id: 'progress', group: 'E', title: 'ProgressBar, ProgressRing, StatCard', render: () => (
    <Stack gap="lg">
      <Stack direction="horizontal" gap="lg" wrap align="center">
        <ProgressRing value={859} max={1800} size="lg" label="Kalori" valueText="859 / 1.800 kcal"><Stack gap="0" align="center"><NumberDisplay value={941} variant="numeric-lg" /><Text variant="caption" tone="muted">kcal kaldı</Text></Stack></ProgressRing>
        <ProgressRing value={6} max={8} label="Su" valueText="6 / 8 bardak" tone="warning" />
        
      </Stack>
      <Stack gap="md">
        <ProgressBar value={142} max={220} label="Karbonhidrat" valueText="142 / 220 g" tone="carb" showLabel />
        <ProgressBar value={68} max={120} label="Protein" valueText="68 / 120 g" tone="protein" showLabel />
        <ProgressBar value={71} max={60} label="Yağ" valueText="71 / 60 g · hedefin üstünde" tone="fat" showLabel />
        <ProgressBar value={null} label="Fotoğraf yükleniyor" />
      </Stack>
      <div style={{ display: 'grid', gap: 'var(--spacing-md)', gridTemplateColumns: 'repeat(auto-fit, minmax(min(100%, calc(var(--size-sidebar) * 0.75)), 1fr))' }}>
        <StatCard label="Aktif danışan" value={48} delta={3} deltaIntent="increase-is-good" deltaContext="bu ay" icon="users" />
        <StatCard label="Onay bekleyen öğün" value={12} delta={-5} deltaIntent="decrease-is-good" deltaContext="dünden" icon="clock" />
        <StatCard label="Ortalama plana uyum" value={86} unit="%" delta={0} deltaContext="geçen hafta ile aynı" />
        <StatCard label="Kilo" value={null} visibility="hidden" />
        <StatCard label="Yeni tahlil" value={null} />
      </div>
    </Stack>
  ) },
  { id: 'table', group: 'E', title: 'DataTable, FilterBar, Pagination', render: () => <TableDemo /> },
  { id: 'table-states', group: 'E', title: 'DataTable durumları', render: () => (
    <Stack gap="xl"><TableDemo state="loading" /><TableDemo state="error" />
      <DataTable caption="Boş" columns={COLS} rows={[]} rowKey={(r) => r.id} empty={{ title: 'Henüz danışan yok', description: 'Davet bağlantısı göndererek ilk danışanını ekle.' }} />
      <Stack direction="horizontal" gap="sm" wrap><Chip selected>Tahıl</Chip><Chip>Süt ürünleri</Chip><Chip disabled>Kuruyemiş</Chip><Chip icon="leaf" removable selected>Glutensiz</Chip></Stack>
    </Stack>
  ) },
  { id: 'integration-today', group: 'E', title: 'Entegrasyon: Bugün (yalnızca component birleşimi)', render: () => (
    <div style={{ maxWidth: 'calc(var(--size-sidebar) * 1.6)', border: 'var(--border-width-hairline) solid var(--color-border-subtle)', borderRadius: 'var(--radius-xl)', overflow: 'hidden', background: 'var(--color-background)' }}>
      <AppBar title="Bugün" actions={<IconButton icon="bell" label="Bildirimler" />} />
      <div style={{ padding: 'var(--spacing-lg)' }}>
        <Stack gap="lg">
          <OfflineState pendingCount={2} onRetry={() => {}} />
          <Card variant="hero">
            <Stack direction="horizontal" gap="lg" align="center" wrap>
              <ProgressRing value={859} max={1800} label="Kalori" valueText="859 / 1.800 kcal"><Stack gap="0" align="center"><NumberDisplay value={941} variant="numeric-lg" /><Text variant="caption" tone="muted">kcal kaldı</Text></Stack></ProgressRing>
              <Stack gap="sm" style={{ flex: 1, minWidth: 'calc(var(--size-sidebar) * 0.5)' }}>
                <ProgressBar value={142} max={220} label="Karbonhidrat" valueText="142 / 220 g" tone="carb" showLabel size="sm" />
                <ProgressBar value={68} max={120} label="Protein" valueText="68 / 120 g" tone="protein" showLabel size="sm" />
                <ProgressBar value={41} max={60} label="Yağ" valueText="41 / 60 g" tone="fat" showLabel size="sm" />
              </Stack>
            </Stack>
          </Card>
          <Card><CardHeader title="Öğünler" subtitle="2 / 4 kaydedildi" />
            <List label="Bugünkü öğünler">
              <ListItem leading={<Icon name="leaf" />} title="Kahvaltı" description="Yulaf, yoğurt, ceviz" trailing="320 kcal" meta={<StatusTag kind="meal" status="approved" />} onClick={() => {}} />
              <ListItem leading={<Icon name="flame" />} title="Öğle yemeği" description="Mercimek çorbası, salata" trailing="540 kcal" meta={<StatusTag kind="meal" status="pending-review" />} onClick={() => {}} />
              <ListItem leading={<Icon name="clock" />} title="Akşam yemeği" description="Somon, bulgur" trailing="19:00" meta={<StatusTag kind="meal" status="planned" />} onClick={() => {}} />
            </List>
          </Card>
          <StatCard label="Kilo" value={null} visibility="hidden" />
        </Stack>
      </div>
      <BottomNavigation items={PATIENT_NAV} activeId="today" centerAction={{ icon: 'camera', label: 'Öğün fotoğrafı ekle', onClick: () => {} }} />
    </div>
  ) },
  { id: 'dialog-open', group: 'D', title: 'Dialog (açık)', render: () => <DialogDemo initialOpen /> },
];
