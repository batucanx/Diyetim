import { forwardRef, useId, type ButtonHTMLAttributes } from 'react';
import type { ComponentState } from '@diyetim/tokens';
import { cx } from '../utils/cx';
import { Icon } from '../primitives/Icon';
import { useControllable } from '../utils/useControllable';

export interface SwitchProps extends Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'onChange' | 'disabled' | 'value'> {
  label: string;
  description?: string;
  checked?: boolean;
  defaultChecked?: boolean;
  onChange?: (checked: boolean) => void;
  /** loading: değişiklik sunucuya giderken (anahtar yeni konumda, etkileşim kapalı). */
  state?: ComponentState;
  lockedReason?: string;
  /** Etiket konumu. Ayar satırlarında end (varsayılan): etiket solda, anahtar sağda. */
  labelPosition?: 'start' | 'end';
}

/** Anında geçerli açık/kapalı ayarı (role=switch). Kaydet butonu gerektiren seçimlerde Checkbox kullanılır. */
export const Switch = forwardRef<HTMLButtonElement, SwitchProps>(function Switch(
  { label, description, checked, defaultChecked = false, onChange, state = 'enabled', lockedReason, labelPosition = 'end', className, ...rest }, ref,
) {
  const [on, setOn] = useControllable(checked, defaultChecked, onChange);
  const id = useId();
  const describedBy = cx(description && `${id}-d`, state === 'locked' && lockedReason && `${id}-l`) || undefined;
  return (
    <div className={cx('dy-switch-row', `dy-switch-row--${labelPosition}`, `dy-choice--${state}`, className)} data-state={state}>
      <span className="dy-choice__text">
        <label htmlFor={id} className="dy-choice__label" id={`${id}-lbl`}>{label}</label>
        {description ? <span id={`${id}-d`} className="dy-choice__desc">{description}</span> : null}
        {state === 'locked' && lockedReason ? <span id={`${id}-l`} className="dy-choice__desc dy-field__locked"><Icon name="lock" size="sm" />{lockedReason}</span> : null}
      </span>
      <button
        ref={ref}
        id={id}
        type="button"
        role="switch"
        aria-checked={on}
        aria-labelledby={`${id}-lbl`}
        aria-describedby={describedBy}
        aria-disabled={state === 'locked' || state === 'loading' || undefined}
        aria-busy={state === 'loading' || undefined}
        disabled={state === 'disabled'}
        className={cx('dy-switch', on && 'dy-switch--on')}
        onClick={() => { if (state === 'enabled') setOn(!on); }}
        {...rest}
      >
        <span className="dy-switch__thumb" aria-hidden="true">{state === 'locked' ? <Icon name="lock" size="sm" /> : null}</span>
      </button>
    </div>
  );
});
