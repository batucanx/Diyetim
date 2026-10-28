import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Select, MultiSelect, type SelectOption } from '..';
import { expectNoA11yViolations } from './a11y';

const meals: SelectOption<'breakfast' | 'lunch' | 'dinner' | 'snack'>[] = [
  { value: 'breakfast', label: 'Kahvaltı' },
  { value: 'lunch', label: 'Öğle yemeği' },
  { value: 'dinner', label: 'Akşam yemeği', disabled: true },
  { value: 'snack', label: 'Ara öğün', description: 'İkindi veya gece' },
];
const foods: SelectOption[] = [
  { value: 'sut', label: 'Süt ürünleri' }, { value: 'seker', label: 'Şekerli gıdalar' }, { value: 'sebze', label: 'Sebze' }, { value: 'ispanak', label: 'Ispanak' }, { value: 'incir', label: 'İncir' },
];

describe('Select', () => {
  it('combobox: klavyeyle açılır, oklarla gezilir, Enter seçer ve kapanır', async () => {
    const fn = vi.fn();
    render(<Select label="Öğün tipi" options={meals} onChange={fn} />);
    const cb = screen.getByRole('combobox', { name: /Öğün tipi/ });
    expect(cb).toHaveAttribute('aria-expanded', 'false');
    cb.focus();
    await userEvent.keyboard('{ArrowDown}');
    expect(cb).toHaveAttribute('aria-expanded', 'true');
    expect(screen.getByRole('listbox')).toBeInTheDocument();
    await userEvent.keyboard('{ArrowDown}{Enter}');
    expect(fn).toHaveBeenCalledWith('lunch');
    expect(cb).toHaveAttribute('aria-expanded', 'false');
    expect(cb).toHaveTextContent('Öğle yemeği');
  });
  it('devre dışı seçeneği atlar; End son etkin seçeneğe gider', async () => {
    const fn = vi.fn();
    render(<Select label="Öğün" options={meals} defaultValue="lunch" onChange={fn} />);
    screen.getByRole('combobox').focus();
    await userEvent.keyboard('{ArrowDown}{ArrowDown}');
    const cb = screen.getByRole('combobox');
    expect(cb.getAttribute('aria-activedescendant')).toMatch(/-opt-3$/);
    await userEvent.keyboard('{Home}{End}{Enter}');
    expect(fn).toHaveBeenLastCalledWith('snack');
  });
  it('Escape kapatır, seçim değişmez', async () => {
    const fn = vi.fn();
    render(<Select label="Öğün" options={meals} onChange={fn} />);
    await userEvent.click(screen.getByRole('combobox'));
    await userEvent.keyboard('{Escape}');
    expect(screen.queryByRole('listbox')).toBeNull();
    expect(fn).not.toHaveBeenCalled();
  });
  it('fareyle seçim; dışarı tıklama kapatır', async () => {
    const fn = vi.fn();
    render(<div><Select label="Öğün" options={meals} onChange={fn} /><p>dışarı</p></div>);
    await userEvent.click(screen.getByRole('combobox'));
    await userEvent.click(screen.getByRole('option', { name: /Kahvaltı/ }));
    expect(fn).toHaveBeenCalledWith('breakfast');
    await userEvent.click(screen.getByRole('combobox'));
    await userEvent.click(screen.getByText('dışarı'));
    expect(screen.queryByRole('listbox')).toBeNull();
  });
  it('Türkçe yazarak arama: ş, ı ve İ', async () => {
    const fn = vi.fn();
    render(<Select label="Kategori" options={foods} onChange={fn} />);
    screen.getByRole('combobox').focus();
    await userEvent.keyboard('ş{Enter}');
    expect(fn).toHaveBeenLastCalledWith('seker');
    await userEvent.keyboard('{ArrowDown}');
    await userEvent.keyboard('ı{Enter}');
    expect(fn).toHaveBeenLastCalledWith('ispanak');
    await userEvent.keyboard('{ArrowDown}');
    await userEvent.keyboard('i{Enter}');
    expect(fn).toHaveBeenLastCalledWith('incir');
  });
  it('locked açılmaz; nedeni okunur', async () => {
    render(<Select label="Öğün" options={meals} state="locked" lockedReason="Diyetisyen belirledi" />);
    const cb = screen.getByRole('combobox');
    expect(cb).toHaveAccessibleDescription('Diyetisyen belirledi');
    await userEvent.click(cb);
    expect(screen.queryByRole('listbox')).toBeNull();
  });
  it('hata durumu', () => {
    render(<Select label="Öğün" options={meals} error="Öğün tipi seçin." />);
    expect(screen.getByRole('combobox')).toHaveAttribute('aria-invalid', 'true');
  });
  it('boş liste metni', async () => {
    render(<Select label="Öğün" options={[]} emptyText="Bu gün için öğün yok" />);
    await userEvent.click(screen.getByRole('combobox'));
    expect(screen.getByText('Bu gün için öğün yok')).toBeInTheDocument();
  });
});

describe('MultiSelect', () => {
  it('Enter ile seçimler değişir, liste açık kalır, özet güncellenir', async () => {
    const fn = vi.fn();
    render(<MultiSelect label="Kategoriler" options={foods} onChange={fn} />);
    const cb = screen.getByRole('combobox');
    cb.focus();
    await userEvent.keyboard('{ArrowDown}{Enter}{ArrowDown}{Enter}');
    expect(screen.getByRole('listbox')).toHaveAttribute('aria-multiselectable', 'true');
    expect(fn).toHaveBeenLastCalledWith(['sut', 'seker']);
    expect(cb).toHaveTextContent('Süt ürünleri, Şekerli gıdalar');
    await userEvent.keyboard('{ArrowDown}{Enter}');
    expect(cb).toHaveTextContent('3 seçili');
    await userEvent.keyboard('{ArrowUp}{ArrowUp}{Enter}');
    expect(fn).toHaveBeenLastCalledWith(['seker', 'sebze']);
    expect(screen.getAllByRole('option', { selected: true })).toHaveLength(2);
    await userEvent.keyboard('{Escape}');
    expect(screen.queryByRole('listbox')).toBeNull();
  });
});

describe('Select axe', () => {
  it('kapalı ve açık durumda ihlal yok', async () => {
    const { container } = render(<div><Select label="Öğün" options={meals} /><MultiSelect label="Kategoriler" options={foods} defaultValue={['sut']} /></div>);
    await expectNoA11yViolations(container);
    await userEvent.click(screen.getAllByRole('combobox')[0]);
    await expectNoA11yViolations(container);
  });
});
