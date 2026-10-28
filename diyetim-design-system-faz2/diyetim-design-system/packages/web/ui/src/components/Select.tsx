import { useEffect, useId, useMemo, useRef, useState, type KeyboardEvent } from 'react';
import { cx } from '../utils/cx';
import { Icon } from '../primitives/Icon';
import { FieldShell, type FieldBaseProps } from './Field';
import { useControllable } from '../utils/useControllable';
import { trStartsWith } from '../utils/format';

export interface SelectOption<V extends string = string> {
  value: V;
  label: string;
  description?: string;
  disabled?: boolean;
}

interface ListboxCore<V extends string> extends FieldBaseProps {
  options: ReadonlyArray<SelectOption<V>>;
  placeholder?: string;
  /** Liste boşken gösterilen metin. */
  emptyText?: string;
  className?: string;
  name?: string;
}

export interface SelectProps<V extends string = string> extends ListboxCore<V> {
  value?: V | null;
  defaultValue?: V | null;
  onChange?: (value: V | null) => void;
}

export interface MultiSelectProps<V extends string = string> extends ListboxCore<V> {
  value?: V[];
  defaultValue?: V[];
  onChange?: (value: V[]) => void;
  /** Seçim özeti; varsayılan: 1–2 seçimde etiketler, daha fazlasında "N seçili". */
  summary?: (selected: SelectOption<V>[]) => string;
}

function useListbox<V extends string>(options: ReadonlyArray<SelectOption<V>>, multiple: boolean, isSelected: (v: V) => boolean, choose: (v: V) => void, editable: boolean) {
  const [open, setOpen] = useState(false);
  const [active, setActive] = useState(-1);
  const typed = useRef({ text: '', at: 0 });
  const enabledIdx = useMemo(() => options.map((o, i) => (o.disabled ? -1 : i)).filter((i) => i >= 0), [options]);

  const openAt = (preferSelected = true) => {
    if (!editable) return;
    const sel = preferSelected ? options.findIndex((o) => isSelected(o.value)) : -1;
    setActive(sel >= 0 ? sel : enabledIdx[0] ?? -1);
    setOpen(true);
  };
  const move = (delta: number) => {
    const pos = enabledIdx.indexOf(active);
    const next = enabledIdx[Math.max(0, Math.min(enabledIdx.length - 1, (pos < 0 ? -1 : pos) + delta))];
    if (next !== undefined) setActive(next);
  };
  const resetTypeahead = () => { typed.current = { text: '', at: 0 }; };
  const commit = (i: number) => {
    resetTypeahead();
    const o = options[i];
    if (!o || o.disabled) return;
    choose(o.value);
    if (!multiple) setOpen(false);
  };
  const typeahead = (ch: string) => {
    const now = Date.now();
    typed.current.text = now - typed.current.at > 700 ? ch : typed.current.text + ch;
    typed.current.at = now;
    const start = open ? active + 1 : 0;
    const order = [...enabledIdx.filter((i) => i >= start), ...enabledIdx.filter((i) => i < start)];
    const hit = order.find((i) => trStartsWith(options[i].label, typed.current.text));
    if (hit !== undefined) { setActive(hit); if (!open) { setOpen(true); } }
  };
  const onKeyDown = (e: KeyboardEvent<HTMLElement>) => {
    if (!editable) return;
    if (e.key.length === 1 && e.key !== ' ' && !e.ctrlKey && !e.metaKey && !e.altKey) { typeahead(e.key); return; }
    resetTypeahead();
    switch (e.key) {
      case 'ArrowDown': e.preventDefault(); if (!open) openAt(); else move(1); break;
      case 'ArrowUp': e.preventDefault(); if (!open) openAt(); else move(-1); break;
      case 'Home': if (open) { e.preventDefault(); setActive(enabledIdx[0] ?? -1); } break;
      case 'End': if (open) { e.preventDefault(); setActive(enabledIdx[enabledIdx.length - 1] ?? -1); } break;
      case 'Enter': case ' ':
        e.preventDefault();
        if (!open) openAt(); else if (active >= 0) commit(active);
        break;
      case 'Escape': if (open) { e.preventDefault(); setOpen(false); } break;
      case 'Tab': if (open && !multiple && active >= 0) commit(active); setOpen(false); break;
    }
  };
  return { open, setOpen, active, setActive, openAt, commit, onKeyDown };
}

function Listbox<V extends string>({ id, labelId, options, multiple, isSelected, active, setActive, commit, emptyText }: {
  id: string; labelId: string; options: ReadonlyArray<SelectOption<V>>; multiple: boolean; isSelected: (v: V) => boolean;
  active: number; setActive: (i: number) => void; commit: (i: number) => void; emptyText: string;
}) {
  const ref = useRef<HTMLUListElement>(null);
  useEffect(() => {
    const el = ref.current?.querySelector<HTMLElement>(`[data-index="${active}"]`);
    el?.scrollIntoView?.({ block: 'nearest' });
  }, [active]);
  return (
    <ul ref={ref} id={id} role="listbox" aria-labelledby={labelId} aria-multiselectable={multiple || undefined} className="dy-listbox" tabIndex={-1}>
      {options.length === 0 ? <li className="dy-listbox__empty" role="presentation">{emptyText}</li> : null}
      {options.map((o, i) => {
        const sel = isSelected(o.value);
        return (
          <li
            key={o.value}
            id={`${id}-opt-${i}`}
            data-index={i}
            role="option"
            aria-selected={sel}
            aria-disabled={o.disabled || undefined}
            className={cx('dy-listbox__option', i === active && 'dy-listbox__option--active', sel && 'dy-listbox__option--selected', o.disabled && 'dy-listbox__option--disabled')}
            onMouseMove={() => !o.disabled && setActive(i)}
            onMouseDown={(e) => e.preventDefault()}
            onClick={() => commit(i)}
          >
            {multiple ? <span className={cx('dy-check', sel && 'dy-check--on')} aria-hidden="true">{sel ? <Icon name="check" size="sm" /> : null}</span> : null}
            <span className="dy-listbox__text">
              <span className="dy-listbox__label">{o.label}</span>
              {o.description ? <span className="dy-listbox__desc">{o.description}</span> : null}
            </span>
            {!multiple && sel ? <Icon name="check" size="sm" className="dy-listbox__tick" /> : null}
          </li>
        );
      })}
    </ul>
  );
}

