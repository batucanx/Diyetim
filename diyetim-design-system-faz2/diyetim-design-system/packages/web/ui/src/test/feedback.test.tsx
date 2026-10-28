import { act, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { MealStatus, AppointmentStatus, LabValueStatus, DataSource, ErrorKind } from '@diyetim/tokens';
import {
  Tag, StatusTag, SourceTag, Badge, Tooltip, Alert, Banner, ToastProvider, useToast, EmptyState, ErrorState, OfflineState,
  LoadingRegion, Button, StringsProvider, Skeleton,
} from '..';
import { expectNoA11yViolations } from './a11y';

describe('Tag, StatusTag, SourceTag, Badge', () => {
  it('Tag ton sınıfı ve ikon', () => {
    const { container } = render(<Tag tone="warning" icon="clock">Onay bekliyor</Tag>);
    expect(container.firstChild).toHaveClass('dy-tag--warning');
    expect(container.querySelector('[data-icon="clock"]')).not.toBeNull();
  });
  it.each(MealStatus)('öğün durumu %s ortak sözleşmeden metin alır', (s) => {
    const { container } = render(<StatusTag kind="meal" status={s} />);
    expect(container.textContent?.length).toBeGreaterThan(2);
  });
  it('randevu ve tahlil durumlarının tamamı', () => {
    render(<>{AppointmentStatus.map((s) => <StatusTag key={s} kind="appointment" status={s} />)}{LabValueStatus.map((s) => <StatusTag key={s} kind="lab" status={s} />)}</>);
    expect(screen.getByText('Gelmedi')).toBeInTheDocument();
    expect(screen.getByText('Okunamadı')).toBeInTheDocument();
  });
  it('SourceTag dört kaynak', () => {
    render(<>{DataSource.map((s) => <SourceTag key={s} source={s} />)}</>);
    ['Sen girdin', 'Diyetisyen', 'AI tahmini', 'Onaylı'].forEach((t) => expect(screen.getByText(t)).toBeInTheDocument());
  });
  it('Badge: 0 iken gizli, sınır üstü "99+", erişilebilir ad', () => {
    const { rerender, container } = render(<Badge count={0} label="0 bildirim" />);
    expect(container.firstChild).toBeNull();
    rerender(<Badge count={150} label="150 okunmamış bildirim" />);
    expect(screen.getByRole('status', { name: '150 okunmamış bildirim' })).toHaveTextContent('99+');
  });
  it('çeviri katmanı varsayılanı geçersiz kılar', () => {
    render(<StringsProvider strings={{ 'mealStatus.approved': 'Approved' }}><StatusTag kind="meal" status="approved" /></StringsProvider>);
    expect(screen.getByText('Approved')).toBeInTheDocument();
  });
});

describe('Tooltip', () => {
  it('odakta görünür, Escape kapatır, aria-describedby bağlı', async () => {
    render(<Tooltip content="Öğün fotoğrafı çek"><Button variant="ghost">Kamera</Button></Tooltip>);
    const btn = screen.getByRole('button', { name: 'Kamera' });
    expect(screen.getByRole('tooltip', { hidden: true })).not.toBeVisible();
    await userEvent.tab();
    expect(btn).toHaveFocus();
    expect(screen.getByRole('tooltip')).toBeVisible();
    expect(btn).toHaveAccessibleDescription('Öğün fotoğrafı çek');
    await userEvent.keyboard('{Escape}');
    expect(screen.getByRole('tooltip', { hidden: true })).not.toBeVisible();
  });
});

describe('Alert ve Banner', () => {
  it('error ve warning hemen duyurulur (alert), info status', () => {
    render(<><Alert tone="error" title="Kaydedilemedi">Tekrar dene.</Alert><Alert tone="info" title="Plan güncellendi" /></>);
    expect(screen.getByRole('alert')).toHaveTextContent('Kaydedilemedi');
    expect(screen.getByRole('status')).toHaveTextContent('Plan güncellendi');
  });
  it('kapatılabilir', async () => {
    const fn = vi.fn();
    render(<Banner tone="success" title="Eşitlendi" onDismiss={fn} />);
    await userEvent.click(screen.getByRole('button', { name: 'Kapat' }));
    expect(fn).toHaveBeenCalledOnce();
  });
});

describe('Toast ve Snackbar', () => {
  beforeEach(() => vi.useFakeTimers({ shouldAdvanceTime: true }));
  afterEach(() => vi.useRealTimers());

  function Trigger({ withAction }: { withAction?: () => void }) {
    const toast = useToast();
    return <button onClick={() => toast({ message: 'Öğle öğünü kaydedildi', action: withAction ? { label: 'Geri al', onAction: withAction } : undefined })}>Göster</button>;
  }

  it('canlı bölgede gösterilir ve 4 sn sonra kapanır', async () => {
    render(<ToastProvider><Trigger /></ToastProvider>);
    await userEvent.click(screen.getByText('Göster'));
    expect(screen.getByRole('region', { name: 'Bildirimler' })).toHaveAttribute('aria-live', 'polite');
    expect(screen.getByRole('status')).toHaveTextContent('Öğle öğünü kaydedildi');
    act(() => { vi.advanceTimersByTime(4100); });
    expect(screen.queryByText('Öğle öğünü kaydedildi')).toBeNull();
  });
  it('Snackbar: Geri al eylemi çağrılır; fare üzerindeyken süre durur', async () => {
    const undo = vi.fn();
    render(<ToastProvider><Trigger withAction={undo} /></ToastProvider>);
    await userEvent.click(screen.getByText('Göster'));
    await userEvent.hover(screen.getByRole('status'));
    act(() => { vi.advanceTimersByTime(10000); });
    expect(screen.getByRole('status')).toBeInTheDocument();
    await userEvent.click(screen.getByRole('button', { name: /Geri al/ }));
    expect(undo).toHaveBeenCalledOnce();
    expect(screen.queryByRole('status')).toBeNull();
  });
  it('kuyruk: ikinci bildirim birincisi kapanınca gelir', async () => {
    function Two() { const toast = useToast(); return <button onClick={() => { toast({ message: 'Bir' }); toast({ message: 'İki' }); }}>İki tane</button>; }
    render(<ToastProvider><Two /></ToastProvider>);
    await userEvent.click(screen.getByText('İki tane'));
    expect(screen.getByRole('status')).toHaveTextContent('Bir');
    await userEvent.click(screen.getByRole('button', { name: 'Kapat' }));
    expect(screen.getByRole('status')).toHaveTextContent('İki');
  });
  it('provider olmadan anlaşılır hata', () => {
    const spy = vi.spyOn(console, 'error').mockImplementation(() => {});
    expect(() => render(<Trigger />)).toThrow(/ToastProvider/);
    spy.mockRestore();
  });
});

describe('EmptyState, ErrorState, OfflineState, LoadingRegion', () => {
  it('EmptyState: ne oldu, neden, ne yapılabilir', () => {
    render(<EmptyState title="Bugün için öğün yok" description="Diyetisyenin henüz plan yayınlamadı." action={<Button>Besin ara</Button>} />);
    expect(screen.getByRole('heading', { level: 2, name: 'Bugün için öğün yok' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Besin ara' })).toBeInTheDocument();
  });
  it.each(ErrorKind)('ErrorState %s varsayılan metin ve eylemle', async (kind) => {
    const fn = vi.fn();
    render(<ErrorState kind={kind} onAction={fn} />);
    const region = screen.getByRole('alert');
    expect(region.querySelector('h2')?.textContent?.length).toBeGreaterThan(3);
    await userEvent.click(screen.getByRole('button'));
    expect(fn).toHaveBeenCalledOnce();
  });
  it('ErrorState tekrar denerken buton loading', () => {
    render(<ErrorState kind="network" onAction={() => {}} retrying />);
    expect(screen.getByRole('button')).toHaveAttribute('aria-busy', 'true');
  });
  it('OfflineState bekleyen değişiklik sayısını söyler', () => {
    render(<OfflineState pendingCount={3} onRetry={() => {}} />);
    expect(screen.getByRole('alert')).toHaveTextContent('3 değişiklik gönderilmeyi bekliyor');
  });
  it('LoadingRegion aria-busy ve iskelet; bitince içerik', () => {
    const { rerender } = render(<LoadingRegion loading label="Öğünler" skeleton={<Skeleton shape="text" lines={2} />}><p>İçerik</p></LoadingRegion>);
    expect(screen.getByRole('region', { name: 'Öğünler' })).toHaveAttribute('aria-busy', 'true');
    expect(screen.getByText('Öğünler: Yükleniyor')).toBeInTheDocument();
    rerender(<LoadingRegion loading={false} label="Öğünler" skeleton={<Skeleton />}><p>İçerik</p></LoadingRegion>);
    expect(screen.getByText('İçerik')).toBeInTheDocument();
    expect(screen.getByRole('region')).toHaveAttribute('aria-busy', 'false');
  });
  it('axe ihlali yok', async () => {
    const { container } = render(
      <main>
        <Tag tone="success" icon="check">Onaylandı</Tag><SourceTag source="ai" /><Badge count={3} label="3 bildirim" />
        <Alert tone="warning" title="Plan değişti" actions={<Button size="sm" variant="tertiary">Gör</Button>} onDismiss={() => {}} />
        <EmptyState title="Boş" description="Açıklama" /><ErrorState kind="server" onAction={() => {}} headingLevel={3} />
        <OfflineState pendingCount={2} />
      </main>,
    );
    await expectNoA11yViolations(container);
  });
});
