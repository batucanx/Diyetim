import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Text, NumberDisplay, Icon, Surface, Stack, Gap, Skeleton, Pressable, ThemeProvider } from '..';
import { expectNoA11yViolations } from './a11y';

describe('Text', () => {
  it('varyanta uygun semantik öğe seçer', () => {
    render(<><Text variant="h1">Başlık</Text><Text>Gövde</Text><Text variant="caption">Not</Text></>);
    expect(screen.getByRole('heading', { level: 1, name: 'Başlık' })).toHaveClass('dy-text--h1', 'dy-tone--primary');
    expect(screen.getByText('Gövde').tagName).toBe('P');
    expect(screen.getByText('Not').tagName).toBe('SPAN');
  });
  it('maxLines satır sınırı ve tam metni title ile korur', () => {
    const long = 'Çok uzun bir Türkçe açıklama metni; ğüşıöç İİ harfleriyle birlikte kırpılmadan okunabilmeli.';
    render(<Text maxLines={2}>{long}</Text>);
    const el = screen.getByText(long);
    expect(el).toHaveClass('dy-text--clamp');
    expect(el).toHaveAttribute('title', long);
    expect(el.style.webkitLineClamp).toBe('2');
  });
  it('as ile öğe değiştirilebilir, tone sınıfı uygulanır', () => {
    render(<Text as="label" variant="label" tone="muted">Etiket</Text>);
    expect(screen.getByText('Etiket').tagName).toBe('LABEL');
    expect(screen.getByText('Etiket')).toHaveClass('dy-tone--muted');
  });
});

describe('NumberDisplay', () => {
  it('Türkçe biçim ve bölünmez boşluklu birim', () => {
    const { container } = render(<NumberDisplay value={1842} unit="kcal" />);
    expect(container.textContent).toBe('1.842 kcal');
  });
  it('ondalık virgül', () => {
    const { container } = render(<NumberDisplay value={68.42} unit="kg" />);
    expect(container.textContent).toBe('68,4 kg');
  });
  it('yüzde', () => {
    const { container } = render(<NumberDisplay value={0.48} format="percent" />);
    expect(container.textContent).toBe('%48');
  });
  it('gizli metrik değeri göstermez, "Gizli" der', () => {
    const { container } = render(<NumberDisplay value={null} visibility="hidden" label="Kilo" />);
    expect(container.textContent).toContain('Gizli');
    expect(container.textContent).toContain('Kilo');
    expect(container.querySelector('.dy-num--hidden')).not.toBeNull();
  });
  it('null değer: görsel tire, ekran okuyucuya "değer yok"', () => {
    render(<NumberDisplay value={null} unit="mg/dL" />);
    expect(screen.getByText('—')).toHaveAttribute('aria-hidden', 'true');
    expect(screen.getByText('değer yok')).toHaveClass('dy-visually-hidden');
  });
  it('erişilebilir bağlam etiketi değerden önce okunur', () => {
    const { container } = render(<NumberDisplay value={941} unit="kcal" label="Kalan kalori" variant="numeric-xl" />);
    expect(container.textContent).toBe('Kalan kalori: 941 kcal');
    expect(container.firstChild).toHaveClass('dy-text--numeric-xl', 'dy-num');
  });
});

describe('Icon', () => {
  it('etiketsiz ikon dekoratiftir', () => {
    const { container } = render(<Icon name="search" />);
    expect(container.querySelector('svg')).toHaveAttribute('aria-hidden', 'true');
  });
  it('etiketli ikon role=img ve ad taşır', () => {
    render(<Icon name="lock" label="Kilitli" size="lg" />);
    expect(screen.getByRole('img', { name: 'Kilitli' })).toHaveClass('dy-icon--lg');
  });
});

describe('Surface, Stack, Gap', () => {
  it('Surface katman, derinlik, radius ve padding token sınıflarını uygular', () => {
    render(<Surface data-testid="s" level="elevated" elevation="low" radius="xl" padding="2xl" />);
    const s = screen.getByTestId('s');
    expect(s).toHaveClass('dy-surface--elevated', 'dy-elevation--low', 'dy-radius--xl', 'dy-surface--bordered');
    expect(s.style.padding).toBe('var(--spacing-2xl)');
  });
  it('Stack gap token değişkeniyle', () => {
    render(<Stack data-testid="st" direction="horizontal" gap="sm" wrap align="center" />);
    const st = screen.getByTestId('st');
    expect(st.style.gap).toBe('var(--spacing-sm)');
    expect(st).toHaveClass('dy-stack--horizontal', 'dy-stack--wrap', 'dy-align--center');
  });
  it('Gap dekoratif boşluk', () => {
    const { container } = render(<Gap size="xl" />);
    expect(container.firstChild).toHaveAttribute('aria-hidden', 'true');
    expect((container.firstChild as HTMLElement).style.height).toBe('var(--spacing-xl)');
  });
});

