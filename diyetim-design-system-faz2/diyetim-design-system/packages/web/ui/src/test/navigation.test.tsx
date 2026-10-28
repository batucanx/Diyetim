import { useState } from 'react';
import { render, screen, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Dialog, ConfirmDialog, BottomSheet, Popover, Menu, Tabs, Sidebar, TopBar, Breadcrumb, AppBar, BottomNavigation, Button, TextField, type NavItem } from '..';
import { expectNoA11yViolations } from './a11y';

function DialogHarness({ destructive }: { destructive?: boolean }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>Aç</Button>
      {destructive ? (
        <ConfirmDialog open={open} tone="destructive" title="Randevu iptal edilsin mi?" description="Danışana bildirim gidecek." confirmLabel="İptal et" onConfirm={() => setOpen(false)} onCancel={() => setOpen(false)} />
      ) : (
        <Dialog open={open} onClose={() => setOpen(false)} title="Öğün notu" description="Danışan bu notu görecek." footer={<Button onClick={() => setOpen(false)}>Kaydet</Button>}>
          <TextField label="Not" />
        </Dialog>
      )}
    </>
  );
}

describe('Dialog', () => {
  it('açılınca ilk alana odaklanır, Tab içeride döner, Escape kapatır ve odağı geri verir', async () => {
    render(<DialogHarness />);
    const opener = screen.getByRole('button', { name: 'Aç' });
    await userEvent.click(opener);
    const dialog = screen.getByRole('dialog', { name: 'Öğün notu' });
    expect(dialog).toHaveAttribute('aria-modal', 'true');
    expect(dialog).toHaveAccessibleDescription('Danışan bu notu görecek.');
    const close = within(dialog).getByRole('button', { name: 'Kapat' });
    expect(close).toHaveFocus();
    await userEvent.tab();
    expect(within(dialog).getByLabelText('Not')).toHaveFocus();
    await userEvent.tab();
    await userEvent.tab();
    expect(close).toHaveFocus();
    await userEvent.keyboard('{Shift>}{Tab}{/Shift}');
    expect(within(dialog).getByRole('button', { name: 'Kaydet' })).toHaveFocus();
    await userEvent.keyboard('{Escape}');
    expect(screen.queryByRole('dialog')).toBeNull();
    expect(opener).toHaveFocus();
  });
  it('açıkken arka plan kaydırması kilitli', async () => {
    render(<DialogHarness />);
    await userEvent.click(screen.getByRole('button', { name: 'Aç' }));
    expect(document.body.style.overflow).toBe('hidden');
    await userEvent.keyboard('{Escape}');
    expect(document.body.style.overflow).toBe('');
  });
  it('ConfirmDialog yıkıcı: ilk odak Vazgeç', async () => {
    render(<DialogHarness destructive />);
    await userEvent.click(screen.getByRole('button', { name: 'Aç' }));
    expect(screen.getByRole('button', { name: 'Vazgeç' })).toHaveFocus();
    expect(screen.getByRole('button', { name: 'İptal et' })).toHaveClass('dy-button--destructive');
  });
  it('ConfirmDialog pending: kapatılamaz, onay loading', async () => {
    const cancel = vi.fn();
    render(<ConfirmDialog open pending title="Siliniyor" description="Bekleyin" confirmLabel="Sil" onConfirm={() => {}} onCancel={cancel} />);
    await userEvent.keyboard('{Escape}');
    expect(cancel).not.toHaveBeenCalled();
    expect(screen.getByRole('button', { name: 'Sil' })).toHaveAttribute('aria-busy', 'true');
  });
  it('BottomSheet sayfa sınıfı', () => {
    render(<BottomSheet open onClose={() => {}} title="Filtreler">x</BottomSheet>);
    expect(screen.getByRole('dialog', { name: 'Filtreler' })).toHaveClass('dy-dialog--sheet');
  });
  it('axe', async () => {
    render(<Dialog open onClose={() => {}} title="Başlık" description="Açıklama"><p>İçerik</p></Dialog>);
    await expectNoA11yViolations(document.body);
  });
});

describe('Popover ve Menu', () => {
  it('Popover: açılır, içeriğe odaklanır, Escape kapatır ve odağı geri verir', async () => {
    render(<Popover label="Filtre" trigger={<Button variant="tertiary">Filtrele</Button>}><TextField label="Ara" /></Popover>);
    const trig = screen.getByRole('button', { name: 'Filtrele' });
    await userEvent.click(trig);
    expect(trig).toHaveAttribute('aria-expanded', 'true');
    await vi.waitFor(() => expect(screen.getByLabelText('Ara')).toHaveFocus());
    await userEvent.keyboard('{Escape}');
    expect(screen.queryByRole('dialog')).toBeNull();
    expect(trig).toHaveFocus();
  });
  it('Menu: oklarla gezilir, devre dışı atlanır, Enter seçer', async () => {
    const edit = vi.fn(), del = vi.fn();
    render(<Menu label="Öğün eylemleri" trigger={<Button variant="ghost">Eylemler</Button>} items={[
      { id: 'e', label: 'Düzenle', icon: 'note', onSelect: edit },
      { id: 'd', label: 'Kopyala', disabled: true, onSelect: () => {} },
      { id: 'x', label: 'Sil', icon: 'x', destructive: true, onSelect: del },
    ]} />);
    const trig = screen.getByRole('button', { name: 'Eylemler' });
    trig.focus();
    await userEvent.keyboard('{ArrowDown}');
    const menu = await screen.findByRole('menu', { name: 'Öğün eylemleri' });
    await vi.waitFor(() => expect(menu).toHaveFocus());
    await userEvent.keyboard('{ArrowDown}{Enter}');
    expect(del).toHaveBeenCalledOnce();
    expect(edit).not.toHaveBeenCalled();
    expect(trig).toHaveFocus();
  });
});

