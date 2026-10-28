import { useMemo, type ReactNode } from 'react';
import { cx } from '../utils/cx';
import { Icon } from '../primitives/Icon';
import { Checkbox } from './Checkbox';
import { Skeleton } from '../primitives/Skeleton';
import { EmptyState, ErrorState } from './States';
import type { ErrorKind } from '@diyetim/tokens';
import { useStrings } from '../i18n/strings';

export interface Column<R> {
  key: string;
  header: string;
  /** Hücre içeriği. Verilmezse row[key]. */
  cell?: (row: R) => ReactNode;
  align?: 'start' | 'end';
  /** Sayısal sütun: sağa hizalı, sabit genişlikli rakam. */
  numeric?: boolean;
  sortable?: boolean;
  /** Dar ekranda kart görünümünde gizlenir (öncelikli olmayan sütun). */
  hideOnCompact?: boolean;
  width?: string;
}

export type SortState = { key: string; direction: 'ascending' | 'descending' } | null;

export interface DataTableProps<R> {
  /** Tablonun erişilebilir adı (caption). */
  caption: string;
  /** Başlığı görsel olarak gizle (sayfa başlığı zaten varsa). */
  hideCaption?: boolean;
  columns: ReadonlyArray<Column<R>>;
  rows: ReadonlyArray<R>;
  rowKey: (row: R) => string;
  /** Satıra dokununca (danışan detayına git). Satır içinde başka etkileşimli öğe varsa kullanılmaz. */
  onRowClick?: (row: R) => void;
  rowLabel?: (row: R) => string;
  sort?: SortState;
  onSortChange?: (s: SortState) => void;
  /** Satır seçimi (toplu işlem). */
  selected?: ReadonlySet<string>;
  onSelectedChange?: (s: Set<string>) => void;
  state?: 'ready' | 'loading' | 'error';
  errorKind?: ErrorKind;
  onRetry?: () => void;
  empty?: { title: string; description?: string; action?: ReactNode };
  density?: 'comfortable' | 'compact';
  className?: string;
}

/** Panel veri tablosu temeli: sıralama (aria-sort), satır seçimi, yükleme/boş/hata durumları ve dar ekranda kart listesi.
 *  Sanal kaydırma, sütun yeniden boyutlandırma ve sunucu taraflı filtre bu temelde yok (Faz 3/4). */
export function DataTable<R>({
  caption, hideCaption, columns, rows, rowKey, onRowClick, rowLabel, sort, onSortChange, selected, onSelectedChange, state = 'ready', errorKind = 'server', onRetry, empty,
  density = 'comfortable', className,
}: DataTableProps<R>) {
  const t = useStrings();
  const selectable = !!onSelectedChange;
  const allKeys = useMemo(() => rows.map(rowKey), [rows, rowKey]);
  const allOn = selectable && allKeys.length > 0 && allKeys.every((k) => selected?.has(k));
  const someOn = selectable && !allOn && allKeys.some((k) => selected?.has(k));
  const toggleAll = () => onSelectedChange?.(allOn ? new Set() : new Set(allKeys));
  const toggle = (k: string) => { const s = new Set(selected); if (s.has(k)) s.delete(k); else s.add(k); onSelectedChange?.(s); };
  const sortBy = (key: string) => onSortChange?.(sort?.key === key ? (sort.direction === 'ascending' ? { key, direction: 'descending' } : null) : { key, direction: 'ascending' });
  const value = (r: R, c: Column<R>) => (c.cell ? c.cell(r) : String((r as Record<string, unknown>)[c.key] ?? ''));

  if (state === 'error') return <div className={cx('dy-table-wrap', className)}><ErrorState kind={errorKind} onAction={onRetry} size="compact" headingLevel={3} /></div>;

  return (
    <div className={cx('dy-table-wrap', `dy-table--${density}`, className)} aria-busy={state === 'loading'}>
      <table className="dy-table">
        <caption className={cx('dy-table__caption', hideCaption && 'dy-visually-hidden')}>{caption}</caption>
        <thead>
          <tr>
            {selectable ? (
              <th scope="col" className="dy-table__select">
                <Checkbox label={<span className="dy-visually-hidden">{t('table.selectAll')}</span>} checked={allOn} indeterminate={someOn} onChange={toggleAll} />
              </th>
            ) : null}
            {columns.map((c) => (
              <th key={c.key} scope="col" style={{ width: c.width }} aria-sort={sort?.key === c.key ? sort.direction : c.sortable ? 'none' : undefined}
                className={cx(c.numeric || c.align === 'end' ? 'dy-table__end' : undefined, c.hideOnCompact && 'dy-table__optional')}>
                {c.sortable ? (
                  <button type="button" className="dy-table__sort" onClick={() => sortBy(c.key)}>
                    {c.header}
                    <Icon name={sort?.key === c.key ? (sort.direction === 'ascending' ? 'arrowUp' : 'arrowDown') : 'chevronDown'} size="sm" className={cx(sort?.key !== c.key && 'dy-table__sort-idle')} />
                  </button>
                ) : c.header}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {state === 'loading'
            ? Array.from({ length: 4 }, (_, i) => (
                <tr key={`sk-${i}`} aria-hidden="true">
                  {selectable ? <td className="dy-table__select" /> : null}
                  {columns.map((c, ci) => <td key={c.key} className={cx('dy-table__loading', ci === 0 && 'dy-table__primary', c.hideOnCompact && 'dy-table__optional')}><Skeleton shape="text" /></td>)}
                </tr>
              ))
            : rows.map((r) => {
                const k = rowKey(r);
                const on = selected?.has(k) ?? false;
                return (
                  <tr key={k} className={cx(onRowClick && 'dy-table__row--interactive', on && 'dy-table__row--selected')} aria-selected={selectable ? on : undefined}>
                    {selectable ? <td className="dy-table__select"><Checkbox label={<span className="dy-visually-hidden">{t('table.selectRow', { row: rowLabel?.(r) ?? k })}</span>} checked={on} onChange={() => toggle(k)} /></td> : null}
                    {columns.map((c, ci) => (
                      <td key={c.key} data-label={c.header} className={cx(ci === 0 && 'dy-table__primary', (c.numeric || c.align === 'end') && 'dy-table__end', c.numeric && 'dy-table__numeric', c.hideOnCompact && 'dy-table__optional')}>
                        {ci === 0 && onRowClick ? <button type="button" className="dy-table__rowlink" onClick={() => onRowClick(r)}>{value(r, c)}</button> : value(r, c)}
                      </td>
                    ))}
                  </tr>
                );
              })}
        </tbody>
      </table>
      {state === 'ready' && rows.length === 0 && empty ? <EmptyState size="compact" headingLevel={3} title={empty.title} description={empty.description} action={empty.action} /> : null}
    </div>
  );
}
