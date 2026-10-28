import { useState } from 'react';
import { cx } from '../utils/cx';
import { Icon } from '../primitives/Icon';
import { useStrings } from '../i18n/strings';

export type AvatarSize = 'sm' | 'md' | 'lg' | 'xl';

export interface AvatarProps {
  /** Tam ad: baş harfler ve erişilebilir ad buradan üretilir. */
  name: string;
  src?: string;
  size?: AvatarSize;
  /** Doğrulanmış diyetisyen rozeti. */
  verified?: boolean;
  /** Danışan durumu noktası: aktif · dikkat · pasif. Metinle de bildirilmelidir. */
  status?: 'active' | 'attention' | 'inactive';
  /** Dekoratif (yanında ad zaten yazılıysa). */
  decorative?: boolean;
  className?: string;
}

/** Türkçe baş harfler: "elif yıldız" → "EY", "İsmail" → "İ". */
export function initials(name: string) {
  return name.trim().split(/\s+/).filter(Boolean).slice(0, 2).map((p) => p.charAt(0).toLocaleUpperCase('tr-TR')).join('');
}

/** Kişi avatarı: fotoğraf, yüklenemezse baş harfler. */
export function Avatar({ name, src, size = 'md', verified, status, decorative, className }: AvatarProps) {
  const [failed, setFailed] = useState(false);
  const showImg = src && !failed;
  return (
    <span className={cx('dy-avatar', `dy-avatar--${size}`, className)} role={decorative ? undefined : 'img'} aria-label={decorative ? undefined : name} aria-hidden={decorative || undefined}>
      {showImg ? <img src={src} alt="" onError={() => setFailed(true)} /> : <span className="dy-avatar__initials" aria-hidden="true">{initials(name)}</span>}
      {verified ? <span className="dy-avatar__verified" aria-hidden="true"><Icon name="check" size="sm" /></span> : null}
      {status ? <span className={cx('dy-avatar__status', `dy-avatar__status--${status}`)} aria-hidden="true" /> : null}
    </span>
  );
}

/** Üst üste avatar grubu; max üzeri "+N". */
export function AvatarGroup({ people, max = 3, size = 'sm', label }: { people: ReadonlyArray<{ name: string; src?: string }>; max?: number; size?: AvatarSize; label: string }) {
  const t = useStrings();
  const shown = people.slice(0, max);
  const rest = people.length - shown.length;
  return (
    <span className="dy-avatar-group" role="group" aria-label={label}>
      {shown.map((p) => <Avatar key={p.name} name={p.name} src={p.src} size={size} />)}
      {rest > 0 ? <span className={cx('dy-avatar', `dy-avatar--${size}`, 'dy-avatar--more')} role="img" aria-label={t('avatar.more', { count: rest })}><span aria-hidden="true">+{rest}</span></span> : null}
    </span>
  );
}
