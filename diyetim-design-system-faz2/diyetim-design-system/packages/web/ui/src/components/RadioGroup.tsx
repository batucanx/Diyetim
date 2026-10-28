import { useId, type ReactNode } from 'react';
import type { ComponentState } from '@diyetim/tokens';
import { cx } from '../utils/cx';
import { Icon } from '../primitives/Icon';
import { useControllable } from '../utils/useControllable';

export interface RadioOption<V extends string = string> { value: V; label: ReactNode; description?: string; disabled?: boolean }

export interface RadioGroupProps<V extends string = string> {
  /** Grup başlığı (legend). */
  label: string;
  hideLabel?: boolean;
  options: ReadonlyArray<RadioOption<V>>;
  value?: V | null;
  defaultValue?: V | null;
  onChange?: (value: V) => void;
  name?: string;
  description?: string;
  error?: string;
  state?: Exclude<ComponentState, 'loading'>;
  lockedReason?: string;
  required?: boolean;
  orientation?: 'vertical' | 'horizontal';
  className?: string;
}

/** Tek seçimli seçenek grubu. Yerel radio'lar: Tab gruba girer, ok tuşları seçimi değiştirir. */
export function RadioGroup<V extends string = string>({
  label, hideLabel, options, value, defaultValue = null, onChange, name, description, error, state = 'enabled', lockedReason, required,
  orientation = 'vertical', className,
}: RadioGroupProps<V>) {
  const [v, setV] = useControllable<V | null>(value, defaultValue, onChange as ((x: V | null) => void) | undefined);
  const id = useId();
  const groupName = name ?? `${id}-radio`;
  const describedBy = cx(description && `${id}-d`, state === 'locked' && lockedReason && `${id}-l`, error && `${id}-e`) || undefined;
  return (
    <fieldset
      className={cx('dy-radio-group', `dy-radio-group--${orientation}`, `dy-choice--${state}`, error && 'dy-choice--invalid', className)}
      disabled={state === 'disabled'}
      aria-describedby={describedBy}
      aria-invalid={error ? true : undefined}
      aria-required={required || undefined}
      data-state={state}
    >
      <legend className={cx('dy-field__label', hideLabel && 'dy-visually-hidden')}>{label}{required ? <span aria-hidden="true"> *</span> : null}</legend>
      <div className="dy-radio-group__items">
        {options.map((o) => {
          const oid = `${id}-${o.value}`;
          const on = v === o.value;
          return (
            <div key={o.value} className={cx('dy-choice', o.disabled && 'dy-choice--disabled')}>
              <input
                id={oid}
                type="radio"
                name={groupName}
                className="dy-choice__input"
                value={o.value}
                checked={on}
                disabled={o.disabled}
                aria-disabled={state === 'locked' || undefined}
                aria-describedby={o.description ? `${oid}-d` : undefined}
                onChange={() => { if (state !== 'locked') setV(o.value); }}
                      />
              <span className={cx('dy-radio', on && 'dy-radio--on')} aria-hidden="true" />
              <span className="dy-choice__text">
                <label htmlFor={oid} className="dy-choice__label">{o.label}</label>
                {o.description ? <span id={`${oid}-d`} className="dy-choice__desc">{o.description}</span> : null}
              </span>
            </div>
          );
        })}
      </div>
      {description ? <p id={`${id}-d`} className="dy-field__help">{description}</p> : null}
      {state === 'locked' && lockedReason ? <p id={`${id}-l`} className="dy-field__help dy-field__locked"><Icon name="lock" size="sm" />{lockedReason}</p> : null}
      {error ? <p id={`${id}-e`} className="dy-field__message dy-field__message--error" role="alert"><Icon name="alert" size="sm" />{error}</p> : null}
    </fieldset>
  );
}
