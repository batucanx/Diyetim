import type { HTMLAttributes, ReactNode } from 'react';
import {
  appointmentStatusStyles, dataSourceStyles, labValueStatusStyles, mealStatusStyles,
  type AppointmentStatus, type DataSource, type LabValueStatus, type MealStatus, type StatusTone,
} from '@diyetim/tokens';
import { cx } from '../utils/cx';
import { Icon, type IconName } from '../primitives/Icon';
import { useStrings, type StringKey } from '../i18n/strings';
import { formatNumber } from '../utils/format';

export interface TagProps extends HTMLAttributes<HTMLSpanElement> {
  /** neutral · success · warning · error · info · primary. Renk tek gösterge değildir: ikon + metin zorunlu. */
  tone?: StatusTone;
  icon?: IconName;
  children: ReactNode;
}

/** Durum etiketi: subtle zemin + strong metin + ikon. Cümle değil, 1–3 kelime. */
export function Tag({ tone = 'neutral', icon, className, children, ...rest }: TagProps) {
  return (
    <span className={cx('dy-tag', `dy-tag--${tone}`, className)} {...rest}>
      {icon ? <Icon name={icon} size="sm" /> : null}
      <span className="dy-tag__label">{children}</span>
    </span>
  );
}

type StatusKind =
  | { kind: 'meal'; status: MealStatus }
  | { kind: 'appointment'; status: AppointmentStatus }
  | { kind: 'lab'; status: LabValueStatus };

/** Ortak sözleşmedeki (spec/contracts.json) durum değerini ton, ikon ve çeviri metniyle gösterir. */
export function StatusTag(props: StatusKind & { className?: string }) {
  const t = useStrings();
  const style = props.kind === 'meal' ? mealStatusStyles[props.status] : props.kind === 'appointment' ? appointmentStatusStyles[props.status] : labValueStatusStyles[props.status];
  return <Tag tone={style.tone} icon={style.icon as IconName} className={props.className} data-status={props.status}>{t(style.i18nKey as StringKey)}</Tag>;
}

/** Verinin kaynağı: Sen girdin · Diyetisyen · AI tahmini · Onaylı. Güven ilkesinin görünür yüzü. */
export function SourceTag({ source, className }: { source: DataSource; className?: string }) {
  const t = useStrings();
  const s = dataSourceStyles[source];
  return (
    <span className={cx('dy-source', `dy-source--${s.tone}`, className)} data-source={source}>
      <span className="dy-source__dot" aria-hidden="true" />
      {t(s.i18nKey as StringKey)}
    </span>
  );
}

export interface BadgeProps {
  /** Sayı; 0 ise rozet gösterilmez. max üzerini "max+" gösterir. */
  count: number;
  max?: number;
  /** Ekran okuyucu metni, ör. "3 okunmamış bildirim". */
  label: string;
  tone?: 'primary' | 'error' | 'neutral';
  className?: string;
}

/** Sayaç rozeti (bildirim, onay kuyruğu). İkon veya etiketin yanında kullanılır. */
export function Badge({ count, max = 99, label, tone = 'primary', className }: BadgeProps) {
  if (count <= 0) return null;
  return (
    <span className={cx('dy-badge', `dy-badge--${tone}`, className)} role="status" aria-label={label}>
      <span aria-hidden="true">{count > max ? `${formatNumber(max)}+` : formatNumber(count)}</span>
    </span>
  );
}
