import type { HTMLAttributes } from 'react';
import type { TextStyleToken, TextTone, Visibility } from '@diyetim/tokens';
import { cx } from '../utils/cx';
import { formatNumber, NBSP } from '../utils/format';
import { Icon } from './Icon';
import { useStrings } from '../i18n/strings';

export interface NumberDisplayProps extends Omit<HTMLAttributes<HTMLSpanElement>, 'children'> {
  /** Gösterilecek değer. null: değer yok (emptyLabel gösterilir). */
  value: number | null;
  /** Birim (kcal, g, kg, mg/dL). Değerden bölünmez boşlukla ayrılır. */
  unit?: string;
  /** Rakam stili. Varsayılan numeric-sm. */
  variant?: Extract<TextStyleToken, 'numeric-xl' | 'numeric-lg' | 'numeric-sm' | 'body' | 'body-sm' | 'h4'>;
  tone?: TextTone;
  /** Ondalık basamak sayısı (en fazla). Varsayılan 1. */
  fractionDigits?: number;
  format?: 'decimal' | 'percent';
  /** Ekran okuyucu bağlamı, ör. "Kalan kalori". Görünmez; değerden önce okunur. */
  label?: string;
  /** hidden: diyetisyen bu metriği gizledi. Değer API'den gelmez; "Gizli" gösterilir. */
  visibility?: Visibility;
  /** Değer null iken gösterilen metin. Varsayılan "—" (ekran okuyucu: "değer yok"). */
  emptyLabel?: string;
}

/** Sayıları Türkçe biçimde, eşit genişlikli rakamlarla ve birimiyle gösterir. */
export function NumberDisplay({
  value, unit, variant = 'numeric-sm', tone = 'primary', fractionDigits = 1, format = 'decimal', label,
  visibility = 'visible', emptyLabel = '—', className, ...rest
}: NumberDisplayProps) {
  const t = useStrings();
  const base = cx('dy-num', 'dy-text', `dy-text--${variant}`, `dy-tone--${tone}`, className);
  if (visibility === 'hidden') {
    return (
      <span className={cx(base, 'dy-num--hidden')} {...rest}>
        <Icon name="eyeOff" size="sm" />
        <span>{label ? <span className="dy-visually-hidden">{label}: </span> : null}{t('common.hidden')}</span>
      </span>
    );
  }
  if (value === null || Number.isNaN(value)) {
    return (
      <span className={cx(base, 'dy-num--empty')} {...rest}>
        {label ? <span className="dy-visually-hidden">{label}: </span> : null}
        <span aria-hidden="true">{emptyLabel}</span>
        <span className="dy-visually-hidden">{t('common.noValue')}</span>
      </span>
    );
  }
  const text = formatNumber(value, { style: format, maximumFractionDigits: format === 'percent' ? 0 : fractionDigits });
  return (
    <span className={base} {...rest}>
      {label ? <span className="dy-visually-hidden">{label}: </span> : null}
      <span className="dy-num__value">{text}</span>
      {unit ? <span className="dy-num__unit">{NBSP}{unit}</span> : null}
    </span>
  );
}
