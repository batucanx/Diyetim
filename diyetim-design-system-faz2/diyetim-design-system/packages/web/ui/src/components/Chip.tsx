import { forwardRef, type ButtonHTMLAttributes } from 'react';
import { cx } from '../utils/cx';
import { Icon, type IconName } from '../primitives/Icon';

export interface ChipProps extends Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'onChange'> {
  /** Seçili filtre (aria-pressed). */
  selected?: boolean;
  icon?: IconName;
  /** Seçili iken sağda kaldır ikonu (kaldırma için ayrı onRemove değil; tıklama seçimi kaldırır). */
  removable?: boolean;
}

/** Filtre ve hızlı seçim çipi (aç/kapa buton). Görsel 36 px, dokunma alanı 44 px. */
export const Chip = forwardRef<HTMLButtonElement, ChipProps>(function Chip({ selected, icon, removable, className, children, type = 'button', ...rest }, ref) {
  return (
    <button ref={ref} type={type} aria-pressed={selected} className={cx('dy-chip', selected && 'dy-chip--selected', className)} {...rest}>
      {icon ? <Icon name={icon} size="sm" /> : null}
      <span>{children}</span>
      {removable && selected ? <Icon name="x" size="sm" /> : null}
    </button>
  );
});
