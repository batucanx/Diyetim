import { test } from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { ROOT, loadSources, entries, foundationValue } from '../lib.mjs';

const src = loadSources();
const build = join(ROOT, 'tools/tokens/build.mjs');

test('üretilmiş dosyalar kaynakla güncel (tokens:check)', () => {
  execFileSync('node', [build, '--check'], { stdio: 'pipe' });
});

test('üretilmiş bir dosya elle değiştirilirse tokens:check başarısız olur', () => {
  const file = join(ROOT, 'packages/web/tokens/src/generated/tokens.css');
  const original = readFileSync(file, 'utf8');
  try {
    writeFileSync(file, original.replace('--color-primary:', '--color-primary: #FF0000; --x:'));
    assert.throws(() => execFileSync('node', [build, '--check'], { stdio: 'pipe' }));
  } finally {
    writeFileSync(file, original);
  }
});

test('semantic katman yalnızca primitive referansları kullanır (scrim hariç)', () => {
  for (const theme of ['light', 'dark']) {
    for (const [n, t] of Object.entries(src.semantic[theme].color)) {
      if (n.startsWith('$') || n === 'scrim') continue;
      assert.match(t.$value, /^\{color\.[a-z]+\.\d+\}$/, `${theme}.${n} ham değer içeriyor: ${t.$value}`);
    }
  }
});

test('spacing ölçeği 2 px katı ve artan sırada', () => {
  const v = entries(src, 'spacing').map(([k]) => parseFloat(foundationValue(src, `spacing.${k}`)));
  v.forEach((x, i) => { assert.equal(x % 2, 0); if (i) assert.ok(x > v[i - 1]); });
});

test('tipografi: masaüstü boyutu mobil boyuttan küçük değil; satır yüksekliği boyuttan büyük', () => {
  for (const [name, t] of Object.entries(src.foundation.typography)) {
    if (name.startsWith('$')) continue;
    const [m, d] = t.$value.fontSize.map(parseFloat);
    const [lm, ld] = t.$value.lineHeight.map(parseFloat);
    assert.ok(d >= m - 1, `${name}: masaüstü ${d} < mobil ${m}`);
    assert.ok(lm > m && ld > d, `${name}: satır yüksekliği yetersiz`);
  }
});

test('dokunma hedefi en az 44 px', () => {
  assert.ok(parseFloat(foundationValue(src, 'size.target-min')) >= 44);
});

test('Nunito raporu: tüm zorunlu kontroller geçmiş', () => {
  const report = JSON.parse(readFileSync(join(ROOT, 'tools/fonts/nunito-report.json'), 'utf8'));
  for (const r of report) assert.ok(r.ok, r.check);
});
