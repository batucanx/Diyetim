import { readFileSync, readdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const cssFiles = readdirSync(join(root, 'styles')).map((f) => join(root, 'styles', f));
const tsxFiles = ['primitives', 'components'].flatMap((d) => readdirSync(join(root, d)).filter((f) => f.endsWith('.tsx')).map((f) => join(root, d, f)));

const RAW = [
  { name: 'hex renk', re: /#[0-9a-fA-F]{3,8}\b/ },
  { name: 'rgb()/hsl() renk', re: /\b(rgba?|hsla?|oklch)\(/ },
  { name: 'piksel değeri', re: /(?<![\w-])\d+(\.\d+)?px\b/ },
  { name: 'rem değeri', re: /(?<![\w-])\d+(\.\d+)?rem\b/ },
  { name: 'adlandırılmış font', re: /font-family:(?!\s*var\()/ },
];

describe('tasarım kuralı: ham değer yok', () => {
  for (const file of cssFiles) {
    it(`${file.split('/').pop()} yalnızca token değişkenleri kullanır`, () => {
      const css = readFileSync(file, 'utf8').replace(/\/\*[\s\S]*?\*\//g, '');
      for (const { name, re } of RAW) {
        const lines = css.split('\n').filter((l) => re.test(l));
        expect(lines, `${name}`).toEqual([]);
      }
    });
  }
  for (const file of tsxFiles) {
    it(`${file.split('/').pop()} inline stilde ham renk/piksel kullanmaz`, () => {
      const src = readFileSync(file, 'utf8');
      expect(src.match(/#[0-9a-fA-F]{6}\b/g) ?? []).toEqual([]);
      expect(src.match(/['"`]\d+px['"`]/g) ?? []).toEqual([]);
    });
  }
});
