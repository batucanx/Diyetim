import { useState, type ReactNode } from 'react';
import {
  Text, NumberDisplay, Icon, Surface, Stack, Skeleton, Pressable, Button, IconButton, Fab, TextField, SearchField, NumberField,
  Textarea, Select, MultiSelect, Checkbox, RadioGroup, Switch, SegmentedControl, type SelectOption,
  Tag, StatusTag, SourceTag, Badge, Tooltip, Alert, Banner, ToastProvider, useToast, EmptyState, ErrorState, OfflineState, LoadingRegion,
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

function ToastDemo() {
  const toast = useToast();
  return (
    <Stack direction="horizontal" gap="md" wrap>
      <Button variant="secondary" onClick={() => toast({ message: 'Öğle öğünü kaydedildi', action: { label: 'Geri al', onAction: () => {} } })}>Snackbar göster</Button>
      <Button variant="tertiary" onClick={() => toast({ message: 'Plan güncellendi', tone: 'info' })}>Toast göster</Button>
    </Stack>
  );
}

export interface Story { id: string; group: 'A' | 'B' | 'C'; title: string; render: () => ReactNode }

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
];
