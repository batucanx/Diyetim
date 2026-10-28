import type { ReactNode } from 'react';
import { cx } from '../utils/cx';
import { Icon } from '../primitives/Icon';

export interface ListItemProps {
  title: ReactNode;
  description?: ReactNode;
  /** Sol: ikon, avatar veya küçük görsel. */
  leading?: ReactNode;
  /** Sağ: meta metin, değer, tag. */
  trailing?: ReactNode;
  /** Satırın tamamı tıklanabilir; sağda ok gösterilir. */
  onClick?: () => void;
  href?: string;
  selected?: boolean;
  /** Alt ayırıcı. Liste kartı içinde son satırda kapatılır. */
  divider?: boolean;
  className?: string;
}

/** Liste satırı. Uzun başlık iki satıra kadar kayar; açıklama alt satırda. */
export function ListItem({ title, description, leading, trailing, onClick, href, selected, divider = true, className }: ListItemProps) {
  const interactive = !!onClick || !!href;
  const content = (
    <>
      {leading ? <span className="dy-list-item__leading">{leading}</span> : null}
      <span className="dy-list-item__text">
        <span className="dy-list-item__title">{title}</span>
        {description ? <span className="dy-list-item__desc">{description}</span> : null}
      </span>
      {trailing ? <span className="dy-list-item__trailing">{trailing}</span> : null}
      {interactive ? <Icon name="chevronRight" size="sm" className="dy-list-item__chevron" /> : null}
    </>
  );
  const cls = cx('dy-list-item', interactive && 'dy-list-item--interactive', selected && 'dy-list-item--selected', divider && 'dy-list-item--divider', className);
  if (href) return <li className="dy-list-row"><a className={cls} href={href} aria-current={selected ? 'page' : undefined}>{content}</a></li>;
  if (onClick) return <li className="dy-list-row"><button type="button" className={cls} onClick={onClick} aria-pressed={selected}>{content}</button></li>;
  return <li className={cx('dy-list-row', cls)}>{content}</li>;
}

/** ListItem kapsayıcısı (ul). */
export function List({ children, label, className }: { children: ReactNode; label?: string; className?: string }) {
  return <ul className={cx('dy-list', className)} aria-label={label}>{children}</ul>;
}
