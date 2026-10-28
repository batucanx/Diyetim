import type { SVGAttributes } from 'react';
import { iconPaths, type IconName } from '../icons/paths';
import { cx } from '../utils/cx';

export type IconSize = 'sm' | 'md' | 'lg' | 'xl';

export interface IconProps extends Omit<SVGAttributes<SVGSVGElement>, 'children'> {
  name: IconName;
  /** sm 16 · md 20 · lg 24 · xl 32. Varsayılan md. */
  size?: IconSize;
  /** Verilirse ikon anlam taşır (role=img); verilmezse dekoratiftir ve ekran okuyucudan gizlenir. */
  label?: string;
}

/** Tek çizgi kalınlığında ikon. Rengi currentColor'dan alır. */
export function Icon({ name, size = 'md', label, className, ...rest }: IconProps) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={cx('dy-icon', `dy-icon--${size}`, className)}
      role={label ? 'img' : undefined}
      aria-label={label}
      aria-hidden={label ? undefined : true}
      focusable="false"
      data-icon={name}
      dangerouslySetInnerHTML={{ __html: iconPaths[name] }}
      {...rest}
    />
  );
}
export type { IconName };
