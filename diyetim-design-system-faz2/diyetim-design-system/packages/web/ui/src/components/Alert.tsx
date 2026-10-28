import type { ReactNode } from 'react';
import type { FeedbackTone } from '@diyetim/tokens';
import { cx } from '../utils/cx';
import { Icon, type IconName } from '../primitives/Icon';
import { useStrings } from '../i18n/strings';

const toneIcon: Record<FeedbackTone, IconName> = { info: 'info', success: 'checkCircle', warning: 'alert', error: 'alert' };

export interface AlertProps {
  tone?: FeedbackTone;
  /** Kısa başlık: ne oldu? */
  title: string;
  /** Neden ve ne yapılabilir. */
  children?: ReactNode;
  /** Eylem alanı (en fazla iki buton). */
  actions?: ReactNode;
  /** Verilirse kapatma butonu gösterilir. */
  onDismiss?: () => void;
  /** inline: içerik içinde kart · banner: sayfa üstünde tam genişlik, kalıcı. */
  variant?: 'inline' | 'banner';
  icon?: IconName;
  className?: string;
}

/** Sayfa içi kalıcı mesaj. error ve warning `role="alert"` ile hemen duyurulur; info ve success `role="status"`.
 *  Tarayıcı tarzı modal uyarı kullanılmaz. */
export function Alert({ tone = 'info', title, children, actions, onDismiss, variant = 'inline', icon, className }: AlertProps) {
  const t = useStrings();
  const urgent = tone === 'error' || tone === 'warning';
  return (
    <div role={urgent ? 'alert' : 'status'} className={cx('dy-alert', `dy-alert--${tone}`, `dy-alert--${variant}`, className)}>
      <Icon name={icon ?? toneIcon[tone]} className="dy-alert__icon" />
      <div className="dy-alert__body">
        <p className="dy-alert__title">{title}</p>
        {children ? <div className="dy-alert__text">{children}</div> : null}
        {actions ? <div className="dy-alert__actions">{actions}</div> : null}
      </div>
      {onDismiss ? (
        <button type="button" className="dy-alert__close" aria-label={t('common.dismiss')} onClick={onDismiss}>
          <Icon name="x" size="sm" />
        </button>
      ) : null}
    </div>
  );
}

/** Sayfa üstünde kalıcı bildirim (çevrimdışı, eşitleme, bakım). Alert'in banner varyantıdır. */
export function Banner(props: Omit<AlertProps, 'variant'>) {
  return <Alert {...props} variant="banner" />;
}
