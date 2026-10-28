import type { ReactNode } from 'react';
import { cx } from '../utils/cx';
import { formatNumber } from '../utils/format';

type Tone = 'primary' | 'success' | 'warning' | 'carb' | 'protein' | 'fat';

export interface ProgressBarProps {
  /** null: belirsiz süre (indeterminate). */
  value: number | null;
  max?: number;
  /** Erişilebilir ad, ör. "Protein". */
  label: string;
  /** Okunacak değer metni, ör. "68 / 120 g". Verilmezse yüzde. */
  valueText?: string;
  tone?: Tone;
  /** Etiket ve değeri çubuğun üstünde gösterir. */
  showLabel?: boolean;
  size?: 'sm' | 'md';
  className?: string;
}

/** İlerleme çubuğu (role=progressbar). Değer max'ı aşabilir (hedef aşımı); çubuk dolu kalır, değer metni gerçek değeri söyler. */
export function ProgressBar({ value, max = 100, label, valueText, tone = 'primary', showLabel, size = 'md', className }: ProgressBarProps) {
  const pct = value === null ? null : Math.max(0, Math.min(100, (value / max) * 100));
  const text = valueText ?? (pct === null ? undefined : formatNumber(pct / 100, { style: 'percent' }));
  return (
    <div className={cx('dy-progress', `dy-progress--${size}`, className)}>
      {showLabel ? (
        <div className="dy-progress__head" aria-hidden="true"><span className="dy-progress__label">{label}</span>{text ? <span className="dy-progress__value">{text}</span> : null}</div>
      ) : null}
      <div role="progressbar" aria-label={label} aria-valuemin={0} aria-valuemax={max} aria-valuenow={value === null ? undefined : Math.min(value, max)} aria-valuetext={text}
        className={cx('dy-progress__track', pct === null && 'dy-progress__track--indeterminate')}>
        <span className={cx('dy-progress__fill', `dy-progress__fill--${tone}`)} style={pct === null ? undefined : { width: `${pct}%` }} />
      </div>
    </div>
  );
}

export interface ProgressRingProps {
  value: number;
  max?: number;
  label: string;
  valueText?: string;
  /** Halkanın ortası (ör. "%48 hedefin"). */
  children?: ReactNode;
  size?: 'md' | 'lg';
  tone?: 'primary' | 'warning';
  className?: string;
}

/** Halka gösterge (kalori halkası tabanı). role=progressbar; görsel orta metin ekran okuyucudan gizlenir, değer valuetext'le okunur. */
export function ProgressRing({ value, max = 100, label, valueText, children, size = 'lg', tone = 'primary', className }: ProgressRingProps) {
  const pct = Math.max(0, Math.min(1, value / max));
  const C = 2 * Math.PI * 44;
  return (
    <div role="progressbar" aria-label={label} aria-valuemin={0} aria-valuemax={max} aria-valuenow={Math.min(value, max)} aria-valuetext={valueText ?? formatNumber(pct, { style: 'percent' })}
      className={cx('dy-ring', `dy-ring--${size}`, className)}>
      <svg viewBox="0 0 100 100" aria-hidden="true">
        <circle className="dy-ring__track" cx="50" cy="50" r="44" />
        <circle className={cx('dy-ring__fill', `dy-ring__fill--${tone}`)} cx="50" cy="50" r="44" strokeDasharray={C} strokeDashoffset={C * (1 - pct)} />
      </svg>
      {children ? <div className="dy-ring__center" aria-hidden="true">{children}</div> : null}
    </div>
  );
}
