import type { ReactNode } from 'react';
import { cx } from '../utils/cx';
import { Chip } from './Chip';
import { SearchField } from './TextField';
import { Button } from './Button';
import { useStrings } from '../i18n/strings';

export interface FilterOption { value: string; label: string; count?: number }

export interface FilterBarProps {
  /** Arama alanı (opsiyonel). */
  search?: { label: string; value: string; onChange: (v: string) => void; placeholder?: string };
  /** Hızlı filtre çipleri (çoklu seçim). */
  filters?: { label: string; options: ReadonlyArray<FilterOption>; value: ReadonlyArray<string>; onChange: (v: string[]) => void };
  /** Ek kontroller (Select, Popover filtre). */
  extra?: ReactNode;
  /** Etkin filtre varken "Temizle". */
  onClearAll?: () => void;
  /** Sonuç sayısı duyurusu: "24 danışan". */
  resultText?: string;
  className?: string;
}

/** Liste ve tablo üstü filtre çubuğu. Sonuç sayısı canlı bölgede duyurulur. */
export function FilterBar({ search, filters, extra, onClearAll, resultText, className }: FilterBarProps) {
  const t = useStrings();
  const active = (filters?.value.length ?? 0) > 0 || !!search?.value;
  return (
    <div className={cx('dy-filterbar', className)} role="search">
      {search ? <SearchField label={search.label} hideLabel value={search.value} onChange={search.onChange} placeholder={search.placeholder} className="dy-filterbar__search" /> : null}
      {filters ? (
        <div className="dy-filterbar__chips" role="group" aria-label={filters.label}>
          {filters.options.map((o) => {
            const on = filters.value.includes(o.value);
            return (
              <Chip key={o.value} selected={on} removable onClick={() => filters.onChange(on ? filters.value.filter((x) => x !== o.value) : [...filters.value, o.value])}>
                {o.label}{o.count !== undefined ? <span className="dy-chip__count"> {o.count}</span> : null}
              </Chip>
            );
          })}
        </div>
      ) : null}
      {extra}
      {active && onClearAll ? <Button variant="ghost" size="sm" onClick={onClearAll}>{t('filter.clearAll')}</Button> : null}
      {resultText !== undefined ? <p className="dy-filterbar__result" aria-live="polite">{resultText}</p> : null}
    </div>
  );
}
