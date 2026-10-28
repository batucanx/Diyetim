import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { ROOT, loadSources, resolvedColors, camel, entries, foundationValue } from '../lib.mjs';

const src = loadSources();
const colors = resolvedColors(src);
const css = readFileSync(join(ROOT, 'packages/web/tokens/src/generated/tokens.css'), 'utf8');
const dart = readFileSync(join(ROOT, 'packages/flutter/dy_tokens/lib/src/generated/dy_colors.g.dart'), 'utf8');
const dartFoundation = readFileSync(join(ROOT, 'packages/flutter/dy_tokens/lib/src/generated/dy_foundation.g.dart'), 'utf8');

function cssBlock(selectorStart) {
  const i = css.indexOf(selectorStart);
  assert.ok(i >= 0, `CSS bloğu yok: ${selectorStart}`);
  return css.slice(i, css.indexOf('}', i));
}
function cssVars(block) {
  return Object.fromEntries([...block.matchAll(/--([\w-]+):\s*([^;]+);/g)].map((m) => [m[1], m[2].trim()]));
}
function dartTheme(theme) {
  const i = dart.indexOf(`static const ${theme} = DyColors(`);
  assert.ok(i >= 0);
  const body = dart.slice(i, dart.indexOf(');', i));
  return Object.fromEntries([...body.matchAll(/(\w+): Color\(0x([0-9A-F]{8})\)/g)].map((m) => [m[1], m[2]]));
}
const argbToHex = (argb) => (argb.startsWith('FF') ? `#${argb.slice(2)}` : `#${argb.slice(2)}${argb.slice(0, 2)}`);

for (const [theme, sel] of [['light', ':root,\n[data-theme="light"]'], ['dark', '[data-theme="dark"]']]) {
  test(`CSS ve Dart ${theme} renkleri aynı değeri üretiyor`, () => {
    const c = cssVars(cssBlock(sel));
    const d = dartTheme(theme);
    const names = Object.keys(colors[theme]);
    assert.equal(Object.keys(d).length, names.length, 'Dart renk sayısı farklı');
    for (const n of names) {
      assert.equal(c[`color-${n}`], colors[theme][n], `CSS ${theme} ${n}`);
      assert.equal(argbToHex(d[camel(n)]), colors[theme][n], `Dart ${theme} ${n}`);
    }
  });
}

test('sistem dark tercihi bloğu dark tema ile birebir aynı', () => {
  const a = cssVars(cssBlock('[data-theme="dark"]'));
  const b = cssVars(cssBlock(':root:not([data-theme])'));
  assert.deepEqual(b, a);
});

test('spacing ve radius CSS ile Dart arasında aynı', () => {
  const root = cssVars(css.slice(css.indexOf(':root {')));
  const key = (k) => (k === '0' ? 'none' : k === '2xs' ? 'xxs' : k.replace(/^(\d)xl$/, 'xl$1'));
  for (const [group, cls, prefix] of [['spacing', 'DySpacing', 'spacing'], ['radius', 'DyRadius', 'radius']]) {
    for (const [k] of entries(src, group)) {
      const v = parseFloat(foundationValue(src, `${group}.${k}`));
      assert.equal(parseFloat(root[`${prefix}-${k}`]), v, `CSS ${prefix}-${k}`);
      const m = dartFoundation.slice(dartFoundation.indexOf(`class ${cls}`)).match(new RegExp(`static const ${key(k)} = ([\\d.]+);`));
      assert.ok(m, `Dart ${cls}.${key(k)} yok`);
      assert.equal(parseFloat(m[1]), v, `Dart ${cls}.${key(k)}`);
    }
  }
});

test('CSS font boyutları rem cinsinden (tarayıcı yazı boyutu ayarına uyar)', () => {
  const sizes = [...css.matchAll(/--font-size-[\w-]+:\s*([^;]+);/g)].map((m) => m[1]);
  assert.ok(sizes.length > 0);
  for (const s of sizes) assert.match(s, /rem$/);
});
