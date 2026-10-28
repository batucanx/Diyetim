import { useId, useRef, type KeyboardEvent, type ReactNode } from 'react';
import { cx } from '../utils/cx';
import { useControllable } from '../utils/useControllable';
import { Badge } from './Tag';

export interface TabItem<V extends string = string> {
  value: V;
  label: string;
  /** Sekme içeriği. Yalnızca seçili sekmenin içeriği render edilir. */
  content: ReactNode;
  /** Sayaç (ör. onay bekleyen 3 öğün). */
  count?: number;
  countLabel?: string;
  disabled?: boolean;
}

export interface TabsProps<V extends string = string> {
  label: string;
  items: ReadonlyArray<TabItem<V>>;
  value?: V;
  defaultValue?: V;
  onChange?: (value: V) => void;
  className?: string;
}

/** Aynı bağlamın bölümleri arasında geçiş (danışan detayı: Özet · Günlük · Plan · Tahliller …).
 *  APG tabs: ←/→ ve Home/End ile otomatik etkinleştirme; dar ekranda yatay kaydırılır. */
export function Tabs<V extends string = string>({ label, items, value, defaultValue, onChange, className }: TabsProps<V>) {
  const [v, setV] = useControllable<V>(value, (defaultValue ?? items[0]?.value) as V, onChange);
  const id = useId();
  const refs = useRef<Array<HTMLButtonElement | null>>([]);
  const enabled = items.map((t, i) => (t.disabled ? -1 : i)).filter((i) => i >= 0);
  const current = Math.max(0, items.findIndex((t) => t.value === v));
  const go = (i: number | undefined) => { if (i === undefined) return; setV(items[i].value); refs.current[i]?.focus(); };
  const key = (e: KeyboardEvent) => {
    const pos = enabled.indexOf(current);
    const map: Record<string, number | undefined> = {
      ArrowRight: enabled[(pos + 1) % enabled.length], ArrowLeft: enabled[(pos - 1 + enabled.length) % enabled.length],
      Home: enabled[0], End: enabled[enabled.length - 1],
    };
    if (e.key in map) { e.preventDefault(); go(map[e.key]); }
  };
  const sel = items[current];
  return (
    <div className={cx('dy-tabs', className)}>
      <div role="tablist" aria-label={label} className="dy-tabs__list" onKeyDown={key}>
        {items.map((t, i) => (
          <button key={t.value} ref={(el) => { refs.current[i] = el; }} id={`${id}-tab-${i}`} type="button" role="tab"
            aria-selected={i === current} aria-controls={`${id}-panel`} tabIndex={i === current ? 0 : -1} disabled={t.disabled}
            className={cx('dy-tabs__tab', i === current && 'dy-tabs__tab--on')} onClick={() => go(i)}>
            <span>{t.label}</span>
            {t.count ? <Badge count={t.count} label={t.countLabel ?? String(t.count)} tone={i === current ? 'primary' : 'neutral'} /> : null}
          </button>
        ))}
      </div>
      <div role="tabpanel" id={`${id}-panel`} aria-labelledby={`${id}-tab-${current}`} tabIndex={0} className="dy-tabs__panel">{sel?.content}</div>
    </div>
  );
}
