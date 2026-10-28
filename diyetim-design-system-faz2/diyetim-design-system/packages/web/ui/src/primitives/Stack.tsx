import { forwardRef, type ElementType, type HTMLAttributes } from 'react';
import type { SpacingToken } from '@diyetim/tokens';
import { spacing } from '@diyetim/tokens';
import { cx } from '../utils/cx';

export interface StackProps extends HTMLAttributes<HTMLElement> {
  as?: ElementType;
  direction?: 'vertical' | 'horizontal';
  /** Öğeler arası boşluk (spacing token). Varsayılan lg (16). */
  gap?: SpacingToken;
  align?: 'start' | 'center' | 'end' | 'stretch' | 'baseline';
  justify?: 'start' | 'center' | 'end' | 'between';
  /** Yatay yığında satır kaydırma. Büyük metin ölçeğinde taşmayı önler. */
  wrap?: boolean;
}

/** Spacing token'larıyla dikey veya yatay yerleşim. */
export const Stack = forwardRef<HTMLElement, StackProps>(function Stack(
  { as: Tag = 'div', direction = 'vertical', gap = 'lg', align, justify, wrap, className, style, ...rest }, ref,
) {
  return (
    <Tag
      ref={ref}
      className={cx('dy-stack', `dy-stack--${direction}`, align && `dy-align--${align}`, justify && `dy-justify--${justify}`, wrap && 'dy-stack--wrap', className)}
      style={{ gap: spacing[gap], ...style }}
      {...rest}
    />
  );
});

export interface GapProps { size: SpacingToken; direction?: 'vertical' | 'horizontal' }

/** Tek seferlik boşluk. Mümkünse Stack gap tercih edilir. */
export function Gap({ size, direction = 'vertical' }: GapProps) {
  const v = spacing[size];
  return <span aria-hidden="true" className="dy-gap" style={direction === 'vertical' ? { height: v } : { width: v }} />;
}
