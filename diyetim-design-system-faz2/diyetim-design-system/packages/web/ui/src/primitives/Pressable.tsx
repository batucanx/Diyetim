import { forwardRef, useId, type ButtonHTMLAttributes, type MouseEvent } from 'react';
import type { ComponentState } from '@diyetim/tokens';
import { cx } from '../utils/cx';
import { interactionProps, isInert } from '../utils/state';

export interface PressableProps extends Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'disabled'> {
  /** enabled · disabled (şu an kullanılamaz) · locked (diyetisyenin tercihi) · loading. */
  state?: ComponentState;
  /** locked iken zorunlu: ekran okuyucuya ve yardım metnine giden neden. */
  lockedReason?: string;
}

/** Tüm basılabilir öğelerin tabanı: odak halkası, basma geri bildirimi, durum öznitelikleri.
 *  locked ve loading durumunda odaklanabilir kalır ama eylem tetiklenmez. */
export const Pressable = forwardRef<HTMLButtonElement, PressableProps>(function Pressable(
  { state = 'enabled', lockedReason, className, onClick, type = 'button', children, 'aria-describedby': describedBy, ...rest }, ref,
) {
  const reasonId = useId();
  const showReason = state === 'locked' && lockedReason;
  const handle = (e: MouseEvent<HTMLButtonElement>) => {
    if (isInert(state)) { e.preventDefault(); return; }
    onClick?.(e);
  };
  return (
    <button
      ref={ref}
      type={type}
      className={cx('dy-pressable', className)}
      onClick={handle}
      {...interactionProps(state, cx(describedBy, showReason && reasonId) || undefined)}
      {...rest}
    >
      {children}
      {showReason ? <span id={reasonId} className="dy-visually-hidden">{lockedReason}</span> : null}
    </button>
  );
});
