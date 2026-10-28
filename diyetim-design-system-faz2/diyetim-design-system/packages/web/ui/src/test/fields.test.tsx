import { useState } from 'react';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { TextField, SearchField, NumberField, Textarea } from '..';
import { expectNoA11yViolations } from './a11y';

describe('TextField', () => {
  it('görünür etiket input ile ilişkili; değer yazılır', async () => {
    const fn = vi.fn();
    render(<TextField label="Ad" onChange={fn} />);
    await userEvent.type(screen.getByLabelText('Ad'), 'Elif');
    expect(fn).toHaveBeenLastCalledWith('Elif');
    expect(screen.getByLabelText('Ad')).toHaveValue('Elif');
  });
  it('hata: aria-invalid, mesaj açıklamaya bağlı ve role=alert', () => {
    render(<TextField label="Kilo" error="Bu değer çok düşük görünüyor." description="kg cinsinden" />);
    const input = screen.getByLabelText('Kilo');
    expect(input).toHaveAttribute('aria-invalid', 'true');
    expect(input).toHaveAccessibleDescription('kg cinsinden Bu değer çok düşük görünüyor.');
    expect(screen.getByRole('alert')).toHaveTextContent('Bu değer çok düşük görünüyor.');
  });
  it('başarı mesajı status olarak duyurulur, aria-invalid yok', () => {
    render(<TextField label="E-posta" success="Doğrulandı" />);
    expect(screen.getByRole('status')).toHaveTextContent('Doğrulandı');
    expect(screen.getByLabelText('E-posta')).not.toHaveAttribute('aria-invalid');
  });
  it('locked: salt okunur, odaklanabilir, nedeni okunur, değişmez', async () => {
    render(<TextField label="Porsiyon" defaultValue="1 kase" state="locked" lockedReason="Diyetisyenin gramaj değişikliğini kapattı." />);
    const input = screen.getByLabelText('Porsiyon');
    expect(input).toHaveAttribute('readonly');
    expect(input).not.toBeDisabled();
    expect(input).toHaveAccessibleDescription('Diyetisyenin gramaj değişikliğini kapattı.');
    await userEvent.type(input, 'x');
    expect(input).toHaveValue('1 kase');
  });
  it('disabled: devre dışı', () => {
    render(<TextField label="Ad" state="disabled" />);
    expect(screen.getByLabelText('Ad')).toBeDisabled();
  });
  it('loading: aria-busy ve ilerleme çizgisi', () => {
    const { container } = render(<TextField label="Ad" state="loading" />);
    expect(screen.getByLabelText('Ad')).toHaveAttribute('aria-busy', 'true');
    expect(container.querySelector('.dy-input__progress')).not.toBeNull();
  });
  it('zorunlu alan', () => {
    render(<TextField label="Ad" required />);
    expect(screen.getByLabelText(/Ad/)).toBeRequired();
  });
});

describe('SearchField', () => {
  it('searchbox rolü; Escape ve temizle butonu siler', async () => {
    const fn = vi.fn();
    render(<SearchField label="Besin ara" hideLabel onChange={fn} />);
    const box = screen.getByRole('searchbox', { name: 'Besin ara' });
    await userEvent.type(box, 'yulaf');
    expect(box).toHaveValue('yulaf');
    await userEvent.keyboard('{Escape}');
    expect(box).toHaveValue('');
    await userEvent.type(box, 'tavuk');
    await userEvent.click(screen.getByRole('button', { name: 'Aramayı temizle' }));
    expect(box).toHaveValue('');
    expect(box).toHaveFocus();
  });
  it('Enter onSubmit çağırır', async () => {
    const submit = vi.fn();
    render(<SearchField label="Ara" onSubmit={submit} />);
    await userEvent.type(screen.getByRole('searchbox'), 'mercimek{Enter}');
    expect(submit).toHaveBeenCalledWith('mercimek');
  });
});

describe('NumberField', () => {
  function Controlled(props: { min?: number; max?: number; step?: number; initial?: number | null }) {
    const [v, setV] = useState<number | null>(props.initial ?? null);
    return <><NumberField label="Gramaj" unit="g" value={v} onChange={setV} min={props.min} max={props.max} step={props.step} /><output data-testid="v">{String(v)}</output></>;
  }
  it('Türkçe ondalık virgülü kabul eder', async () => {
    render(<Controlled />);
    await userEvent.type(screen.getByRole('spinbutton', { name: 'Gramaj' }), '6,5');
    expect(screen.getByTestId('v')).toHaveTextContent('6.5');
    expect(screen.getByRole('spinbutton')).toHaveValue('6,5');
  });
  it('harf girişini reddeder', async () => {
    render(<Controlled />);
    await userEvent.type(screen.getByRole('spinbutton'), 'abc');
    expect(screen.getByRole('spinbutton')).toHaveValue('');
  });
  it('ok tuşları adımlar ve sınırı aşmaz; + butonu sınırda devre dışı', async () => {
    render(<Controlled initial={190} step={10} max={200} min={0} />);
    const sb = screen.getByRole('spinbutton');
    sb.focus();
    await userEvent.keyboard('{ArrowUp}{ArrowUp}');
    expect(screen.getByTestId('v')).toHaveTextContent('200');
    expect(screen.getByRole('button', { name: '10 g artır' })).toBeDisabled();
    await userEvent.keyboard('{ArrowDown}');
    expect(screen.getByTestId('v')).toHaveTextContent('190');
    expect(sb).toHaveAttribute('aria-valuetext', '190 g');
  });
  it('locked: adımlama yok', async () => {
    const fn = vi.fn();
    render(<NumberField label="Gramaj" defaultValue={150} state="locked" lockedReason="Kapalı" onChange={fn} />);
    screen.getByRole('spinbutton').focus();
    await userEvent.keyboard('{ArrowUp}');
    expect(fn).not.toHaveBeenCalled();
  });
  it('boşaltılınca null', async () => {
    render(<Controlled initial={150} />);
    await userEvent.clear(screen.getByRole('spinbutton'));
    expect(screen.getByTestId('v')).toHaveTextContent('null');
  });
});

describe('Textarea', () => {
  it('sayaç ve sınır', async () => {
    render(<Textarea label="Not" maxLength={10} />);
    const ta = screen.getByLabelText('Not');
    await userEvent.type(ta, 'Harika bir tabak');
    expect(ta).toHaveValue('Harika bir');
    expect(screen.getByText('10 / 10')).toHaveAttribute('aria-live', 'polite');
  });
  it('locked salt okunur', () => {
    render(<Textarea label="Not" state="locked" lockedReason="Kapalı" />);
    expect(screen.getByLabelText('Not')).toHaveAttribute('readonly');
  });
});

describe('form alanları axe', () => {
  it('ihlal yok', async () => {
    const { container } = render(
      <form>
        <TextField label="Ad" description="Profilinde görünür" />
        <TextField label="Kilo" error="Geçersiz" />
        <SearchField label="Besin ara" hideLabel defaultValue="yulaf" />
        <NumberField label="Gramaj" unit="g" defaultValue={150} />
        <NumberField label="Porsiyon" state="locked" lockedReason="Kapalı" />
        <Textarea label="Not" maxLength={200} />
      </form>,
    );
    await expectNoA11yViolations(container);
  });
});
