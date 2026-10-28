/** Türkçe sayı biçimi: 1.842 · 6,3 · %48. Değer ile birim arasına yalnızca U+00A0 konur (Nunito U+202F içermez). */
export const NBSP = ' ';

export interface FormatNumberOptions {
  minimumFractionDigits?: number;
  maximumFractionDigits?: number;
  style?: 'decimal' | 'percent';
}

const cache = new Map<string, Intl.NumberFormat>();

export function formatNumber(value: number, opts: FormatNumberOptions = {}): string {
  const key = JSON.stringify(opts);
  let f = cache.get(key);
  if (!f) {
    f = new Intl.NumberFormat('tr-TR', {
      style: opts.style ?? 'decimal',
      minimumFractionDigits: opts.minimumFractionDigits ?? 0,
      maximumFractionDigits: opts.maximumFractionDigits ?? (opts.style === 'percent' ? 0 : 1),
    });
    cache.set(key, f);
  }
  return f.format(value).replace(/ /g, NBSP);
}

/** "6,3" / "1.842,5" / "6.3" gibi kullanıcı girdisini sayıya çevirir. Geçersizse null. */
export function parseNumber(input: string): number | null {
  const s = input.trim().replace(/\s| /g, '');
  if (s === '' || s === '-' || s === ',') return null;
  let norm: string;
  if (s.includes(',')) norm = s.replace(/\./g, '').replace(',', '.');
  else if (/^-?\d{1,3}(\.\d{3})+$/.test(s)) norm = s.replace(/\./g, '');
  else norm = s;
  if (!/^-?\d*\.?\d+$/.test(norm)) return null;
  const n = Number(norm);
  return Number.isFinite(n) ? n : null;
}

/** Türkçe yerel ayarla büyük/küçük harf duyarsız karşılaştırma (typeahead için). */
export function trStartsWith(text: string, prefix: string): boolean {
  return text.toLocaleLowerCase('tr-TR').startsWith(prefix.toLocaleLowerCase('tr-TR'));
}
