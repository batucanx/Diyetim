import { useCallback, useRef, useState } from 'react';

/** Kontrollü / kontrolsüz değer yönetimi. */
export function useControllable<T>(value: T | undefined, defaultValue: T, onChange?: (v: T) => void): [T, (v: T) => void] {
  const [inner, setInner] = useState<T>(defaultValue);
  const controlled = value !== undefined;
  const ref = useRef(onChange);
  ref.current = onChange;
  const set = useCallback((v: T) => {
    if (!controlled) setInner(v);
    ref.current?.(v);
  }, [controlled]);
  return [controlled ? (value as T) : inner, set];
}
