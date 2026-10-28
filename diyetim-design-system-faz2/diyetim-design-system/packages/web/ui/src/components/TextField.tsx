import { forwardRef, useRef, useState, type InputHTMLAttributes, type ReactNode, type KeyboardEvent } from 'react';
import { cx } from '../utils/cx';
import { Icon, type IconName } from '../primitives/Icon';
import { FieldShell, type FieldBaseProps } from './Field';
import { useControllable } from '../utils/useControllable';
import { formatNumber, parseNumber } from '../utils/format';

type NativeInput = Omit<InputHTMLAttributes<HTMLInputElement>, 'value' | 'defaultValue' | 'onChange' | 'size' | 'disabled' | 'required'>;

export interface TextFieldProps extends FieldBaseProps, NativeInput {
  value?: string;
  defaultValue?: string;
  onChange?: (value: string) => void;
  iconStart?: IconName;
  /** Birim veya kısa son ek (kg, g). */
  suffix?: string;
  /** Sağ uçta ek öğe (ör. temizle butonu). */
  endAdornment?: ReactNode;
}

function InputFrame({ state, invalid, iconStart, children, suffix, end, focusTarget }: {
  state: string; invalid: boolean; iconStart?: IconName; children: ReactNode; suffix?: string; end?: ReactNode; focusTarget: () => void;
}) {
  return (
    <div className={cx('dy-input', invalid && 'dy-input--invalid', `dy-input--${state}`)} onMouseDown={(e) => { if (e.target === e.currentTarget) { e.preventDefault(); focusTarget(); } }}>
      {state === 'locked' ? <Icon name="lock" size="sm" className="dy-input__icon" /> : iconStart ? <Icon name={iconStart} className="dy-input__icon" /> : null}
      {children}
      {suffix ? <span className="dy-input__suffix" aria-hidden="true">{suffix}</span> : null}
      {end}
      {state === 'loading' ? <span className="dy-input__progress" aria-hidden="true" /> : null}
    </div>
  );
}

/** Tek satırlık metin girişi. */
export const TextField = forwardRef<HTMLInputElement, TextFieldProps>(function TextField(props, ref) {
  const { label, hideLabel, description, error, success, state = 'enabled', lockedReason, required, value, defaultValue = '', onChange,
    iconStart, suffix, endAdornment, className, ...input } = props;
  const [v, setV] = useControllable(value, defaultValue, onChange);
  const inner = useRef<HTMLInputElement | null>(null);
  return (
    <FieldShell {...{ label, hideLabel, description, error, success, state, lockedReason, required, className }}>
      {({ inputId, describedBy, invalid }) => (
        <InputFrame state={state} invalid={invalid} iconStart={iconStart} suffix={suffix} end={endAdornment} focusTarget={() => inner.current?.focus()}>
          <input
            ref={(el) => { inner.current = el; if (typeof ref === 'function') ref(el); else if (ref) ref.current = el; }}
            id={inputId}
            className="dy-input__control"
            value={v}
            onChange={(e) => setV(e.target.value)}
            disabled={state === 'disabled'}
            readOnly={state === 'locked' || input.readOnly}
            aria-readonly={state === 'locked' || undefined}
            aria-busy={state === 'loading' || undefined}
            aria-invalid={invalid || undefined}
            aria-describedby={describedBy}
            required={required}
            {...input}
          />
        </InputFrame>
      )}
    </FieldShell>
  );
});

export interface SearchFieldProps extends Omit<TextFieldProps, 'iconStart' | 'type' | 'endAdornment' | 'onSubmit'> {
  /** Temizle butonunun erişilebilir adı. */
  clearLabel?: string;
  onSubmit?: (value: string) => void;
}

/** Arama alanı: Escape ve temizle butonu değeri siler; state=loading sonuçlar gelirken kullanılır. */
export const SearchField = forwardRef<HTMLInputElement, SearchFieldProps>(function SearchField(
  { clearLabel = 'Aramayı temizle', onSubmit, value, defaultValue = '', onChange, onKeyDown, ...rest }, ref,
) {
  const [v, setV] = useControllable(value, defaultValue, onChange);
  const inputRef = useRef<HTMLInputElement | null>(null);
  const key = (e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Escape' && v) { e.preventDefault(); setV(''); }
    if (e.key === 'Enter') onSubmit?.(v);
    onKeyDown?.(e);
  };
  return (
    <TextField
      ref={(el) => { inputRef.current = el; if (typeof ref === 'function') ref(el); else if (ref) ref.current = el; }}
      {...rest}
      type="search"
      role="searchbox"
      enterKeyHint="search"
      iconStart="search"
      value={v}
      onChange={setV}
      onKeyDown={key}
      endAdornment={v && rest.state !== 'disabled' && rest.state !== 'locked' ? (
        <button type="button" className="dy-input__clear" aria-label={clearLabel} onClick={() => { setV(''); inputRef.current?.focus(); }}>
          <Icon name="x" size="sm" />
        </button>
      ) : null}
    />
  );
});