function SelectBase<V extends string>(props: ListboxCore<V> & {
  multiple: boolean; isSelected: (v: V) => boolean; choose: (v: V) => void; display: string | null; hiddenValue: string;
}) {
  const { label, hideLabel, description, error, success, state = 'enabled', lockedReason, required, options, placeholder = 'Seçin',
    emptyText = 'Seçenek yok', className, name, multiple, isSelected, choose, display } = props;
  const editable = state === 'enabled';
  const lb = useListbox(options, multiple, isSelected, choose, editable);
  const listId = useId();
  const wrap = useRef<HTMLDivElement>(null);
  useEffect(() => {
    if (!lb.open) return;
    const close = (e: MouseEvent) => { if (!wrap.current?.contains(e.target as Node)) lb.setOpen(false); };
    document.addEventListener('mousedown', close);
    return () => document.removeEventListener('mousedown', close);
  }, [lb.open]);
  return (
    <FieldShell {...{ label, hideLabel, description, error, success, state, lockedReason, required, className }} labelAs="span">
      {({ inputId, labelId, describedBy, invalid }) => (
        <div className="dy-select" ref={wrap}>
          <button
            type="button"
            id={inputId}
            role="combobox"
            aria-haspopup="listbox"
            aria-expanded={lb.open}
            aria-controls={lb.open ? listId : undefined}
            aria-labelledby={`${labelId} ${inputId}`}
            aria-activedescendant={lb.open && lb.active >= 0 ? `${listId}-opt-${lb.active}` : undefined}
            aria-describedby={describedBy}
            aria-invalid={invalid || undefined}
            aria-required={required || undefined}
            aria-disabled={state === 'locked' || state === 'loading' || undefined}
            aria-busy={state === 'loading' || undefined}
            disabled={state === 'disabled'}
            className={cx('dy-input', 'dy-select__trigger', invalid && 'dy-input--invalid', `dy-input--${state}`, lb.open && 'dy-select__trigger--open')}
            onClick={() => (lb.open ? lb.setOpen(false) : lb.openAt())}
            onKeyDown={lb.onKeyDown}
          >
            {state === 'locked' ? <Icon name="lock" size="sm" className="dy-input__icon" /> : null}
            <span className={cx('dy-select__value', !display && 'dy-select__placeholder')}>{display ?? placeholder}</span>
            <Icon name="chevronDown" size="sm" className="dy-select__chevron" />
            {state === 'loading' ? <span className="dy-input__progress" aria-hidden="true" /> : null}
          </button>
          {name ? <input type="hidden" name={name} value={props.hiddenValue} /> : null}
          {lb.open ? (
            <div className="dy-popover dy-select__popover">
              <Listbox id={listId} labelId={labelId} options={options} multiple={multiple} isSelected={isSelected}
                active={lb.active} setActive={lb.setActive} commit={lb.commit} emptyText={emptyText} />
            </div>
          ) : null}
        </div>
      )}
    </FieldShell>
  );
}

/** Tek seçim listesi (APG select-only combobox): ok tuşları, Home/End, Enter/Space, Escape, Türkçe yazarak arama. */
export function Select<V extends string = string>({ value, defaultValue = null, onChange, ...rest }: SelectProps<V>) {
  const [v, setV] = useControllable<V | null>(value, defaultValue, onChange);
  const selected = rest.options.find((o) => o.value === v) ?? null;
  return <SelectBase<V> {...rest} multiple={false} isSelected={(x) => x === v} choose={(x) => setV(x)} display={selected?.label ?? null} hiddenValue={v ?? ''} />;
}

/** Çoklu seçim listesi: Enter/Space seçimi değiştirir, liste açık kalır; Escape kapatır. */
export function MultiSelect<V extends string = string>({ value, defaultValue = [], onChange, summary, ...rest }: MultiSelectProps<V>) {
  const [v, setV] = useControllable<V[]>(value, defaultValue, onChange);
  const selected = rest.options.filter((o) => v.includes(o.value));
  const display = selected.length === 0 ? null : summary ? summary(selected)
    : selected.length <= 2 ? selected.map((o) => o.label).join(', ') : `${selected.length} seçili`;
  const toggle = (x: V) => setV(v.includes(x) ? v.filter((y) => y !== x) : [...v, x]);
  return <SelectBase<V> {...rest} multiple isSelected={(x) => v.includes(x)} choose={toggle} display={display} hiddenValue={v.join(',')} />;
}
