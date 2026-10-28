import { test } from 'node:test';
import assert from 'node:assert/strict';
import { loadSources, resolvedColors, contrast, THEMES } from '../lib.mjs';

const src = loadSources();
const colors = resolvedColors(src);

for (const theme of THEMES) {
  for (const [fg, bg, min] of src.contracts.contrastPairs) {
    test(`kontrast [${theme}] ${fg} / ${bg} ≥ ${min}:1`, () => {
      assert.ok(colors[theme][fg], `${fg} tanımlı değil`);
      assert.ok(colors[theme][bg], `${bg} tanımlı değil`);
      const r = contrast(colors[theme][fg], colors[theme][bg]);
      assert.ok(r >= min, `${theme}: ${fg} ${colors[theme][fg]} / ${bg} ${colors[theme][bg]} = ${r.toFixed(2)}:1 (< ${min})`);
    });
  }
}

test('makro renkleri birbirinden açıklıkla da ayrışıyor (renk körlüğü için ≥ 1.1:1)', () => {
  for (const theme of THEMES) {
    const m = ['macro-carb', 'macro-protein', 'macro-fat'].map((k) => colors[theme][k]);
    // Renk tek gösterge değildir (etiket zorunlu); yine de üç ton aynı açıklıkta olmamalı.
    const pairs = [[0, 1], [0, 2], [1, 2]].map(([a, b]) => contrast(m[a], m[b]));
    assert.ok(pairs.some((r) => r >= 1.1), `${theme}: makro tonları neredeyse aynı açıklıkta: ${pairs.map((r) => r.toFixed(2))}`);
  }
});
