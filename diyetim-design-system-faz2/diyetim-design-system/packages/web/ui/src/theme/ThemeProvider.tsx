import { createContext, useContext, useEffect, type ReactNode } from 'react';

export type ThemeMode = 'light' | 'dark' | 'system';
export type Density = 'comfortable' | 'compact';

const Ctx = createContext<{ mode: ThemeMode; density: Density }>({ mode: 'system', density: 'comfortable' });

export interface ThemeProviderProps {
  /** light, dark veya system (varsayılan). system: işletim sistemi tercihini izler. */
  mode?: ThemeMode;
  /** comfortable: mobil ve formlar; compact: panel tabloları. */
  density?: Density;
  /** true: data-theme'i <html> üzerine yazar (uygulama kökü). false: yalnızca sarmalayıcı div üzerinde (önizleme, test). */
  global?: boolean;
  children: ReactNode;
}

/** Tema ve yoğunluğu belirler. Renk değerlerinin tamamı @diyetim/tokens/tokens.css içindeki değişkenlerden gelir. */
export function ThemeProvider({ mode = 'system', density = 'comfortable', global = false, children }: ThemeProviderProps) {
  useEffect(() => {
    if (!global) return;
    const el = document.documentElement;
    if (mode === 'system') el.removeAttribute('data-theme'); else el.setAttribute('data-theme', mode);
    el.setAttribute('data-density', density);
  }, [global, mode, density]);
  const attrs = global ? {} : { 'data-theme': mode === 'system' ? undefined : mode, 'data-density': density };
  return (
    <Ctx.Provider value={{ mode, density }}>
      {global ? children : <div className="dy-theme-root" {...attrs}>{children}</div>}
    </Ctx.Provider>
  );
}

export const useTheme = () => useContext(Ctx);
