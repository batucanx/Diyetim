// Diyetim token kütüphanesi: DTCG kaynaklarını okur, referansları çözer, platform çıktılarını üretir.
import { readFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

export const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..', '..');
const read = (p) => JSON.parse(readFileSync(join(ROOT, p), 'utf8'));

export const THEMES = ['light', 'dark'];

export function loadSources() {
  return {
    primitive: read('tokens/primitive.color.json'),
    semantic: { light: read('tokens/semantic.light.json'), dark: read('tokens/semantic.dark.json') },
    foundation: read('tokens/foundation.json'),
    contracts: read('spec/contracts.json'),
  };
}

const isToken = (n) => n && typeof n === 'object' && '$value' in n;

function lookup(tree, path) {
  return path.split('.').reduce((n, k) => (n == null ? undefined : n[k]), tree);
}

/** "{color.pine.600}" gibi bir referansı verilen ağaçlarda çözer. */
export function resolve(value, trees, seen = new Set()) {
  if (typeof value !== 'string' || !/^\{[^}]+\}$/.test(value)) return value;
  const path = value.slice(1, -1);
  if (seen.has(path)) throw new Error(`Döngüsel referans: ${path}`);
  seen.add(path);
  for (const t of trees) {
    const node = lookup(t, path);
    if (isToken(node)) return resolve(node.$value, trees, seen);
  }
  throw new Error(`Çözülemeyen referans: ${value}`);
}

export const HEX = /^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{8})$/;

/** Semantic renkleri her tema için hex'e çözer: { light: {name: '#RRGGBB'}, dark: {...} } */
export function resolvedColors(src) {
  const out = {};
  for (const theme of THEMES) {
    out[theme] = {};
    for (const [name, tok] of Object.entries(src.semantic[theme].color)) {
      if (name.startsWith('$')) continue;
      const v = resolve(tok.$value, [src.semantic[theme], src.primitive]);
      if (!HEX.test(v)) throw new Error(`${theme}.${name}: geçersiz renk ${v}`);
      out[theme][name] = v.toUpperCase();
    }
  }
  const a = Object.keys(out.light).join(), b = Object.keys(out.dark).join();
  if (a !== b) throw new Error('Light ve dark temada semantic renk adları aynı değil');
  return out;
}

export function resolvedShadows(src) {
  const out = {};
  for (const theme of THEMES) {
    out[theme] = {};
    for (const [name, tok] of Object.entries(src.semantic[theme].shadow)) {
      if (name.startsWith('$')) continue;
      out[theme][name] = tok.$value;
    }
  }
  return out;
}

export function foundationValue(src, path) {
  const node = lookup(src.foundation, path);
  if (!isToken(node)) throw new Error(`Foundation token yok: ${path}`);
  return resolve(node.$value, [src.foundation]);
}

export function entries(src, group) {
  return Object.entries(src.foundation[group]).filter(([k, v]) => !k.startsWith('$') && isToken(v));
}

// --- WCAG kontrast ---
export function luminance(hex) {
  const c = [1, 3, 5].map((i) => parseInt(hex.slice(i, i + 2), 16) / 255)
    .map((x) => (x <= 0.04045 ? x / 12.92 : ((x + 0.055) / 1.055) ** 2.4));
  return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2];
}
export function contrast(a, b) {
  const [x, y] = [luminance(a), luminance(b)].sort((m, n) => n - m);
  return (x + 0.05) / (y + 0.05);
}

// --- ad dönüşümleri ---
export const camel = (s) => s.replace(/[-.]([a-z0-9])/g, (_, c) => c.toUpperCase()).replace(/^(\d)/, '_$1');
export const pascal = (s) => camel(s).replace(/^./, (c) => c.toUpperCase());

export function hashOf(body) {
  return createHash('sha256').update(body).digest('hex').slice(0, 16);
}
