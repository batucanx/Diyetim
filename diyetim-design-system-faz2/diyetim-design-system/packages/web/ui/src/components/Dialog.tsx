import { useEffect, useId, useRef, type ReactNode } from 'react';
import { createPortal } from 'react-dom';
import { cx } from '../utils/cx';
import { useModalFocus } from '../utils/focus';
import { Icon } from '../primitives/Icon';
import { Button } from './Button';
import { useStrings } from '../i18n/strings';

export interface DialogProps {
  open: boolean;
  /** Escape, arka plan tıklaması veya kapat butonu. */
  onClose: () => void;
  title: string;
  /** Kısa açıklama; aria-describedby ile bağlanır. */
  description?: string;
  children?: ReactNode;
  /** Alt eylem alanı. Birincil eylem sağda (mobilde üstte). */
  footer?: ReactNode;
  /** Mobilde (compact) alttan açılan sayfa görünümü. Varsayılan true. */
  sheetOnCompact?: boolean;
  /** Arka plana tıklayınca kapanmasın (kaydedilmemiş form). */
  dismissible?: boolean;
  /** İlk odaklanacak öğe; verilmezse ilk odaklanabilir öğe. Yıkıcı onaylarda "Vazgeç". */
  initialFocusRef?: React.RefObject<HTMLElement | null>;
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}

/** Modal pencere: odak içeride tutulur, kapanınca açan öğeye döner, arka plan kaydırması kilitlenir.
 *  Mobilde alttan açılan sayfa olarak görünür (BottomSheet ile aynı dil). */
export function Dialog({ open, onClose, title, description, children, footer, sheetOnCompact = true, dismissible = true, initialFocusRef, size = 'md', className }: DialogProps) {
  const t = useStrings();
  const id = useId();
  const panel = useRef<HTMLDivElement>(null);
  useModalFocus(open, panel, initialFocusRef);
  useEffect(() => {
    if (!open) return;
    const key = (e: KeyboardEvent) => { if (e.key === 'Escape') { e.stopPropagation(); onClose(); } };
    document.addEventListener('keydown', key);
    return () => document.removeEventListener('keydown', key);
  }, [open, onClose]);
  if (!open) return null;
  return createPortal(
    <div className={cx('dy-layer', sheetOnCompact && 'dy-layer--sheet-compact')}>
      <div className="dy-scrim" aria-hidden="true" onMouseDown={() => dismissible && onClose()} />
      <div
        ref={panel}
        role="dialog"
        aria-modal="true"
        aria-labelledby={`${id}-t`}
        aria-describedby={description ? `${id}-d` : undefined}
        tabIndex={-1}
        className={cx('dy-dialog', `dy-dialog--${size}`, className)}
      >
        {sheetOnCompact ? <span className="dy-sheet__handle" aria-hidden="true" /> : null}
        <header className="dy-dialog__header">
          <h2 id={`${id}-t`} className="dy-dialog__title">{title}</h2>
          <button type="button" className="dy-dialog__close" aria-label={t('common.close')} onClick={onClose}><Icon name="x" /></button>
        </header>
        {description ? <p id={`${id}-d`} className="dy-dialog__desc">{description}</p> : null}
        {children ? <div className="dy-dialog__body">{children}</div> : null}
        {footer ? <footer className="dy-dialog__footer">{footer}</footer> : null}
      </div>
    </div>,
    document.body,
  );
}

export interface ConfirmDialogProps {
  open: boolean;
  title: string;
  /** Sonucu açıkça söyler: "Randevu iptal edilecek ve danışana bildirim gidecek." */
  description: string;
  confirmLabel: string;
  cancelLabel?: string;
  /** destructive: geri alınamaz eylem (kırmızı buton, ilk odak Vazgeç'te). */
  tone?: 'default' | 'destructive';
  /** Onay işlemi sürerken buton loading, pencere kapatılamaz. */
  pending?: boolean;
  onConfirm: () => void;
  onCancel: () => void;
}

/** Onay penceresi. Geri alınamaz eylemlerde varsayılan odak "Vazgeç" butonundadır. */
export function ConfirmDialog({ open, title, description, confirmLabel, cancelLabel = 'Vazgeç', tone = 'default', pending, onConfirm, onCancel }: ConfirmDialogProps) {
  const cancelRef = useRef<HTMLButtonElement>(null);
  return (
    <Dialog
      open={open}
      onClose={() => { if (!pending) onCancel(); }}
      title={title}
      description={description}
      size="sm"
      dismissible={!pending}
      initialFocusRef={tone === 'destructive' ? cancelRef : undefined}
      footer={
        <>
          <Button ref={cancelRef} variant="tertiary" state={pending ? 'disabled' : 'enabled'} onClick={onCancel}>{cancelLabel}</Button>
          <Button variant={tone === 'destructive' ? 'destructive' : 'primary'} state={pending ? 'loading' : 'enabled'} onClick={onConfirm}>{confirmLabel}</Button>
        </>
      }
    />
  );
}

export interface BottomSheetProps extends Omit<DialogProps, 'sheetOnCompact' | 'size'> {}

/** Alttan açılan sayfa: her genişlikte alttan (mobil panelde hızlı onay, filtreler). */
export function BottomSheet(props: BottomSheetProps) {
  return <Dialog {...props} sheetOnCompact className={cx('dy-dialog--sheet', props.className)} />;
}
