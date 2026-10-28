import type { CSSProperties } from 'react';
import type { RadiusToken } from '@diyetim/tokens';
import { cx } from '../utils/cx';

export interface SkeletonProps {
  /** text: metin satırları · rect: kutu · circle: avatar. */
  shape?: 'text' | 'rect' | 'circle';
  /** CSS uzunluğu ("100%", "var(--size-control-lg)"). Gerçek component ile aynı ölçü verilmeli. */
  width?: string;
  height?: string;
  /** shape=text iken satır sayısı; son satır kısa çizilir. */
  lines?: number;
  radius?: RadiusToken;
  className?: string;
}

/** Yüklenen içeriğin yerini birebir ölçüyle tutar; layout kaymaz. Ekran okuyucudan gizlidir;
 *  yükleme durumunu taşıyan kapsayıcıya aria-busy verilir. Hareketi azalt ayarında shimmer durur. */
export function Skeleton({ shape = 'rect', width, height, lines = 1, radius, className }: SkeletonProps) {
  if (shape === 'text') {
    return (
      <span aria-hidden="true" className={cx('dy-skeleton-lines', className)} style={{ width }}>
        {Array.from({ length: lines }, (_, i) => (
          <span key={i} className="dy-skeleton dy-skeleton--text" style={{ width: lines > 1 && i === lines - 1 ? '60%' : '100%' }} />
        ))}
      </span>
    );
  }
  const style: CSSProperties = { width, height };
  return <span aria-hidden="true" className={cx('dy-skeleton', `dy-skeleton--${shape}`, radius && `dy-radius--${radius}`, className)} style={style} />;
}
