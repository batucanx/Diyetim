import { createContext, useCallback, useContext, useEffect, useRef, useState, type ReactNode } from 'react';
import type { FeedbackTone } from '@diyetim/tokens';
import { cx } from '../utils/cx';
import { Icon, type IconName } from '../primitives/Icon';
import { useStrings } from '../i18n/strings';

export interface ToastOptions {
  message: string;
  /** success · info. Hatalar toast ile değil, ilgili alanda veya Alert ile gösterilir. */
  tone?: Extract<FeedbackTone, 'success' | 'info'>;
  /** Snackbar: tek eylem (ör. Geri al). Verilirse süre 6 sn. */
  action?: { label: string; onAction: () => void };
  /** ms; varsayılan 4000, eylemli 6000. */
  duration?: number;
}

interface Item extends ToastOptions { id: number }
const Ctx = createContext<((o: ToastOptions) => void) | null>(null);
const toneIcon: Record<'success' | 'info', IconName> = { success: 'checkCircle', info: 'info' };

/** Toast ve Snackbar kuyruğu. Aynı anda tek bildirim; fare üzerindeyken veya odaktayken süre durur. */
export function ToastProvider({ children }: { children: ReactNode }) {
  const [queue, setQueue] = useState<Item[]>([]);
  const seq = useRef(0);
  const show = useCallback((o: ToastOptions) => setQueue((q) => [...q, { ...o, id: ++seq.current }]), []);
  const current = queue[0];
  const dismiss = useCallback(() => setQueue((q) => q.slice(1)), []);
  return (
    <Ctx.Provider value={show}>
      {children}
      <ToastRegion item={current} onDismiss={dismiss} />
    </Ctx.Provider>
  );
}

function ToastRegion({ item, onDismiss }: { item?: Item; onDismiss: () => void }) {
  const t = useStrings();
  const [paused, setPaused] = useState(false);
  const remaining = useRef(0);
  const started = useRef(0);
  useEffect(() => {
    if (!item) return;
    remaining.current = item.duration ?? (item.action ? 6000 : 4000);
  }, [item]);
  useEffect(() => {
    if (!item || paused) return;
    started.current = Date.now();
    const timer = setTimeout(onDismiss, remaining.current);
    return () => { clearTimeout(timer); remaining.current -= Date.now() - started.current; };
  }, [item, paused, onDismiss]);
  return (
    <div className="dy-toast-region" aria-live="polite" aria-label={t('toast.region')} role="region">
      {item ? (
        <div key={item.id} role="status" className={cx('dy-toast', `dy-toast--${item.tone ?? 'success'}`)}
          onMouseEnter={() => setPaused(true)} onMouseLeave={() => setPaused(false)} onFocus={() => setPaused(true)} onBlur={() => setPaused(false)}>
          <Icon name={toneIcon[item.tone ?? 'success']} className="dy-toast__icon" />
          <span className="dy-toast__message">{item.message}</span>
          {item.action ? (
            <button type="button" className="dy-toast__action" onClick={() => { item.action!.onAction(); onDismiss(); }}>
              {item.action.label === t('common.undo') ? <Icon name="undo" size="sm" /> : null}{item.action.label}
            </button>
          ) : null}
          <button type="button" className="dy-toast__close" aria-label={t('common.close')} onClick={onDismiss}><Icon name="x" size="sm" /></button>
        </div>
      ) : null}
    </div>
  );
}

/** `const toast = useToast(); toast({ message: 'Öğün kaydedildi', action: { label: 'Geri al', onAction: undo } })` */
export function useToast() {
  const show = useContext(Ctx);
  if (!show) throw new Error('useToast için uygulama ToastProvider ile sarılmalı.');
  return show;
}
