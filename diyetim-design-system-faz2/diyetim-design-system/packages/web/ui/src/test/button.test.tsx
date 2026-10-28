import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Button, IconButton, Fab } from '..';
import { ButtonVariant } from '@diyetim/tokens';
import { expectNoA11yViolations } from './a11y';

describe('Button', () => {
  it.each(ButtonVariant)('%s varyantı sınıf ve etiketle render edilir', (variant) => {
    render(<Button variant={variant}>Öğünü kaydet</Button>);
    expect(screen.getByRole('button', { name: 'Öğünü kaydet' })).toHaveClass(`dy-button--${variant}`);
  });
  it('Enter ve Space ile tetiklenir', async () => {
    const fn = vi.fn();
    render(<Button onClick={fn}>Onayla</Button>);
    await userEvent.tab();
    await userEvent.keyboard('{Enter}');
    await userEvent.keyboard(' ');
    expect(fn).toHaveBeenCalledTimes(2);
  });
  it('disabled tetiklenmez ve odak sırasından çıkar', async () => {
    const fn = vi.fn();
    render(<><Button state="disabled" onClick={fn}>A</Button><Button>B</Button></>);
    await userEvent.tab();
    expect(screen.getByRole('button', { name: 'B' })).toHaveFocus();
    await userEvent.click(screen.getByRole('button', { name: 'A' }));
    expect(fn).not.toHaveBeenCalled();
  });
  it('locked: kilit ikonu, aria-disabled, neden açıklaması; tetiklenmez', async () => {
    const fn = vi.fn();
    render(<Button state="locked" lockedReason="Plan dışı ekleme kapalı" onClick={fn}>Besin ekle</Button>);
    const b = screen.getByRole('button', { name: /Besin ekle/ });
    expect(b).toHaveAttribute('aria-disabled', 'true');
    expect(b).toHaveAccessibleDescription('Plan dışı ekleme kapalı');
    expect(b.querySelector('[data-icon="lock"]')).not.toBeNull();
    await userEvent.click(b);
    expect(fn).not.toHaveBeenCalled();
  });
  it('loading: etiket erişilebilir ad olarak kalır, aria-busy, tetiklenmez, ilerleme çizgisi var', async () => {
    const fn = vi.fn();
    render(<Button state="loading" onClick={fn}>Kaydediliyor</Button>);
    const b = screen.getByRole('button', { name: 'Kaydediliyor' });
    expect(b).toHaveAttribute('aria-busy', 'true');
    expect(b.querySelector('.dy-button__progress')).not.toBeNull();
    await userEvent.click(b);
    expect(fn).not.toHaveBeenCalled();
  });
  it('loading ve locked aynı anda olamaz (tek state alanı)', () => {
    // @ts-expect-error state tek değer alır; dizi veya birleşik durum kabul edilmez
    render(<Button state={['loading', 'locked']}>X</Button>);
  });
  it('uzun Türkçe etiket kesilmez', () => {
    const label = 'Diyetisyenime bugünkü tüm öğünlerimi onay için gönder ve bildirim aç';
    render(<Button fullWidth>{label}</Button>);
    expect(screen.getByRole('button', { name: label })).toHaveClass('dy-button--block');
  });
});

describe('IconButton ve Fab', () => {
  it('IconButton erişilebilir ad taşır', async () => {
    const fn = vi.fn();
    render(<IconButton icon="bell" label="Bildirimler" onClick={fn} />);
    await userEvent.click(screen.getByRole('button', { name: 'Bildirimler' }));
    expect(fn).toHaveBeenCalledOnce();
  });
  it('Fab erişilebilir ad taşır', () => {
    render(<Fab icon="plus" label="Öğün ekle" />);
    expect(screen.getByRole('button', { name: 'Öğün ekle' })).toHaveClass('dy-fab');
  });
  it('axe ihlali yok', async () => {
    const { container } = render(
      <div>
        <Button>Kaydet</Button><Button variant="secondary" iconStart="plus">Ekle</Button>
        <Button state="locked" lockedReason="Kapalı">Kilitli</Button><Button state="loading">Yükleniyor</Button>
        <IconButton icon="x" label="Kapat" /><Fab icon="camera" label="Fotoğraf çek" />
      </div>,
    );
    await expectNoA11yViolations(container);
  });
});
