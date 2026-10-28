import { forwardRef, type TextareaHTMLAttributes } from 'react';
import { cx } from '../utils/cx';
import { FieldShell, type FieldBaseProps } from './Field';
import { useControllable } from '../utils/useControllable';
import { formatNumber } from '../utils/format';

export interface TextareaProps extends FieldBaseProps, Omit<TextareaHTMLAttributes<HTMLTextAreaElement>, 'value' | 'defaultValue' | 'onChange' | 'disabled' | 'required'> {
  value?: string;
  defaultValue?: string;
  onChange?: (value: string) => void;
  /** Görünen en az satır. Varsayılan 3. İçerik büyüdükçe alan uzar (maxRows'a kadar). */
  rows?: number;
  maxRows?: number;
  /** Verilirse karakter sayacı gösterilir; sınır aşılamaz. */
  maxLength?: number;
}

/** Çok satırlı metin (diyetisyen notu, öğün notu). Sayaç ekran okuyucuya yalnızca sınıra yaklaşınca duyurulur. */
export const Textarea = forwardRef<HTMLTextAreaElement, TextareaProps>(function Textarea(props, ref) {
  const { label, hideLabel, description, error, success, state = 'enabled', lockedReason, required, value, defaultValue = '', onChange,
    rows = 3, maxRows = 10, maxLength, className, style, ...rest } = props;
  const [v, setV] = useControllable(value, defaultValue, onChange);
  const near = maxLength !== undefined && v.length >= maxLength * 0.9;
  return (
    <FieldShell {...{ label, hideLabel, description, error, success, state, lockedReason, required, className }}>
      {({ inputId, describedBy, invalid }) => (
        <div className={cx('dy-input', 'dy-input--multiline', invalid && 'dy-input--invalid', `dy-input--${state}`)}>
          <textarea
            ref={ref}
            id={inputId}
            className="dy-input__control dy-textarea"
            rows={rows}
            style={{ ['--dy-textarea-max-rows' as string]: maxRows, ...style }}
            value={v}
            maxLength={maxLength}
            onChange={(e) => setV(e.target.value)}
            disabled={state === 'disabled'}
            readOnly={state === 'locked' || state === 'loading'}
            aria-readonly={state === 'locked' || undefined}
            aria-busy={state === 'loading' || undefined}
            aria-invalid={invalid || undefined}
            aria-describedby={describedBy}
            required={required}
            {...rest}
          />
          {maxLength !== undefined ? (
            <span className={cx('dy-textarea__count', near && 'dy-textarea__count--near')} aria-live={near ? 'polite' : 'off'}>
              {formatNumber(v.length)} / {formatNumber(maxLength)}
            </span>
          ) : null}
        </div>
      )}
    </FieldShell>
  );
});
