import type { ReactNode } from 'react';
import { cx } from '../utils/cx';
import { Icon, type IconName } from '../primitives/Icon';
import { NumberDisplay } from '../primitives/NumberDisplay';
import type { Visibility } from '@diyetim/tokens';
import { formatNumber } from '../utils/format';

export interface StatCardProps {
  label: string;
  value: number | null;
  unit?: string;
  fractionDigits?: number;
  /** Önceki döneme göre değişim. */
  delta?: number;
  deltaUnit?: string;
  /** Değişimin anlamı: artış iyi mi (uyum %) kötü mü (onay bekleyen)? Belirsizse neutral. */
  deltaIntent?: 'increase-is-good' | 'decrease-is-good' | 'neutral';
  /** Karşılaştırma bağlamı, ör. "geçen haftaya göre". */
  deltaContext?: string;
  icon?: IconName;
  footer?: ReactNode;
  visibility?: Visibility;
  className?: string;
}

/** Tek metrik kartı (panel genel bakış, danışan ilerleme). Değişim yönü ikon + metinle; renk tek gösterge değil. */
export function StatCard({ label, value, unit, fractionDigits = 1, delta, deltaUnit, deltaIntent = 'neutral', deltaContext, icon, footer, visibility, className }: StatCardProps) {
  const dir = delta === undefined || delta === 0 ? 'flat' : delta > 0 ? 'up' : 'down';
  const good = deltaIntent === 'neutral' || dir === 'flat' ? 'neutral' : (dir === 'up') === (deltaIntent === 'increase-is-good') ? 'good' : 'bad';
  const deltaText = delta === undefined ? null : `${delta > 0 ? '+' : delta < 0 ? '−' : ''}${formatNumber(Math.abs(delta), { maximumFractionDigits: fractionDigits })}${deltaUnit ? ` ${deltaUnit}` : ''}`;
  return (
    <section className={cx('dy-card', 'dy-card--flat', 'dy-card--pad-default', 'dy-stat', className)} aria-label={label}>
      <div className="dy-stat__label">{icon ? <Icon name={icon} size="sm" /> : null}<span>{label}</span></div>
      <NumberDisplay value={value} unit={unit} variant="numeric-lg" fractionDigits={fractionDigits} visibility={visibility} className="dy-stat__value" />
      {deltaText && visibility !== 'hidden' ? (
        <p className={cx('dy-stat__delta', `dy-stat__delta--${good}`)}>
          <Icon name={dir === 'up' ? 'arrowUp' : dir === 'down' ? 'arrowDown' : 'minus'} size="sm" />
          <span>{deltaText}</span>{deltaContext ? <span className="dy-stat__context">{deltaContext}</span> : null}
        </p>
      ) : null}
      {footer ? <div className="dy-stat__footer">{footer}</div> : null}
    </section>
  );
}
