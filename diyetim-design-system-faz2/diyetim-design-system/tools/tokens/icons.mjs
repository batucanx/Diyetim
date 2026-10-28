// spec/icons.json → TypeScript (SVG iç işaretlemesi) ve Dart (Path komut listesi).
// Dart tarafında SVG ayrıştırıcı paketine gerek kalmaz; yaylar kübik eğrilere çevrilir.
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { createRequire } from 'node:module';
import { ROOT } from './lib.mjs';

const require = createRequire(import.meta.url);
const svgpath = require('svgpath');

export const iconSpec = JSON.parse(readFileSync(join(ROOT, 'spec/icons.json'), 'utf8'));

const attr = (el, name) => {
  const m = el.match(new RegExp(`\\s${name}="([^"]*)"`));
  return m ? m[1] : undefined;
};

function elementToPath(el) {
  const tag = el.match(/^<(\w+)/)[1];
  let d;
  if (tag === 'path') d = attr(el, 'd');
  else if (tag === 'circle') {
    const cx = +attr(el, 'cx'), cy = +attr(el, 'cy'), r = +attr(el, 'r');
    d = `M${cx - r} ${cy}A${r} ${r} 0 1 0 ${cx + r} ${cy}A${r} ${r} 0 1 0 ${cx - r} ${cy}Z`;
  } else if (tag === 'rect') {
    const x = +attr(el, 'x'), y = +attr(el, 'y'), w = +attr(el, 'width'), h = +attr(el, 'height');
    const r = Math.min(+(attr(el, 'rx') ?? 0), w / 2, h / 2);
    d = r
      ? `M${x + r} ${y}H${x + w - r}A${r} ${r} 0 0 1 ${x + w} ${y + r}V${y + h - r}A${r} ${r} 0 0 1 ${x + w - r} ${y + h}H${x + r}A${r} ${r} 0 0 1 ${x} ${y + h - r}V${y + r}A${r} ${r} 0 0 1 ${x + r} ${y}Z`
      : `M${x} ${y}H${x + w}V${y + h}H${x}Z`;
  } else throw new Error(`Desteklenmeyen SVG öğesi: ${tag}`);
  let p = svgpath(d);
  const t = attr(el, 'transform');
  if (t) p = p.transform(t);
  return p.abs().unarc().unshort();
}

/** Dart opcode listesi: 0 moveTo(x,y) · 1 lineTo(x,y) · 2 cubicTo(6) · 3 quadTo(4) · 4 close */
function toOps(name, markup) {
  const ops = [];
  const els = markup.match(/<(path|circle|rect)\b[^>]*\/>/g) ?? [];
  if (!els.length) throw new Error(`${name}: çizim öğesi yok`);
  for (const el of els) {
    let cx = 0, cy = 0;
    elementToPath(el).iterate((seg) => {
      const [c, ...a] = seg;
      const r = (n) => +n.toFixed(3);
      switch (c) {
        case 'M': ops.push(0, r(a[0]), r(a[1])); cx = a[0]; cy = a[1]; break;
        case 'L': ops.push(1, r(a[0]), r(a[1])); cx = a[0]; cy = a[1]; break;
        case 'H': ops.push(1, r(a[0]), r(cy)); cx = a[0]; break;
        case 'V': ops.push(1, r(cx), r(a[0])); cy = a[0]; break;
        case 'C': ops.push(2, ...a.map(r)); cx = a[4]; cy = a[5]; break;
        case 'Q': ops.push(3, ...a.map(r)); cx = a[2]; cy = a[3]; break;
        case 'Z': ops.push(4); break;
        default: throw new Error(`${name}: beklenmeyen komut ${c}`);
      }
    });
  }
  return ops;
}

export function buildTsIcons() {
  const lines = Object.entries(iconSpec.icons).map(([k, v]) => `  ${k}: ${JSON.stringify(v)},`);
  return `/** Diyetim ikon seti (spec/icons.json): 24×24, çizgi ${iconSpec.strokeWidth}, yuvarlak uç ve köşe. */\nexport const iconPaths = {\n${lines.join('\n')}\n} as const;\n\nexport type IconName = keyof typeof iconPaths;\n`;
}

export function buildDartIcons() {
  const o = [
    `import 'package:flutter/foundation.dart';`, '',
    '/// Path komut listesi: 0 moveTo · 1 lineTo · 2 cubicTo · 3 quadTo · 4 close. 24×24 ızgara.',
    '@immutable', 'class DyIconData {', '  const DyIconData(this.name, this.ops);', '  final String name;', '  final List<double> ops;', '}', '',
    `/// Diyetim ikon seti (spec/icons.json). Çizgi kalınlığı: ${iconSpec.strokeWidth}.`,
    'abstract final class DyIcons {',
    `  static const double strokeWidth = ${iconSpec.strokeWidth};`,
  ];
  const names = Object.keys(iconSpec.icons);
  for (const [k, v] of Object.entries(iconSpec.icons)) {
    const ops = toOps(k, v).map((n) => (Number.isInteger(n) ? `${n}` : `${n}`));
    o.push(`  static const ${k} = DyIconData('${k}', [${ops.join(', ')}]);`);
  }
  o.push('', '  static const all = <DyIconData>[', ...names.map((n) => `    ${n},`), '  ];', '}');
  return o.join('\n') + '\n';
}
