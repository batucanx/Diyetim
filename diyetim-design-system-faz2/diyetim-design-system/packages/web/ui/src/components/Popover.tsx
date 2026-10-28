import { cloneElement, useCallback, useId, useMemo, useRef, useState, type KeyboardEvent, type ReactElement, type ReactNode } from 'react';
import { cx } from '../utils/cx';
import { useDismiss, focusables } from '../utils/focus';
import { Icon, type IconName } from '../primitives/Icon';
import { trStartsWith } from '../utils/format';

type TriggerProps = { onClick?: (e: React.MouseEvent) => void; 'aria-expanded'?: boolean; 'aria-controls'?: string; 'aria-haspopup'?: string; onKeyDown?: (e: KeyboardEvent) => void; ref?: React.Ref<HTMLElement> };

export interface PopoverProps {
  /** Tetikleyici: tek bir buton. */
  trigger: ReactElement<TriggerProps>;
  /** Etkileşimli içerik (form, filtre). Modal değildir: arka plan kullanılabilir kalır. */
  children: ReactNode | ((close: () => void) => ReactNode);
  /** Erişilebilir ad (içerikte başlık yoksa). */
  label: string;
  align?: 'start' | 'end';
  className?: string;
}

/** Modal olmayan açılır panel. Escape ve dışarı tıklama kapatır; kapanınca odak tetikleyiciye döner. */
export function Popover({ trigger, children, label, align = 'start', className }: PopoverProps) {
  const [open, setOpen] = useState(false);
  const id = useId();
  const trig = useRef<HTMLElement | null>(null);
  const panel = useRef<HTMLDivElement>(null);
  const refs = useMemo(() => [trig, panel], []);
  const close = useCallback(() => { setOpen(false); trig.current?.focus(); }, []);
  useDismiss(open, refs, close);
  const t = cloneElement(trigger, {
    ref: (el: HTMLElement | null) => { trig.current = el; },
    'aria-expanded': open,
    'aria-controls': open ? id : undefined,
    'aria-haspopup': 'dialog',
    onClick: (e: React.MouseEvent) => {
      trigger.props.onClick?.(e);
      setOpen((o) => !o);
      requestAnimationFrame(() => { const p = panel.current; if (p) (focusables(p)[0] ?? p).focus(); });
    },
  });
  return (
    <span className="dy-popover-anchor">
      {t}
      {open ? (
        <div ref={panel} id={id} role="dialog" aria-label={label} tabIndex={-1} className={cx('dy-popover', 'dy-popover--floating', `dy-popover--${align}`, className)}>
          {typeof children === 'function' ? children(close) : children}
        </div>
      ) : null}
    </span>
  );
}

export interface MenuItem {
  id: string;
  label: string;
  icon?: IconName;
  /** Yıkıcı eylem (error rengi). */
  destructive?: boolean;
  disabled?: boolean;
  onSelect: () => void;
}

export interface MenuProps {
  trigger: ReactElement<TriggerProps>;
  items: ReadonlyArray<MenuItem>;
  label: string;
  align?: 'start' | 'end';
}

/** Eylem menüsü (APG menu button): ↓/↑ gezer, Home/End, Enter/Space seçer, Escape kapatır, harfle arama. */
export function Menu({ trigger, items, label, align = 'end' }: MenuProps) {
  const [open, setOpen] = useState(false);
  const [active, setActive] = useState(0);
  const id = useId();
  const trig = useRef<HTMLElement | null>(null);
  const panel = useRef<HTMLUListElement>(null);
  const refs = useMemo(() => [trig, panel], []);
  const enabled = items.map((it, i) => (it.disabled ? -1 : i)).filter((i) => i >= 0);
  const close = useCallback(() => { setOpen(false); trig.current?.focus(); }, []);
  useDismiss(open, refs as never, close);
  const openAt = (i: number) => { setActive(i); setOpen(true); requestAnimationFrame(() => panel.current?.focus()); };
  const select = (i: number) => { const it = items[i]; if (!it || it.disabled) return; close(); it.onSelect(); };
  const onTriggerKey = (e: KeyboardEvent) => {
    if (e.key === 'ArrowDown' || e.key === 'Enter' || e.key === ' ') { e.preventDefault(); openAt(enabled[0] ?? 0); }
    if (e.key === 'ArrowUp') { e.preventDefault(); openAt(enabled[enabled.length - 1] ?? 0); }
  };
  const onMenuKey = (e: KeyboardEvent) => {
    const pos = enabled.indexOf(active);
    const go = (i: number | undefined) => { if (i !== undefined) setActive(i); };
    switch (e.key) {
      case 'ArrowDown': e.preventDefault(); go(enabled[(pos + 1) % enabled.length]); break;
      case 'ArrowUp': e.preventDefault(); go(enabled[(pos - 1 + enabled.length) % enabled.length]); break;
      case 'Home': e.preventDefault(); go(enabled[0]); break;
      case 'End': e.preventDefault(); go(enabled[enabled.length - 1]); break;
      case 'Enter': case ' ': e.preventDefault(); select(active); break;
      case 'Tab': setOpen(false); break;
      default:
        if (e.key.length === 1) go(enabled.find((i) => trStartsWith(items[i].label, e.key)));
    }
  };
  const t = cloneElement(trigger, {
    ref: (el: HTMLElement | null) => { trig.current = el; },
    'aria-haspopup': 'menu',
    'aria-expanded': open,
    'aria-controls': open ? id : undefined,
    onClick: (e: React.MouseEvent) => { trigger.props.onClick?.(e); if (open) close(); else openAt(enabled[0] ?? 0); },
    onKeyDown: onTriggerKey,
  });
  return (
    <span className="dy-popover-anchor">
      {t}
      {open ? (
        <ul ref={panel} id={id} role="menu" aria-label={label} tabIndex={-1} aria-activedescendant={`${id}-${active}`} onKeyDown={onMenuKey}
          className={cx('dy-popover', 'dy-popover--floating', 'dy-menu', `dy-popover--${align}`)}>
          {items.map((it, i) => (
            <li key={it.id} id={`${id}-${i}`} role="menuitem" aria-disabled={it.disabled || undefined}
              className={cx('dy-menu__item', i === active && 'dy-menu__item--active', it.destructive && 'dy-menu__item--destructive', it.disabled && 'dy-menu__item--disabled')}
              onMouseMove={() => !it.disabled && setActive(i)} onMouseDown={(e) => e.preventDefault()} onClick={() => select(i)}>
              {it.icon ? <Icon name={it.icon} size="sm" /> : null}<span>{it.label}</span>
            </li>
          ))}
        </ul>
      ) : null}
    </span>
  );
}
