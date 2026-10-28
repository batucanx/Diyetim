// spec/i18n/<dil>.json → TypeScript ve Dart metin tabloları. Anahtarlar iki platformda aynıdır.
import { readFileSync, readdirSync } from 'node:fs';
import { join } from 'node:path';
import { ROOT } from './lib.mjs';

const dir = join(ROOT, 'spec/i18n');
const langs = Object.fromEntries(readdirSync(dir).filter((f) => f.endsWith('.json')).map((f) => [f.slice(0, -5), JSON.parse(readFileSync(join(dir, f), 'utf8'))]));
const base = Object.fromEntries(Object.entries(langs.tr).filter(([k]) => !k.startsWith('$')));
for (const [lang, table] of Object.entries(langs)) {
  const missing = Object.keys(base).filter((k) => !(k in table));
  if (missing.length) throw new Error(`${lang}.json eksik anahtarlar: ${missing.join(', ')}`);
}

export function buildTsStrings() {
  const keys = Object.keys(base);
  return [
    `/** Varsayılan metinler (spec/i18n). Uygulama kendi çeviri katmanını \`StringsProvider\` ile verebilir. */`,
    `export const stringsTr = ${JSON.stringify(base, null, 2)} as const;`,
    `export type StringKey = keyof typeof stringsTr;`,
    `export type Strings = Record<StringKey, string>;`,
    `export const stringKeys = ${JSON.stringify(keys)} as const;`,
  ].join('\n\n') + '\n';
}

export function buildDartStrings() {
  const esc = (s) => s.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\$/g, '\\$');
  return [
    '/// Varsayılan metinler (spec/i18n). Uygulama kendi çeviri katmanını DyStrings.of(context) üzerinden verebilir.',
    'abstract final class DyStringsTr {',
    '  static const Map<String, String> table = {',
    ...Object.entries(base).map(([k, v]) => `    '${esc(k)}': '${esc(v)}',`),
    '  };',
    '}',
  ].join('\n') + '\n';
}