export interface NumberFieldProps extends FieldBaseProps, Omit<NativeInput, 'type' | 'min' | 'max' | 'step' | 'onChange'> {
  value?: number | null;
  defaultValue?: number | null;
  onChange?: (value: number | null) => void;
  min?: number;
  max?: number;
  /** Artırma adımı. Varsayılan 1. */
  step?: number;
  /** Gösterilecek en fazla ondalık basamak. Varsayılan 1. */
  fractionDigits?: number;
  /** Birim: g, kg, kcal. */
  unit?: string;
  /** − / + butonlarını gösterir. Varsayılan true. */
  stepper?: boolean;
  decrementLabel?: string;
  incrementLabel?: string;
}

const clamp = (n: number, min?: number, max?: number) => Math.min(max ?? Infinity, Math.max(min ?? -Infinity, n));

/** Türkçe ondalık (virgül) kabul eden sayı alanı. Ok tuşları ve − / + adımlar; sınırlar dışına adımlamaz.
 *  Elle girilen sınır dışı değer silinmez; hata mesajını üst bileşen verir. */
export const NumberField = forwardRef<HTMLInputElement, NumberFieldProps>(function NumberField(props, ref) {
  const { label, hideLabel, description, error, success, state = 'enabled', lockedReason, required, value, defaultValue = null, onChange,
    min, max, step = 1, fractionDigits = 1, unit, stepper = true, decrementLabel, incrementLabel, className, onBlur, onKeyDown, ...input } = props;
  const [num, setNum] = useControllable<number | null>(value, defaultValue, onChange);
  const fmt = (n: number | null) => (n === null ? '' : formatNumber(n, { maximumFractionDigits: fractionDigits }).replace(/\./g, ''));
  const [draft, setDraft] = useState<string | null>(null);
  const text = draft ?? fmt(num);
  const inner = useRef<HTMLInputElement | null>(null);
  const editable = state === 'enabled';
  const stepBy = (dir: 1 | -1) => {
    if (!editable) return;
    const next = clamp(+(((num ?? min ?? 0) + dir * step).toFixed(6)), min, max);
    setDraft(null);
    setNum(next);
  };
  const atMin = num !== null && min !== undefined && num <= min;
  const atMax = num !== null && max !== undefined && num >= max;
  const u = unit ? ` ${unit}` : '';
  return (
    <FieldShell {...{ label, hideLabel, description, error, success, state, lockedReason, required, className }}>
      {({ inputId, describedBy, invalid }) => (
        <InputFrame state={state} invalid={invalid} suffix={unit} focusTarget={() => inner.current?.focus()} end={stepper ? (
          <span className="dy-stepper">
            <button type="button" className="dy-stepper__btn" aria-label={decrementLabel ?? `${step}${u} azalt`} tabIndex={-1} disabled={!editable || atMin} onClick={() => stepBy(-1)}><Icon name="minus" size="sm" /></button>
            <button type="button" className="dy-stepper__btn" aria-label={incrementLabel ?? `${step}${u} artır`} tabIndex={-1} disabled={!editable || atMax} onClick={() => stepBy(1)}><Icon name="plus" size="sm" /></button>
          </span>
        ) : null}>
          <input
            ref={(el) => { inner.current = el; if (typeof ref === 'function') ref(el); else if (ref) ref.current = el; }}
            id={inputId}
            className="dy-input__control dy-input__control--numeric"
            inputMode="decimal"
            autoComplete="off"
            role="spinbutton"
            aria-valuenow={num ?? undefined}
            aria-valuemin={min}
            aria-valuemax={max}
            aria-valuetext={num === null ? undefined : `${fmt(num)}${u}`}
            value={text}
            onChange={(e) => {
              const raw = e.target.value;
              if (!/^-?[\d.,\s]*$/.test(raw)) return;
              setDraft(raw);
              const parsed = parseNumber(raw);
              if (parsed !== num) setNum(parsed);
            }}
            onBlur={(e) => { setDraft(null); onBlur?.(e); }}
            onKeyDown={(e) => {
              if (e.key === 'ArrowUp') { e.preventDefault(); stepBy(1); }
              if (e.key === 'ArrowDown') { e.preventDefault(); stepBy(-1); }
              onKeyDown?.(e);
            }}
            disabled={state === 'disabled'}
            readOnly={!editable && state !== 'disabled'}
            aria-readonly={state === 'locked' || undefined}
            aria-busy={state === 'loading' || undefined}
            aria-invalid={invalid || undefined}
            aria-describedby={describedBy}
            required={required}
            {...input}
          />
        </InputFrame>
      )}
    </FieldShell>
  );
});
