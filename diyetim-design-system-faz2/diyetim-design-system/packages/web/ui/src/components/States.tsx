import type { ReactNode } from 'react';
import type { ErrorKind } from '@diyetim/tokens';
import { cx } from '../utils/cx';
import { Icon, type IconName } from '../primitives/Icon';
import { Button } from './Button';
import { useStrings, type StringKey } from '../i18n/strings';
import { Alert } from './Alert';

export interface EmptyStateProps {
  icon?: IconName;
  /** Ne oldu? ("Bugün için öğün yok") */
  title: string;
  /** Neden boş ve şimdi ne yapılabilir? */
  description?: string;
  /** Tek birincil eylem (ve en fazla bir ikincil). */
  action?: ReactNode;
  secondaryAction?: ReactNode;
  /** compact: kart içi · page: sayfanın tamamı. */
  size?: 'compact' | 'page';
  /** Başlık düzeyi; sayfa yapısına uymalı. Varsayılan 2. */
  headingLevel?: 2 | 3 | 4;
  className?: string;
}

/** Boş durum: büyük illüstrasyon yerine küçük ikon, kısa başlık, açıklama ve tek eylem. */
export function EmptyState({ icon = 'inbox', title, description, action, secondaryAction, size = 'page', headingLevel = 2, className }: EmptyStateProps) {
  const H = `h${headingLevel}` as const;
  return (
    <section className={cx('dy-state', `dy-state--${size}`, className)} aria-label={title}>
      <span className="dy-state__icon" aria-hidden="true"><Icon name={icon} size="lg" /></span>
      <H className="dy-state__title">{title}</H>
      {description ? <p className="dy-state__text">{description}</p> : null}
      {action || secondaryAction ? <div className="dy-state__actions">{action}{secondaryAction}</div> : null}
    </section>
  );
}

const errorIcon: Record<ErrorKind, IconName> = { network: 'wifiOff', server: 'alert', permission: 'lock', timeout: 'clock', processing: 'file', 'not-found': 'search' };

export interface ErrorStateProps {
  kind: ErrorKind;
  /** Varsayılan metinleri geçersiz kılar. */
  title?: string;
  description?: string;
  /** Birincil eylem (tekrar dene / geri dön). Verilmezse buton gösterilmez. */
  onAction?: () => void;
  actionLabel?: string;
  /** Eylem sürerken (tekrar deneniyor). */
  retrying?: boolean;
  size?: 'compact' | 'page';
  headingLevel?: 2 | 3 | 4;
  className?: string;
}

/** Hata durumu: sakin, sorumluluk alan dil; teknik kod gösterilmez; her zaman bir yol sunar.
 *  Duyuru `role="alert"` ile; odak taşınmaz. */
export function ErrorState({ kind, title, description, onAction, actionLabel, retrying, size = 'page', headingLevel = 2, className }: ErrorStateProps) {
  const t = useStrings();
  const H = `h${headingLevel}` as const;
  const k = (s: 'title' | 'description' | 'action') => t(`error.${kind}.${s}` as StringKey);
  return (
    <section className={cx('dy-state', 'dy-state--error', `dy-state--${size}`, className)} role="alert" data-kind={kind}>
      <span className="dy-state__icon" aria-hidden="true"><Icon name={errorIcon[kind]} size="lg" /></span>
      <H className="dy-state__title">{title ?? k('title')}</H>
      <p className="dy-state__text">{description ?? k('description')}</p>
      {onAction ? (
        <div className="dy-state__actions">
          <Button variant={kind === 'permission' || kind === 'not-found' ? 'tertiary' : 'primary'} state={retrying ? 'loading' : 'enabled'} onClick={onAction}>
            {actionLabel ?? k('action')}
          </Button>
        </div>
      ) : null}
    </section>
  );
}

export interface OfflineStateProps {
  /** Gönderilmeyi bekleyen değişiklik sayısı. */
  pendingCount?: number;
  onRetry?: () => void;
  retrying?: boolean;
  className?: string;
}

/** Çevrimdışı bildirimi (banner). Girilen veriler kaybolmaz; bekleyen değişiklik sayısı gösterilir. */
export function OfflineState({ pendingCount = 0, onRetry, retrying, className }: OfflineStateProps) {
  const t = useStrings();
  return (
    <Alert
      variant="banner"
      tone="warning"
      icon="wifiOff"
      title={t('offline.title')}
      className={cx('dy-offline', className)}
      actions={onRetry ? <Button size="sm" variant="tertiary" state={retrying ? 'loading' : 'enabled'} onClick={onRetry}>{t('offline.retry')}</Button> : undefined}
    >
      {t('offline.description')}
      {pendingCount > 0 ? <> {t('offline.pending', { count: pendingCount })}.</> : null}
    </Alert>
  );
}

export interface LoadingRegionProps {
  loading: boolean;
  /** Yüklenirken gösterilecek iskelet (gerçek içerikle aynı ölçü). */
  skeleton: ReactNode;
  children: ReactNode;
  /** Ekran okuyucu bağlamı, ör. "Öğünler". */
  label: string;
  className?: string;
}

/** Yükleme sırasında iskeleti gösterir, `aria-busy` yönetir; yükleme bitince ekran okuyucuya kısa bildirim yapar. */
export function LoadingRegion({ loading, skeleton, children, label, className }: LoadingRegionProps) {
  const t = useStrings();
  return (
    <div className={cx('dy-loading-region', className)} aria-busy={loading} aria-label={label} role="region">
      <span className="dy-visually-hidden" aria-live="polite">{loading ? `${label}: ${t('common.loading')}` : ''}</span>
      {loading ? skeleton : children}
    </div>
  );
}
