import { forwardRef, type ElementType, type HTMLAttributes, type ReactNode } from 'react';
import type { TextStyleToken, TextTone } from '@diyetim/tokens';
import { cx } from '../utils/cx';

const defaultTag: Record<TextStyleToken, ElementType> = {
  display: 'h1', h1: 'h1', h2: 'h2', h3: 'h3', h4: 'h4', 'body-lg': 'p', body: 'p', 'body-sm': 'p',
  caption: 'span', label: 'span', 'numeric-xl': 'span', 'numeric-lg': 'span', 'numeric-sm': 'span',
};

export interface TextProps extends HTMLAttributes<HTMLElement> {
  /** Tipografi stili (foundation.json typography). Varsayılan: body. */
  variant?: TextStyleToken;
  /** Metin rengi semantiği. Varsayılan: primary. */
  tone?: TextTone;
  /** Render edilecek öğe. Varsayılan, varyanta uygun semantik öğedir (h1, p, span). */
  as?: ElementType;
  /** Satır sınırı; aşan metin üç noktayla kesilir ve tam metin title ile korunur. */
  maxLines?: number;
  align?: 'start' | 'center' | 'end';
  children?: ReactNode;
}

/** Tüm metinlerin tek kapısı. Serbest font boyutu veya renk kabul etmez. */
export const Text = forwardRef<HTMLElement, TextProps>(function Text(
  { variant = 'body', tone = 'primary', as, maxLines, align, className, style, children, ...rest }, ref,
) {
  const Tag = as ?? defaultTag[variant];
  const clamp = maxLines ? ({ WebkitLineClamp: maxLines } as const) : undefined;
  return (
    <Tag
      ref={ref}
      className={cx('dy-text', `dy-text--${variant}`, `dy-tone--${tone}`, maxLines ? 'dy-text--clamp' : null, align && `dy-text--${align}`, className)}
      style={{ ...clamp, ...style }}
      title={maxLines && typeof children === 'string' ? children : undefined}
      {...rest}
    >
      {children}
    </Tag>
  );
});
