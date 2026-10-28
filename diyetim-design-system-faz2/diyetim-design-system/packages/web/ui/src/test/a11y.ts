import axe from 'axe-core';
import { expect } from 'vitest';

/** jsdom içinde axe-core çalıştırır. Renk kontrastı jsdom'da ölçülemez (layout yok);
 *  o kontrol token testleri ve Playwright tarayıcı testleriyle yapılır. */
export async function expectNoA11yViolations(container: Element) {
  const result = await axe.run(container, {
    rules: { 'color-contrast': { enabled: false }, region: { enabled: false } },
  });
  const msgs = result.violations.map((v) => `${v.id}: ${v.help} → ${v.nodes.map((n) => n.html).join(' | ')}`);
  expect(msgs).toEqual([]);
}
