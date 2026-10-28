import { cx } from '../utils/cx';
import { Icon } from '../primitives/Icon';
import { formatNumber } from '../utils/format';
import { useStrings } from '../i18n/strings';

/** Sayfa numaraları: 1 … 4 5 6 … 12 */
export function pageWindow(page: number, count: number): Array<number | 'gap'> {
  if (count <= 7) return Array.from({ length: count }, (_, i) => i + 1);
  const out: Array<number | 'gap'> = [1];
  const start = Math.max(2, page - 1), end = Math.min(count - 1, page + 1);
  if (start > 2) out.push('gap');
  for (let i = start; i <= end; i++) out.push(i);
  if (end < count - 1) out.push('gap');
  out.push(count);
  return out;
}

export interface PaginationProps {
  page: number;
  pageCount: number;
  onChange: (page: number) => void;
  label?: string;
  /** "1–20 / 248 danışan" gibi özet. */
  summary?: string;
}

/** Sayfalama. Dar ekranda yalnızca önceki/sonraki ve "4 / 12". */
export function Pagination({ page, pageCount, onChange, label, summary }: PaginationProps) {
  const t = useStrings();
  if (pageCount <= 1) return summary ? <p className="dy-pagination__summary">{summary}</p> : null;
  return (
    <nav aria-label={label ?? t('pagination.label')} className="dy-pagination">
      {summary ? <p className="dy-pagination__summary">{summary}</p> : null}
      <ul>
        <li><button type="button" className="dy-pagination__btn" aria-label={t('pagination.previous')} disabled={page <= 1} onClick={() => onChange(page - 1)}><Icon name="chevronLeft" size="sm" /></button></li>
        {pageWindow(page, pageCount).map((p, i) => p === 'gap'
          ? <li key={`g${i}`} className="dy-pagination__gap" aria-hidden="true">…</li>
          : <li key={p} className="dy-pagination__page"><button type="button" className={cx('dy-pagination__btn', p === page && 'dy-pagination__btn--on')} aria-current={p === page ? 'page' : undefined} aria-label={t('pagination.page', { page: p })} onClick={() => onChange(p)}>{formatNumber(p)}</button></li>)}
        <li className="dy-pagination__compact" aria-hidden="true">{formatNumber(page)} / {formatNumber(pageCount)}</li>
        <li><button type="button" className="dy-pagination__btn" aria-label={t('pagination.next')} disabled={page >= pageCount} onClick={() => onChange(page + 1)}><Icon name="chevronRight" size="sm" /></button></li>
      </ul>
    </nav>
  );
}
