import { cloneElement, useEffect, useId, useRef, useState, type ReactElement, type FocusEvent, type MouseEvent } from 'react';
import { cx } from '../utils/cx';

export interface TooltipProps {
  /** Kısa açıklama (tek satır, 80 karakteri geçmemeli). Zorunlu bilgi tooltip'e konmaz. */
  content: string;
  /** Tek bir odaklanabilir öğe (buton, ikon buton). */
  children: ReactElement<Record<string, unknown>>;
  placement?: 'top' | 'bottom';
  /** Fareyle gösterme gecikmesi (ms). Klavye odağında anında. */
  delay?: number;
}

/** Fareyle üzerine gelince veya klavyeyle odaklanınca kısa açıklama gösterir; Escape kapatır.
 *  Açıklama tetikleyiciye aria-describedby ile bağlanır. Dokunmatikte gösterilmez: bilgi başka yerde de bulunmalı. */
export function Tooltip({ content, children, placement = 'top', delay = 400 }: TooltipProps) {
  const id = useId();
  const [open, setOpen] = useState(false);
  const timer = useRef<ReturnType<typeof setTimeout>>(undefined);
  useEffect(() => {
    if (!open) return;
    const esc = (e: KeyboardEvent) => { if (e.key === 'Escape') setOpen(false); };
    document.addEventListener('keydown', esc);
    return () => document.removeEventListener('keydown', esc);
  }, [open]);
  useEffect(() => () => clearTimeout(timer.current), []);
  const props = children.props as { onMouseEnter?: (e: MouseEvent) => void; onMouseLeave?: (e: MouseEvent) => void; onFocus?: (e: FocusEvent) => void; onBlur?: (e: FocusEvent) => void; 'aria-describedby'?: string };
  const trigger = cloneElement(children, {
    'aria-describedby': cx(props['aria-describedby'], id),
    onMouseEnter: (e: MouseEvent) => { props.onMouseEnter?.(e); clearTimeout(timer.current); timer.current = setTimeout(() => setOpen(true), delay); },
    onMouseLeave: (e: MouseEvent) => { props.onMouseLeave?.(e); clearTimeout(timer.current); setOpen(false); },
    onFocus: (e: FocusEvent) => { props.onFocus?.(e); setOpen(true); },
    onBlur: (e: FocusEvent) => { props.onBlur?.(e); setOpen(false); },
  });
  return (
    <span className="dy-tooltip-anchor">
      {trigger}
      <span id={id} role="tooltip" className={cx('dy-tooltip', `dy-tooltip--${placement}`, open && 'dy-tooltip--open')} hidden={!open}>{content}</span>
    </span>
  );
}
