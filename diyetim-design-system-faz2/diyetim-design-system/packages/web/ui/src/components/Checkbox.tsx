import { forwardRef, useEffect, useId, useRef, type InputHTMLAttributes, type ReactNode } from 'react';
import type { ComponentState } from '@diyetim/tokens';
import { cx } from '../utils/cx';
import { Icon } from '../primitives/Icon';
import { useControllable } from '../utils/useControllable';

type Native = Omit<InputHTMLAttributes<HTMLInputElement>, 'type' | 'checked' | 'defaultChecked' | 'onChange' | 'disabled'>;

export interface CheckboxProps extends Native {
  label: ReactNode;
  description?: string;
  checked?: boolean;
  defaultChecked?: boolean;
  /** Karışık durum (ör. "tümünü seç" kısmen seçiliyken). */
  indeterminate?: boolean;
  onChange?: (checked: boolean) => void;
  state?: Exclude<ComponentState, 'loading'>;
  lockedReason?: string;
  error?: string;
}

/** Onay kutusu. Yerel input üzerine kurulu; Space değiştirir. locked iken odaklanabilir, değişmez. */
export const Checkbox = forwardRef<HTMLInputElement, CheckboxProps>(function Checkbox(
  { label, description, checked, defaultChecked = false, indeterminate, onChange, state = 'enabled', lockedReason, error, className, ...rest }, ref,
) {
  const [on, setOn] = useControllable(checked, defaultChecked, onChange);
  const id = useId();
  const inner = useRef<HTMLInputElement | null>(null);
  useEffect(() => { if (inner.current) inner.current.indeterminate = !!indeterminate; }, [indeterminate]);
  const describedBy = cx(description && `${id}-d`, state === 'locked' && lockedReason && `${id}-l`, error && `${id}-e`) || undefined;
  return (
    <div className={cx('dy-choice', `dy-choice--${state}`, error && 'dy-choice--invalid', className)} data-state={state}>
      <input
        ref={(el) => { inner.current = el; if (typeof ref === 'function') ref(el); else if (ref) ref.current = el; }}
        id={id}
        type="checkbox"
        className="dy-choice__input"
        checked={on}
        disabled={state === 'disabled'}
        aria-disabled={state === 'locked' || undefined}
        aria-invalid={error ? true : undefined}
        aria-describedby={describedBy}
        onChange={(e) => { if (state === 'locked') return; setOn(e.target.checked); }}
        {...rest}
      />
      <span className={cx('dy-check', (on || indeterminate) && 'dy-check--on')} aria-hidden="true">
        {indeterminate ? <Icon name="minus" size="sm" /> : on ? <Icon name="check" size="sm" /> : null}
      </span>
      <span className="dy-choice__text">
        <label htmlFor={id} className="dy-choice__label">{label}</label>
        {description ? <span id={`${id}-d`} className="dy-choice__desc">{description}</span> : null}
        {state === 'locked' && lockedReason ? <span id={`${id}-l`} className="dy-choice__desc dy-field__locked"><Icon name="lock" size="sm" />{lockedReason}</span> : null}
        {error ? <span id={`${id}-e`} className="dy-field__message dy-field__message--error"><Icon name="alert" size="sm" />{error}</span> : null}
      </span>
    </div>
  );
});