describe('Tabs', () => {
  const items = [
    { value: 'ozet', label: 'Özet', content: <p>Özet içerik</p> },
    { value: 'gunluk', label: 'Günlük', content: <p>Günlük içerik</p>, count: 3, countLabel: '3 öğün onay bekliyor' },
    { value: 'plan', label: 'Plan', content: <p>Plan içerik</p>, disabled: true },
    { value: 'tahlil', label: 'Tahliller', content: <p>Tahlil içerik</p> },
  ];
  it('ok tuşlarıyla otomatik etkinleşir, devre dışı atlanır, panel bağlı', async () => {
    const fn = vi.fn();
    render(<Tabs label="Danışan" items={items} onChange={fn} />);
    expect(screen.getByRole('tablist', { name: 'Danışan' })).toBeInTheDocument();
    await userEvent.tab();
    expect(screen.getByRole('tab', { name: 'Özet' })).toHaveFocus();
    await userEvent.keyboard('{ArrowRight}');
    expect(fn).toHaveBeenLastCalledWith('gunluk');
    expect(screen.getByRole('tabpanel')).toHaveTextContent('Günlük içerik');
    await userEvent.keyboard('{ArrowRight}');
    expect(fn).toHaveBeenLastCalledWith('tahlil');
    await userEvent.keyboard('{Home}');
    expect(screen.getByRole('tab', { name: 'Özet' })).toHaveAttribute('aria-selected', 'true');
    expect(screen.getByRole('tabpanel', { name: 'Özet' })).toBeInTheDocument();
  });
  it('axe', async () => {
    const { container } = render(<Tabs label="Danışan" items={items} />);
    await expectNoA11yViolations(container);
  });
});

describe('Sidebar, TopBar, Breadcrumb, AppBar, BottomNavigation', () => {
  const nav: NavItem[] = [
    { id: 'queue', label: 'Onay kuyruğu', icon: 'checkCircle', badge: 12, badgeLabel: '12 öğün onay bekliyor' },
    { id: 'patients', label: 'Danışanlar', icon: 'users' },
    { id: 'calendar', label: 'Takvim', icon: 'calendar' },
    { id: 'settings', label: 'Ayarlar', icon: 'settings' },
  ];
  it('Sidebar: nav landmark, aria-current, istemci yönlendirmesi', async () => {
    const go = vi.fn();
    render(<Sidebar items={nav} activeId="patients" onNavigate={go} header={<strong>Diyetim Klinik</strong>} />);
    expect(screen.getByRole('navigation', { name: 'Ana gezinme' })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: 'Danışanlar' })).toHaveAttribute('aria-current', 'page');
    await userEvent.click(screen.getByRole('link', { name: /Takvim/ }));
    expect(go).toHaveBeenCalledWith('calendar', expect.anything());
  });
  it('Sidebar collapsed: ikon bağlantılarının erişilebilir adı korunur', () => {
    render(<Sidebar items={nav} activeId="queue" collapsed />);
    expect(screen.getByRole('link', { name: 'Ayarlar' })).toBeInTheDocument();
  });
  it('TopBar + Breadcrumb', () => {
    render(<TopBar title="Elif Yıldız" breadcrumb={<Breadcrumb items={[{ label: 'Danışanlar', href: '/d' }, { label: 'Elif Yıldız' }]} />} actions={<Button size="sm">Plan oluştur</Button>} />);
    expect(screen.getByRole('heading', { level: 1, name: 'Elif Yıldız' })).toBeInTheDocument();
    expect(screen.getByRole('navigation', { name: 'Konum' })).toBeInTheDocument();
    expect(screen.getAllByText('Elif Yıldız').find((e) => e.getAttribute('aria-current') === 'page')).toBeTruthy();
  });
  it('AppBar geri butonu', async () => {
    const back = vi.fn();
    render(<AppBar title="Öğün detayı" onBack={back} />);
    await userEvent.click(screen.getByRole('button', { name: 'Geri' }));
    expect(back).toHaveBeenCalledOnce();
  });
  it('BottomNavigation: orta eylem ve rozet', async () => {
    const cta = vi.fn();
    render(<BottomNavigation items={nav} activeId="queue" centerAction={{ icon: 'camera', label: 'Hızlı onay', onClick: cta }} />);
    await userEvent.click(screen.getByRole('button', { name: 'Hızlı onay' }));
    expect(cta).toHaveBeenCalledOnce();
    expect(screen.getByRole('status', { name: '12 öğün onay bekliyor' })).toBeInTheDocument();
  });
  it('axe', async () => {
    const { container } = render(
      <div>
        <Sidebar items={nav} activeId="queue" />
        <main><TopBar title="Onay kuyruğu" /><AppBar title="Kuyruk" onMenu={() => {}} /></main>
        <BottomNavigation items={nav} activeId="queue" label="Alt gezinme" />
      </div>,
    );
    await expectNoA11yViolations(container);
  });
});
