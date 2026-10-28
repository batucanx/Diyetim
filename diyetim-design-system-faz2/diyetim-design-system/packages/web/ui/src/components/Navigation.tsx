import type { ReactNode, MouseEvent } from 'react';
import { cx } from '../utils/cx';
import { Icon, type IconName } from '../primitives/Icon';
import { IconButton } from './Button';
import { Badge } from './Tag';
import { Tooltip } from './Tooltip';

export interface NavItem {
  id: string;
  label: string;
  icon: IconName;
  href?: string;
  /** Sayaç: onay kuyruğu, okunmamış not. */
  badge?: number;
  badgeLabel?: string;
}

interface NavProps {
  items: ReadonlyArray<NavItem>;
  activeId: string;
  /** Bağlantı yerine istemci tarafı yönlendirme için. */
  onNavigate?: (id: string, e: MouseEvent) => void;
}

/** Diyetisyen paneli kenar çubuğu (yalnızca web). Masaüstünde 264 px; `collapsed` iken 72 px ray ve tooltip'li ikonlar.
 *  Dar ekranda gizlenir; yerini AppBar menü butonu + BottomNavigation alır. */
export function Sidebar({ items, activeId, onNavigate, collapsed = false, header, footer, label = 'Ana gezinme' }: NavProps & {
  collapsed?: boolean;
  /** Klinik adı / logo alanı. */
  header?: ReactNode;
  footer?: ReactNode;
  label?: string;
}) {
  return (
    <nav aria-label={label} className={cx('dy-sidebar', collapsed && 'dy-sidebar--collapsed')}>
      {header ? <div className="dy-sidebar__header">{header}</div> : null}
      <ul className="dy-sidebar__list">
        {items.map((it) => {
          const on = it.id === activeId;
          const link = (
            <a href={it.href ?? '#'} aria-current={on ? 'page' : undefined} aria-label={collapsed ? it.label : undefined}
              className={cx('dy-sidebar__item', on && 'dy-sidebar__item--on')} onClick={(e) => { if (onNavigate) { e.preventDefault(); onNavigate(it.id, e); } }}>
              <Icon name={it.icon} size="md" />
              {!collapsed ? <span className="dy-sidebar__label">{it.label}</span> : null}
              {it.badge ? <Badge count={it.badge} label={it.badgeLabel ?? String(it.badge)} tone={on ? 'primary' : 'neutral'} className="dy-sidebar__badge" /> : null}
            </a>
          );
          return <li key={it.id}>{collapsed ? <Tooltip content={it.label} placement="bottom">{link}</Tooltip> : link}</li>;
        })}
      </ul>
      {footer ? <div className="dy-sidebar__footer">{footer}</div> : null}
    </nav>
  );
}

/** Panel üst çubuğu (masaüstü): sayfa başlığı, breadcrumb ve eylemler. */
export function TopBar({ title, breadcrumb, actions, children }: { title: string; breadcrumb?: ReactNode; actions?: ReactNode; children?: ReactNode }) {
  return (
    <header className="dy-topbar">
      <div className="dy-topbar__titles">
        {breadcrumb}
        <h1 className="dy-topbar__title">{title}</h1>
      </div>
      {children ? <div className="dy-topbar__center">{children}</div> : null}
      {actions ? <div className="dy-topbar__actions">{actions}</div> : null}
    </header>
  );
}

export interface BreadcrumbItem { label: string; href?: string; onClick?: () => void }

/** Konum izi. Son öğe geçerli sayfadır (aria-current). Dar ekranda yalnızca üst seviye gösterilir. */
export function Breadcrumb({ items, label = 'Konum' }: { items: ReadonlyArray<BreadcrumbItem>; label?: string }) {
  return (
    <nav aria-label={label} className="dy-breadcrumb">
      <ol>
        {items.map((it, i) => {
          const last = i === items.length - 1;
          return (
            <li key={`${it.label}-${i}`} className={cx(!last && i < items.length - 2 && 'dy-breadcrumb__far')}>
              {last ? <span aria-current="page">{it.label}</span> : <a href={it.href ?? '#'} onClick={(e) => { if (it.onClick) { e.preventDefault(); it.onClick(); } }}>{it.label}</a>}
              {!last ? <Icon name="chevronRight" size="sm" className="dy-breadcrumb__sep" /> : null}
            </li>
          );
        })}
      </ol>
    </nav>
  );
}

/** Dar ekran (mobil tarayıcı) üst çubuğu: geri veya menü, başlık, eylemler. */
export function AppBar({ title, onBack, backLabel = 'Geri', onMenu, menuLabel = 'Menüyü aç', actions }: {
  title: string; onBack?: () => void; backLabel?: string; onMenu?: () => void; menuLabel?: string; actions?: ReactNode;
}) {
  return (
    <header className="dy-appbar">
      {onBack ? <IconButton icon="chevronLeft" label={backLabel} onClick={onBack} /> : onMenu ? <IconButton icon="menu" label={menuLabel} onClick={onMenu} /> : <span className="dy-appbar__spacer" />}
      <h1 className="dy-appbar__title">{title}</h1>
      <div className="dy-appbar__actions">{actions}</div>
    </header>
  );
}

/** Alt gezinme (dar ekran): 3–5 hedef, yüzen kapsül. Opsiyonel orta eylem (ör. hızlı onay). */
export function BottomNavigation({ items, activeId, onNavigate, label = 'Ana gezinme', centerAction }: NavProps & {
  label?: string;
  centerAction?: { icon: IconName; label: string; onClick: () => void };
}) {
  const half = Math.ceil(items.length / 2);
  const render = (it: NavItem) => {
    const on = it.id === activeId;
    return (
      <li key={it.id}>
        <a href={it.href ?? '#'} aria-current={on ? 'page' : undefined} className={cx('dy-bottomnav__item', on && 'dy-bottomnav__item--on')}
          onClick={(e) => { if (onNavigate) { e.preventDefault(); onNavigate(it.id, e); } }}>
          <span className="dy-bottomnav__icon"><Icon name={it.icon} size="lg" />{it.badge ? <Badge count={it.badge} label={it.badgeLabel ?? String(it.badge)} tone="error" className="dy-bottomnav__badge" /> : null}</span>
          <span className="dy-bottomnav__label">{it.label}</span>
        </a>
      </li>
    );
  };
  return (
    <nav aria-label={label} className="dy-bottomnav">
      <ul>
        {items.slice(0, centerAction ? half : items.length).map(render)}
        {centerAction ? (
          <li><button type="button" className="dy-bottomnav__cta" aria-label={centerAction.label} onClick={centerAction.onClick}><Icon name={centerAction.icon} size="lg" /></button></li>
        ) : null}
        {centerAction ? items.slice(half).map(render) : null}
      </ul>
    </nav>
  );
}
