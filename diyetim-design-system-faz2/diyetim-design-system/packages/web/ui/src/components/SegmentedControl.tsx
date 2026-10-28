import { useId, useRef, type KeyboardEvent, type ReactNode } from 'react';
import type { ComponentState } from '@diyetim/tokens';
import { cx } from '../utils/cx';
import { Icon, type IconName } from '../primitives/Icon';
import { useControllable } from '../utils/useControllable';

export interface SegmentOption<V extends string = string> { value: V; label: ReactNode; icon?: IconName; disabled?: boolean }

export interface SegmentedControlProps<V extends string = string> {
  /** Erişilebilir grup adı. */
  label: string;
  options: ReadonlyArray<SegmentOption<V>>;
  value?: V;
  defaultValue?: V;
  onChange?: (value: V) => void;
  state?: Exclude<ComponentState, 'loading'>;
  /** Eşit genişlikli bölümler (mobil). */
  fullWidth?: boolean;
  className?: string;
}

/** 2–5 karşılıklı dışlayıcı görünüm arasında geçiş (ör. Gün · Hafta · Ay). role=radiogroup; ok tuşları, Home/End. */
export function SegmentedControl<V extends string = string>({
  label, options, value, defaultValue, onChange, state = 'enabled', fullWidth, className,
}: SegmentedControlProps<V>) {
  const [v, setV] = useControllable<V>(value, (defaultValue ?? options[0]?.value) as V, onChange);
  const id = useId();
  const refs = useRef<Array<HTMLButtonElement | null>>([]);
  const enabled = options.map((o, i) => (o.disabled ? -1 : i)).filter((i) => i >= 0);
  const current = Math.max(0, options.findIndex((o) => o.value === v));
  const go = (i: number) => {
    const o = options[i];
    if (!o || o.disabled) return;
    refs.current[i]?.focus();
    if (state === 'enabled') setV(o.value);
  };
  const key = (e: KeyboardEvent) => {
    const pos = enabled.indexOf(current);
    const map: Record<string, number | undefined> = {
      ArrowRight: enabled[(pos + 1) % enabled.length], ArrowDown: enabled[(pos + 1) % enabled.length],
      ArrowLeft: enabled[(pos - 1 + enabled.length) % enabled.length], ArrowUp: enabled[(pos - 1 + enabled.length) % enabled.length],
      Home: enabled[0], End: enabled[enabled.length - 1],
    };
    if (e.key in map) { e.preventDefault(); const t = map[e.key]; if (t !== undefined) go(t); }
  };
  return (
    <div
      role="radiogroup"
      aria-label={label}
      aria-disabled={state !== 'enabled' || undefined}
      className={cx('dy-segmented', fullWidth && 'dy-segmented--full', `dy-segmented--${state}`, className)}
      style={{ ['--dy-seg-count' as string]: options.length, ['--dy-seg-index' as string]: current }}
      onKeyDown={key}
      data-state={state}
    >
      <span className="dy-segmented__indicator" aria-hidden="true" />
      {options.map((o, i) => {
        const on = i === current;
        return (
          <button
            key={o.value}
            ref={(el) => { refs.current[i] = el; }}
            id={`${id}-${i}`}
            type="button"
            role="radio"
            aria-checked={on}
            tabIndex={on ? 0 : -1}
            disabled={state === 'disabled' || o.disabled}
            className={cx('dy-segmented__item', on && 'dy-segmented__item--on')}
            onClick={() => go(i)}
          >
            {o.icon ? <Icon name={o.icon} size="sm" /> : null}
            <span>{o.label}</span>
          </button>
        );
      })}
    </div>
  );
}
