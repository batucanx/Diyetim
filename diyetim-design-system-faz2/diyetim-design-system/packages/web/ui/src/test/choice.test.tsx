import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Checkbox, RadioGroup, Switch, SegmentedControl } from '..';
import { expectNoA11yViolations } from './a11y';

describe('Checkbox', () => {
  it('tıklama ve Space ile değişir', async () => {
    const fn = vi.fn();
    render(<Checkbox label="Hatırlatma al" onChange={fn} />);
    const cb = screen.getByRole('checkbox', { name: 'Hatırlatma al' });
    await userEvent.click(cb);
    expect(cb).toBeChecked();
    await userEvent.keyboard(' ');
    expect(cb).not.toBeChecked();
    expect(fn).toHaveBeenCalledTimes(2);
  });
  it('indeterminate', () => {
    render(<Checkbox label="Tümü" indeterminate />);
    expect((screen.getByRole('checkbox') as HTMLInputElement).indeterminate).toBe(true);
  });
  it('locked değişmez, nedeni okunur', async () => {
    const fn = vi.fn();
    render(<Checkbox label="Fotoğraf zorunlu" defaultChecked state="locked" lockedReason="Klinik ayarı" onChange={fn} />);
    const cb = screen.getByRole('checkbox');
    await userEvent.click(cb);
    expect(cb).toBeChecked();
    expect(fn).not.toHaveBeenCalled();
    expect(cb).toHaveAccessibleDescription('Klinik ayarı');
  });
  it('hata', () => {
    render(<Checkbox label="Koşulları kabul ediyorum" error="Devam etmek için onaylayın." />);
    expect(screen.getByRole('checkbox')).toHaveAttribute('aria-invalid', 'true');
  });
});

describe('RadioGroup', () => {
  const opts = [{ value: 'online', label: 'Online (15 dk)' }, { value: 'clinic', label: 'Yüz yüze' }, { value: 'phone', label: 'Telefon', disabled: true }] as const;
  it('legend grup adı; tıklama seçer', async () => {
    const fn = vi.fn();
    render(<RadioGroup label="Görüşme tipi" options={opts} onChange={fn} />);
    expect(screen.getByRole('group', { name: 'Görüşme tipi' })).toBeInTheDocument();
    await userEvent.click(screen.getByRole('radio', { name: 'Yüz yüze' }));
    expect(fn).toHaveBeenCalledWith('clinic');
    expect(screen.getByRole('radio', { name: 'Telefon' })).toBeDisabled();
  });
  it('locked değişmez', async () => {
    const fn = vi.fn();
    render(<RadioGroup label="Görüşme tipi" options={opts} defaultValue="online" state="locked" lockedReason="Randevu onaylandı" onChange={fn} />);
    await userEvent.click(screen.getByRole('radio', { name: 'Yüz yüze' }));
    expect(fn).not.toHaveBeenCalled();
    expect(screen.getByRole('radio', { name: 'Online (15 dk)' })).toBeChecked();
  });
});

describe('Switch', () => {
  it('role=switch, aria-checked değişir', async () => {
    const fn = vi.fn();
    render(<Switch label="Kalori değerleri" description="Kapalıyken halka rakamsız" onChange={fn} />);
    const sw = screen.getByRole('switch', { name: 'Kalori değerleri' });
    expect(sw).toHaveAttribute('aria-checked', 'false');
    expect(sw).toHaveAccessibleDescription('Kapalıyken halka rakamsız');
    await userEvent.click(sw);
    expect(sw).toHaveAttribute('aria-checked', 'true');
    await userEvent.keyboard(' ');
    expect(fn).toHaveBeenLastCalledWith(false);
  });
  it('locked ve loading değişmez', async () => {
    const fn = vi.fn();
    render(<><Switch label="A" state="locked" lockedReason="Kapalı" onChange={fn} /><Switch label="B" state="loading" onChange={fn} /></>);
    await userEvent.click(screen.getByRole('switch', { name: 'A' }));
    await userEvent.click(screen.getByRole('switch', { name: 'B' }));
    expect(fn).not.toHaveBeenCalled();
    expect(screen.getByRole('switch', { name: 'B' })).toHaveAttribute('aria-busy', 'true');
  });
});

describe('SegmentedControl', () => {
  const opts = [{ value: 'day', label: 'Gün' }, { value: 'week', label: 'Hafta' }, { value: 'month', label: 'Ay' }] as const;
  it('radiogroup; roving tabindex; ok tuşları seçer ve sarar', async () => {
    const fn = vi.fn();
    render(<SegmentedControl label="Dönem" options={opts} onChange={fn} />);
    expect(screen.getByRole('radiogroup', { name: 'Dönem' })).toBeInTheDocument();
    const [day, week, month] = screen.getAllByRole('radio');
    expect(day).toHaveAttribute('tabindex', '0');
    expect(week).toHaveAttribute('tabindex', '-1');
    await userEvent.tab();
    expect(day).toHaveFocus();
    await userEvent.keyboard('{ArrowRight}');
    expect(fn).toHaveBeenLastCalledWith('week');
    expect(week).toHaveFocus();
    await userEvent.keyboard('{End}');
    expect(month).toHaveAttribute('aria-checked', 'true');
    await userEvent.keyboard('{ArrowRight}');
    expect(fn).toHaveBeenLastCalledWith('day');
  });
  it('devre dışı', () => {
    render(<SegmentedControl label="Dönem" options={opts} state="disabled" />);
    screen.getAllByRole('radio').forEach((r) => expect(r).toBeDisabled());
  });
});

describe('seçim kontrolleri axe', () => {
  it('ihlal yok', async () => {
    const { container } = render(
      <div>
        <Checkbox label="A" description="Açıklama" /><Checkbox label="B" state="locked" lockedReason="Kapalı" />
        <RadioGroup label="Tip" options={[{ value: 'a', label: 'A' }, { value: 'b', label: 'B' }]} defaultValue="a" />
        <Switch label="Bildirim" /><SegmentedControl label="Dönem" options={[{ value: 'd', label: 'Gün' }, { value: 'w', label: 'Hafta' }]} />
      </div>,
    );
    await expectNoA11yViolations(container);
  });
});
