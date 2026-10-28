import { forwardRef, useEffect, useRef, useImperativeHandle, type ElementType, type HTMLAttributes, type ReactNode, type KeyboardEvent } from 'react';
import { cx } from '../utils/cx';

export interface CardProps extends HTMLAttributes<HTMLElement> {
  /** flat: kenarlıklı düz · raised: hafif gölge · hero: ana kart (radius-xl, büyük iç boşluk). */
  variant?: 'flat' | 'raised' | 'hero';
  /** Kartın tamamı tıklanabilir. href verilirse bağlantı, onClick verilirse buton semantiği. Kart içinde ikinci etkileşimli öğe olmamalı. */
  interactive?: boolean;
  href?: string;
  /** Seçili kart (ör. onay kuyruğunda açık öğe). */
  selected?: boolean;
  padding?: 'compact' | 'default' | 'hero';
  as?: ElementType;
  children: ReactNode;
}

/** Kart tabanı. Alan kartları (öğün, randevu, danışan) Faz 3'te bunun üzerine kurulur. */
export const Card = forwardRef<HTMLElement, CardProps>(function Card(
  { variant = 'flat', interactive, href, selected, padding, as, className, children, onClick, onKeyDown, ...rest }, ref,
) {
  const inner = useRef<HTMLElement>(null);
  useImperativeHandle(ref, () => inner.current as HTMLElement);
  useEffect(() => {
    // Geliştirme uyarısı: tıklanabilir kartın içinde ikinci etkileşimli öğe ekran okuyucuda erişilemez (nested-interactive).
    if ((typeof process !== 'undefined' && process.env.NODE_ENV === 'production') || !interactive || !inner.current) return;
    if (inner.current.querySelector('a[href],button,input,select,textarea,[role="button"],[tabindex]:not([tabindex="-1"])')) {
      console.warn('[Diyetim] Card: interactive kart içinde etkileşimli öğe var. Kartı interactive yapmayın; eylemi CardHeader action alanına koyun.');
    }
  });
  const Tag: ElementType = as ?? (interactive && href ? 'a' : interactive ? 'div' : 'section');
  const pad = padding ?? (variant === 'hero' ? 'hero' : 'default');
  const keyHandler = (e: KeyboardEvent<HTMLElement>) => {
    onKeyDown?.(e);
    if (interactive && !href && (e.key === 'Enter' || e.key === ' ')) { e.preventDefault(); (e.currentTarget as HTMLElement).click(); }
  };
  return (
    <Tag
      ref={inner}
      href={interactive ? href : undefined}
      role={interactive && !href ? 'button' : undefined}
      tabIndex={interactive && !href ? 0 : undefined}
      aria-pressed={interactive && !href && selected !== undefined ? selected : undefined}
      aria-current={interactive && href && selected ? 'page' : undefined}
      className={cx('dy-card', `dy-card--${variant}`, `dy-card--pad-${pad}`, interactive && 'dy-card--interactive', selected && 'dy-card--selected', className)}
      onClick={onClick}
      onKeyDown={keyHandler}
      {...rest}
    >
      {children}
    </Tag>
  );
});

/** Kart başlık satırı: başlık, alt başlık ve sağda eylem. */
export function CardHeader({ title, subtitle, action, headingLevel = 3 }: { title: ReactNode; subtitle?: ReactNode; action?: ReactNode; headingLevel?: 2 | 3 | 4 }) {
  const H = `h${headingLevel}` as const;
  return (
    <div className="dy-card__header">
      <div className="dy-card__titles"><H className="dy-card__title">{title}</H>{subtitle ? <p className="dy-card__subtitle">{subtitle}</p> : null}</div>
      {action ? <div className="dy-card__action">{action}</div> : null}
    </div>
  );
}
