import { createContext, useContext, useMemo, type ReactNode } from 'react';
import { stringsTr, type StringKey, type Strings } from '../generated/strings';

const Ctx = createContext<Strings>(stringsTr);

/** Uygulamanın çeviri katmanını bağlar. Verilmeyen anahtarlar Türkçe varsayılana düşer. */
export function StringsProvider({ strings, children }: { strings: Partial<Strings>; children: ReactNode }) {
  const merged = useMemo(() => ({ ...stringsTr, ...strings }), [strings]);
  return <Ctx.Provider value={merged}>{children}</Ctx.Provider>;
}

/** `t('offline.pending', { count: 3 })` → "3 değişiklik gönderilmeyi bekliyor" */
export function useStrings() {
  const table = useContext(Ctx);
  return (key: StringKey, params?: Record<string, string | number>) =>
    table[key].replace(/\{(\w+)\}/g, (_, p: string) => String(params?.[p] ?? `{${p}}`));
}

export type { StringKey, Strings };
