import { useState } from 'react';
import { render, screen, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import {
  Card, CardHeader, List, ListItem, Avatar, AvatarGroup, initials, ProgressBar, ProgressRing, StatCard, Chip, DataTable, Pagination, pageWindow, FilterBar,
  type Column, type SortState, Button,
} from '..';
import { expectNoA11yViolations } from './a11y';

describe('Card ve ListItem', () => {
  it('statik kart section; etkileşimli kart Enter ile tetiklenir', async () => {
    const fn = vi.fn();
    render(<><Card><CardHeader title="Özet" subtitle="Bu hafta" /></Card><Card interactive onClick={fn} aria-label="Elif Yıldız">x</Card></>);
    expect(screen.getByRole('heading', { level: 3, name: 'Özet' })).toBeInTheDocument();
    const c = screen.getByRole('button', { name: 'Elif Yıldız' });
    c.focus();
    await userEvent.keyboard('{Enter}');
    await userEvent.keyboard(' ');
    expect(fn).toHaveBeenCalledTimes(2);
  });
  it('etkileşimli kart içinde buton olursa geliştirmede uyarır', () => {
    const warn = vi.spyOn(console, 'warn').mockImplementation(() => {});
    render(<Card interactive onClick={() => {}} aria-label="K"><Button>x</Button></Card>);
    expect(warn).toHaveBeenCalledWith(expect.stringContaining('interactive kart içinde'));
    warn.mockRestore();
  });
  it('href verilen kart bağlantıdır', () => {
    render(<Card interactive href="/danisan/1" selected>Elif</Card>);
    expect(screen.getByRole('link', { name: 'Elif' })).toHaveAttribute('aria-current', 'page');
  });
  it('ListItem: tıklanabilir satır buton; statik satır li', async () => {
    const fn = vi.fn();
    render(<List label="Öğünler"><ListItem title="Kahvaltı" description="320 kcal" onClick={fn} /><ListItem title="Öğle" trailing="540 kcal" /></List>);
    await userEvent.click(screen.getByRole('button', { name: /Kahvaltı/ }));
    expect(fn).toHaveBeenCalledOnce();
    expect(screen.getByRole('list', { name: 'Öğünler' }).querySelectorAll('li')).toHaveLength(2);
  });
});

describe('Avatar', () => {
  it('Türkçe baş harfler', () => {
    expect(initials('elif yıldız')).toBe('EY');
    expect(initials('İsmail Işık')).toBe('İI');
    expect(initials('ayşe')).toBe('A');
  });
  it('erişilebilir ad, doğrulanmış rozeti; resim yüklenemezse baş harfler', () => {
    const { container } = render(<Avatar name="Zeynep Kaya" src="/yok.jpg" verified />);
    expect(screen.getByRole('img', { name: 'Zeynep Kaya' })).toBeInTheDocument();
    container.querySelector('img')!.dispatchEvent(new Event('error'));
    expect(container.querySelector('.dy-avatar__verified')).not.toBeNull();
  });
  it('AvatarGroup +N', () => {
    render(<AvatarGroup label="Bugünkü danışanlar" people={[{ name: 'A B' }, { name: 'C D' }, { name: 'E F' }, { name: 'G H' }, { name: 'I J' }]} max={3} />);
    expect(screen.getByRole('group', { name: 'Bugünkü danışanlar' })).toBeInTheDocument();
    expect(screen.getByRole('img', { name: '2 kişi daha' })).toHaveTextContent('+2');
  });
});

describe('ProgressBar ve ProgressRing', () => {
  it('progressbar değerleri ve valuetext', () => {
    render(<ProgressBar value={68} max={120} label="Protein" valueText="68 / 120 g" showLabel tone="protein" />);
    const pb = screen.getByRole('progressbar', { name: 'Protein' });
    expect(pb).toHaveAttribute('aria-valuenow', '68');
    expect(pb).toHaveAttribute('aria-valuetext', '68 / 120 g');
  });
  it('hedef aşımında çubuk dolu kalır, valuenow max ile sınırlı', () => {
    const { container } = render(<ProgressBar value={150} max={120} label="Karb." valueText="150 / 120 g" />);
    expect(screen.getByRole('progressbar')).toHaveAttribute('aria-valuenow', '120');
    expect((container.querySelector('.dy-progress__fill') as HTMLElement).style.width).toBe('100%');
  });
  it('belirsiz ilerleme valuenow taşımaz', () => {
    render(<ProgressBar value={null} label="Tahlil taranıyor" />);
    expect(screen.getByRole('progressbar')).not.toHaveAttribute('aria-valuenow');
  });
  it('halka: orta metin gizli, değer okunur', () => {
    render(<ProgressRing value={859} max={1800} label="Kalori" valueText="859 / 1.800 kcal"><strong>%48</strong></ProgressRing>);
    expect(screen.getByRole('progressbar', { name: 'Kalori' })).toHaveAttribute('aria-valuetext', '859 / 1.800 kcal');
  });
});

describe('StatCard', () => {
  it('değişim yönü ve anlamı (artış iyi)', () => {
    const { container } = render(<StatCard label="Plana uyum" value={86} unit="%" delta={4} deltaUnit="puan" deltaIntent="increase-is-good" deltaContext="geçen haftaya göre" />);
    expect(container.querySelector('.dy-stat__delta--good')).toHaveTextContent('+4 puan');
  });
  it('düşüş iyi olan metrik', () => {
    const { container } = render(<StatCard label="Onay bekleyen" value={12} delta={-3} deltaIntent="decrease-is-good" />);
    expect(container.querySelector('.dy-stat__delta--good')).toHaveTextContent('−3');
  });
  it('gizli metrikte değişim gösterilmez', () => {
    const { container } = render(<StatCard label="Kilo" value={null} visibility="hidden" delta={-1.2} />);
    expect(container.querySelector('.dy-stat__delta')).toBeNull();
    expect(container).toHaveTextContent('Gizli');
  });
});

type Patient = { id: string; name: string; adherence: number; lastMeal: string };
const patients: Patient[] = [
  { id: '1', name: 'Elif Yıldız', adherence: 86, lastMeal: '12:45' },
  { id: '2', name: 'Batuhan Kaya', adherence: 72, lastMeal: '09:10' },
  { id: '3', name: 'Şule Demir', adherence: 91, lastMeal: '13:20' },
];
const cols: Column<Patient>[] = [
  { key: 'name', header: 'Danışan', sortable: true },
  { key: 'adherence', header: 'Uyum', numeric: true, sortable: true, cell: (r) => `%${r.adherence}` },
  { key: 'lastMeal', header: 'Son öğün', hideOnCompact: true },
];

function TableHarness(props: { onRow?: (p: Patient) => void }) {
  const [sort, setSort] = useState<SortState>(null);
  const [sel, setSel] = useState<Set<string>>(new Set());
  const rows = [...patients].sort((a, b) => !sort ? 0 : (sort.direction === 'ascending' ? 1 : -1) * (sort.key === 'adherence' ? a.adherence - b.adherence : a.name.localeCompare(b.name, 'tr')));
  return <DataTable caption="Danışanlar" columns={cols} rows={rows} rowKey={(r) => r.id} rowLabel={(r) => r.name} sort={sort} onSortChange={setSort} selected={sel} onSelectedChange={setSel} onRowClick={props.onRow} />;
}

describe('DataTable', () => {
  it('caption, sütun başlıkları, aria-sort döngüsü', async () => {
    render(<TableHarness />);
    const table = screen.getByRole('table', { name: 'Danışanlar' });
    const uyum = within(table).getByRole('columnheader', { name: /Uyum/ });
    expect(uyum).toHaveAttribute('aria-sort', 'none');
    await userEvent.click(within(uyum).getByRole('button'));
    expect(uyum).toHaveAttribute('aria-sort', 'ascending');
    expect(within(table).getAllByRole('row')[1]).toHaveTextContent('Batuhan Kaya');
    await userEvent.click(within(uyum).getByRole('button'));
    expect(uyum).toHaveAttribute('aria-sort', 'descending');
    expect(within(table).getAllByRole('row')[1]).toHaveTextContent('Şule Demir');
    await userEvent.click(within(uyum).getByRole('button'));
    expect(uyum).toHaveAttribute('aria-sort', 'none');
  });
  it('satır seçimi ve tümünü seç (karışık durum)', async () => {
    render(<TableHarness />);
    await userEvent.click(screen.getByRole('checkbox', { name: 'Elif Yıldız seç' }));
    expect(screen.getByRole('checkbox', { name: 'Tümünü seç' })).toHaveProperty('indeterminate', true);
    await userEvent.click(screen.getByRole('checkbox', { name: 'Tümünü seç' }));
    expect(screen.getAllByRole('checkbox', { checked: true })).toHaveLength(4);
  });
  it('satır tıklama ilk hücredeki buton ile (klavyeyle erişilebilir)', async () => {
    const fn = vi.fn();
    render(<TableHarness onRow={fn} />);
    await userEvent.click(screen.getByRole('button', { name: 'Şule Demir' }));
    expect(fn).toHaveBeenCalledWith(patients[2]);
  });
  it('yükleniyor, boş ve hata durumları', () => {
    const { rerender, container } = render(<DataTable caption="D" columns={cols} rows={[]} rowKey={(r) => r.id} state="loading" />);
    expect(container.querySelector('.dy-table-wrap')).toHaveAttribute('aria-busy', 'true');
    rerender(<DataTable caption="D" columns={cols} rows={[]} rowKey={(r) => r.id} empty={{ title: 'Danışan yok', description: 'Davet bağlantısı gönder.' }} />);
    expect(screen.getByRole('heading', { name: 'Danışan yok' })).toBeInTheDocument();
    rerender(<DataTable caption="D" columns={cols} rows={[]} rowKey={(r) => r.id} state="error" errorKind="network" onRetry={() => {}} />);
    expect(screen.getByRole('alert')).toHaveTextContent('Bağlantı kurulamadı');
  });
  it('axe', async () => {
    const { container } = render(<TableHarness onRow={() => {}} />);
    await expectNoA11yViolations(container);
  });
});

describe('Pagination ve FilterBar', () => {
  it('sayfa penceresi', () => {
    expect(pageWindow(1, 5)).toEqual([1, 2, 3, 4, 5]);
    expect(pageWindow(6, 12)).toEqual([1, 'gap', 5, 6, 7, 'gap', 12]);
    expect(pageWindow(1, 12)).toEqual([1, 2, 'gap', 12]);
  });
  it('aria-current, önceki/sonraki sınırları', async () => {
    const fn = vi.fn();
    render(<Pagination page={1} pageCount={12} onChange={fn} summary="1–20 / 248 danışan" />);
    expect(screen.getByRole('button', { name: 'Sayfa 1' })).toHaveAttribute('aria-current', 'page');
    expect(screen.getByRole('button', { name: 'Önceki sayfa' })).toBeDisabled();
    await userEvent.click(screen.getByRole('button', { name: 'Sonraki sayfa' }));
    expect(fn).toHaveBeenCalledWith(2);
  });
  it('FilterBar: çip seçimi, temizle, sonuç duyurusu', async () => {
    function H() {
      const [q, setQ] = useState('');
      const [f, setF] = useState<string[]>([]);
      return <FilterBar search={{ label: 'Danışan ara', value: q, onChange: setQ }} filters={{ label: 'Durum', options: [{ value: 'attention', label: 'Dikkat', count: 4 }, { value: 'new', label: 'Yeni' }], value: f, onChange: setF }} onClearAll={() => { setQ(''); setF([]); }} resultText={`${f.length ? 4 : 24} danışan`} />;
    }
    render(<H />);
    expect(screen.getByRole('search')).toBeInTheDocument();
    await userEvent.click(screen.getByRole('button', { name: /Dikkat/ }));
    expect(screen.getByRole('button', { name: /Dikkat/ })).toHaveAttribute('aria-pressed', 'true');
    expect(screen.getByText('4 danışan')).toHaveAttribute('aria-live', 'polite');
    await userEvent.click(screen.getByRole('button', { name: 'Temizle' }));
    expect(screen.getByRole('button', { name: /Dikkat/ })).toHaveAttribute('aria-pressed', 'false');
  });
  it('Chip aria-pressed', () => {
    render(<Chip selected>Tahıl</Chip>);
    expect(screen.getByRole('button', { name: 'Tahıl' })).toHaveAttribute('aria-pressed', 'true');
  });
  it('axe', async () => {
    const { container } = render(<div><Pagination page={6} pageCount={12} onChange={() => {}} /><StatCard label="Uyum" value={86} unit="%" /><Card><CardHeader title="Plan" action={<Button>Düzenle</Button>} /></Card><Card interactive onClick={() => {}} aria-label="Kart">x</Card></div>);
    await expectNoA11yViolations(container);
  });
});
