import { forwardRef, type ElementType, type HTMLAttributes } from 'react';
import type { Elevation, SurfaceLevel, SpacingToken, RadiusToken } from '@diyetim/tokens';
import { spacing } from '@diyetim/tokens';
import { cx } from '../utils/cx';

export interface SurfaceProps extends HTMLAttributes<HTMLElement> {
  as?: ElementType;
  /** Yüzey katmanı. Varsayılan surface. */
  level?: SurfaceLevel;
  elevation?: Elevation;
  radius?: RadiusToken;
  /** İç boşluk (spacing token). */
  padding?: SpacingToken;
  /** border-subtle kenarlık. Varsayılan: level surface/elevated iken true. */
  bordered?: boolean;
}

/** Zemin, kenarlık, radius ve derinliği tek yerden yöneten kutu. Kart ve paneller bunun üzerine kurulur. */
export const Surface = forwardRef<HTMLElement, SurfaceProps>(function Surface(
  { as: Tag = 'div', level = 'surface', elevation = 'none', radius = 'lg', padding, bordered, className, style, ...rest }, ref,
) {
  const border = bordered ?? (level === 'surface' || level === 'elevated');
  return (
    <Tag
      ref={ref}
      className={cx('dy-surface', `dy-surface--${level}`, `dy-elevation--${elevation}`, `dy-radius--${radius}`, border && 'dy-surface--bordered', className)}
      style={{ padding: padding ? spacing[padding] : undefined, ...style }}
      {...rest}
    />
  );
});
