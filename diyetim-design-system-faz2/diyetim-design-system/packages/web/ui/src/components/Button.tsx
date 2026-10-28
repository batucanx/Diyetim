import { forwardRef, type ReactNode } from 'react';
import type { ButtonSize, ButtonVariant } from '@diyetim/tokens';
import { cx } from '../utils/cx';
import { Icon, type IconName } from '../primitives/Icon';
import { Pressable, type PressableProps } from '../primitives/Pressable';

export interface ButtonProps extends PressableProps {
  /** primary: ekranda en fazla bir tane · secondary · tertiary · ghost · destructive. */
  variant?: ButtonVariant;
  /** sm 36 (yalnızca panel tabloları) · md 44 · lg 52 (mobil ana eylem). */
  size?: ButtonSize;
  iconStart?: IconName;
  iconEnd?: IconName;
  fullWidth?: boolean;
  children: ReactNode;
}

/** Eylem butonu. loading genişliği korur ve etiketi ekran okuyucu için saklar; dönen yükleyici kullanılmaz. */
export const Button = forwardRef<HTMLButtonElement, ButtonProps>(function Button(
  { variant = 'primary', size = 'md', iconStart, iconEnd, fullWidth, state = 'enabled', className, children, ...rest }, ref,
) {
  return (
    <Pressable
      ref={ref}
      state={state}
      className={cx('dy-button', `dy-button--${variant}`, `dy-button--${size}`, fullWidth && 'dy-button--block', className)}
      {...rest}
    >
      <span className="dy-button__content">
        {state === 'locked' ? <Icon name="lock" size="sm" /> : iconStart ? <Icon name={iconStart} size={size === 'lg' ? 'md' : 'sm'} /> : null}
        <span className="dy-button__label">{children}</span>
        {iconEnd ? <Icon name={iconEnd} size={size === 'lg' ? 'md' : 'sm'} /> : null}
      </span>
      {state === 'loading' ? <span className="dy-button__progress" aria-hidden="true" /> : null}
    </Pressable>
  );
});

export interface IconButtonProps extends Omit<PressableProps, 'children'> {
  icon: IconName;
  /** Zorunlu erişilebilir ad (aria-label). */
  label: string;
  /** ghost: zeminsiz · surface: kartlı · primary: dolgulu. */
  variant?: 'ghost' | 'surface' | 'primary';
  size?: 'md' | 'lg';
}

/** Yalnızca ikon içeren buton. Dokunma alanı en az 44 × 44. */
export const IconButton = forwardRef<HTMLButtonElement, IconButtonProps>(function IconButton(
  { icon, label, variant = 'ghost', size = 'md', className, ...rest }, ref,
) {
  return (
    <Pressable ref={ref} aria-label={label} className={cx('dy-icon-button', `dy-icon-button--${variant}`, `dy-icon-button--${size}`, className)} {...rest}>
      <Icon name={icon} size={size === 'lg' ? 'lg' : 'md'} />
    </Pressable>
  );
});

export interface FabProps extends Omit<PressableProps, 'children'> {
  icon: IconName;
  label: string;
}

/** Ekrandaki tek yüksek vurgulu eylem (surface-inverse). Ekranda en fazla bir tane. */
export const Fab = forwardRef<HTMLButtonElement, FabProps>(function Fab({ icon, label, className, ...rest }, ref) {
  return (
    <Pressable ref={ref} aria-label={label} className={cx('dy-fab', className)} {...rest}>
      <Icon name={icon} size="lg" />
    </Pressable>
  );
});