describe('Skeleton', () => {
  it('ekran okuyucudan gizli; text satır sayısı ve kısa son satır', () => {
    const { container } = render(<Skeleton shape="text" lines={3} />);
    const lines = container.querySelectorAll('.dy-skeleton--text');
    expect(container.firstChild).toHaveAttribute('aria-hidden', 'true');
    expect(lines).toHaveLength(3);
    expect((lines[2] as HTMLElement).style.width).toBe('60%');
  });
  it('circle ve rect ölçüleri', () => {
    const { container } = render(<Skeleton shape="circle" width="var(--size-control-lg)" height="var(--size-control-lg)" />);
    expect(container.firstChild).toHaveClass('dy-skeleton--circle');
  });
});

describe('Pressable durumları', () => {
  it('enabled: tıklama çalışır', async () => {
    const fn = vi.fn();
    render(<Pressable onClick={fn}>Bas</Pressable>);
    await userEvent.click(screen.getByRole('button', { name: 'Bas' }));
    expect(fn).toHaveBeenCalledOnce();
  });
  it('disabled: odaklanamaz, tetiklenmez', async () => {
    const fn = vi.fn();
    render(<Pressable state="disabled" onClick={fn}>Bas</Pressable>);
    const b = screen.getByRole('button');
    expect(b).toBeDisabled();
    await userEvent.click(b);
    expect(fn).not.toHaveBeenCalled();
  });
  it('locked: odaklanabilir, tetiklenmez, nedeni ekran okuyucuya bağlı', async () => {
    const fn = vi.fn();
    render(<Pressable state="locked" lockedReason="Diyetisyenin kapattı" onClick={fn}>Bas</Pressable>);
    const b = screen.getByRole('button', { name: /Bas/ });
    expect(b).not.toBeDisabled();
    expect(b).toHaveAttribute('aria-disabled', 'true');
    expect(b).toHaveAccessibleDescription('Diyetisyenin kapattı');
    await userEvent.tab();
    expect(b).toHaveFocus();
    await userEvent.keyboard('{Enter}');
    expect(fn).not.toHaveBeenCalled();
  });
  it('loading: aria-busy, tetiklenmez', async () => {
    const fn = vi.fn();
    render(<Pressable state="loading" onClick={fn}>Kaydet</Pressable>);
    const b = screen.getByRole('button', { name: 'Kaydet' });
    expect(b).toHaveAttribute('aria-busy', 'true');
    await userEvent.click(b);
    expect(fn).not.toHaveBeenCalled();
  });
});

describe('ThemeProvider', () => {
  it('data-theme ve data-density sarmalayıcıya yazılır', () => {
    const { container } = render(<ThemeProvider mode="dark" density="compact"><span>x</span></ThemeProvider>);
    expect(container.firstChild).toHaveAttribute('data-theme', 'dark');
    expect(container.firstChild).toHaveAttribute('data-density', 'compact');
  });
  it('system modunda data-theme yazılmaz (prefers-color-scheme devreye girer)', () => {
    const { container } = render(<ThemeProvider><span>x</span></ThemeProvider>);
    expect(container.firstChild).not.toHaveAttribute('data-theme');
  });
});

describe('primitive erişilebilirliği (axe)', () => {
  it('ihlal yok', async () => {
    const { container } = render(
      <main>
        <Text variant="h1">Bugün</Text>
        <NumberDisplay value={941} unit="kcal" label="Kalan kalori" />
        <Icon name="lock" label="Kilitli" />
        <Surface padding="xl"><Stack><Skeleton shape="text" lines={2} /></Stack></Surface>
        <Pressable state="locked" lockedReason="Neden">Eylem</Pressable>
      </main>,
    );
    await expectNoA11yViolations(container);
  });
});
