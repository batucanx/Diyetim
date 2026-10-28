import { test, expect, type Page } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';
import resolved from '@diyetim/tokens/resolved.json' with { type: 'json' };

const STORIES = ['text', 'number', 'icon', 'surface', 'skeleton', 'button', 'textfield', 'select', 'choice', 'tags', 'alerts', 'states'];

async function open(page: Page, story: string, theme = 'light') {
  await page.goto(`/?story=${story}&theme=${theme}`);
  await page.evaluate(() => document.fonts.ready);
}

test.describe('tarayıcıda erişilebilirlik (axe, renk kontrastı dahil)', () => {
  for (const theme of ['light', 'dark']) {
    for (const story of STORIES) {
      test(`${story} · ${theme}`, async ({ page }) => {
        await open(page, story, theme);
        const r = await new AxeBuilder({ page }).include('main').withTags(['wcag2a', 'wcag2aa', 'wcag21aa', 'wcag22aa']).analyze();
        // Devre dışı öğeler WCAG 1.4.3 kapsamı dışındadır; axe bunları zaten atlar.
        expect(r.violations.map((v) => `${v.id}: ${v.nodes.map((n) => n.target.join(' ')).join(', ')}`)).toEqual([]);
      });
    }
  }
});

test.describe('%200 metin ölçeği ve dar ekran (320 px): yatay taşma yok', () => {
  for (const story of STORIES) {
    test(story, async ({ page }) => {
      await page.setViewportSize({ width: 320, height: 800 });
      await open(page, story);
      await page.addStyleTag({ content: 'html { font-size: 200% !important; }' });
      await page.waitForTimeout(50);
      const overflow = await page.evaluate(() => {
        const doc = document.documentElement;
        const offenders = [...document.querySelectorAll<HTMLElement>('main *')]
          .filter((el) => el.getBoundingClientRect().right > doc.clientWidth + 1 && getComputedStyle(el).position !== 'absolute' && !el.closest('.dy-visually-hidden'))
          .map((el) => el.className || el.tagName).slice(0, 5);
        return { scroll: doc.scrollWidth, client: doc.clientWidth, offenders };
      });
      expect(overflow.offenders).toEqual([]);
      expect(overflow.scroll).toBeLessThanOrEqual(overflow.client);
    });
  }
});

test.describe('metin kırpılmıyor', () => {
  test('buton ve alan etiketleri uzun Türkçe metinde tam görünür', async ({ page }) => {
    await page.setViewportSize({ width: 360, height: 800 });
    for (const story of ['button', 'textfield', 'choice']) {
      await open(page, story);
      const clipped = await page.evaluate(() => [...document.querySelectorAll<HTMLElement>('.dy-button__label, .dy-field__label, .dy-choice__label, .dy-text:not(.dy-text--clamp)')].filter((el) => !el.classList.contains('dy-visually-hidden'))
        .filter((el) => el.scrollWidth > el.clientWidth + 1 || el.scrollHeight > el.clientHeight + 1)
        .map((el) => el.textContent?.slice(0, 40)));
      expect(clipped, story).toEqual([]);
    }
  });
});

test.describe('token çıktısı tarayıcıda', () => {
  for (const theme of ['light', 'dark'] as const) {
    test(`hesaplanan CSS değişkenleri resolved.json ile aynı · ${theme}`, async ({ page }) => {
      await open(page, 'text', theme);
      const css = await page.evaluate((names) => {
        const s = getComputedStyle(document.documentElement);
        return Object.fromEntries(names.map((n) => [n, s.getPropertyValue(`--color-${n}`).trim()]));
      }, Object.keys(resolved.colors[theme]));
      expect(css).toEqual(resolved.colors[theme]);
    });
  }
  test('sistem dark tercihi data-theme olmadan dark değerleri verir', async ({ page }) => {
    await page.emulateMedia({ colorScheme: 'dark' });
    await page.goto('/?story=text&theme=system');
    const bg = await page.evaluate(() => getComputedStyle(document.documentElement).getPropertyValue('--color-background').trim());
    expect(bg).toBe(resolved.colors.dark.background);
  });
});

test('Nunito yükleniyor ve Türkçe metin Nunito ile çiziliyor', async ({ page }) => {
  await open(page, 'text');
  const ok = await page.evaluate(async () => {
    await document.fonts.load('700 16px Nunito', 'ğüşıöçİ');
    return { loaded: document.fonts.check('700 16px Nunito', 'ğüşıöçİ'), family: getComputedStyle(document.querySelector('h1')!).fontFamily };
  });
  expect(ok.loaded).toBe(true);
  expect(ok.family).toContain('Nunito');
});

test('rakamlar eşit genişlikte (tabular)', async ({ page }) => {
  await open(page, 'number');
  const [a, b] = await page.locator('.dy-text--numeric-lg .dy-num__value').filter({ hasText: /111|888/ }).evaluateAll((els) => els.map((e) => e.getBoundingClientRect().width));
  expect(Math.abs(a - b)).toBeLessThan(0.5);
});

test('klavye odağında odak halkası token rengi ve 2 px', async ({ page }) => {
  await open(page, 'button');
  await page.keyboard.press('Tab');
  const st = await page.evaluate(() => {
    const el = document.activeElement as HTMLElement;
    const s = getComputedStyle(el);
    return { w: s.outlineWidth, style: s.outlineStyle, color: s.outlineColor, off: s.outlineOffset };
  });
  expect(st).toMatchObject({ w: '2px', style: 'solid', off: '2px' });
  expect(st.color).toBe('rgb(32, 120, 113)'); // focus-ring light: #207871
});

test('dokunma hedefleri en az 44 × 44', async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 });
  for (const story of ['button', 'textfield', 'choice', 'select']) {
    await open(page, story);
    const small = await page.evaluate(() => [...document.querySelectorAll<HTMLElement>('button:not(.dy-stepper__btn):not(.dy-input__clear), [role="switch"], [role="combobox"], input[type="checkbox"], input[type="radio"], .dy-button')]
      .map((el) => { const r = el.getBoundingClientRect(); const t = el.matches('[role="switch"]') ? r.height + 16 : r.height; return { h: t, w: r.width, n: el.getAttribute('aria-label') ?? el.textContent?.slice(0, 20) }; })
      .filter((x) => x.h < 43.5 || x.w < 43.5 && x.n !== 'sm'));
    expect(small.filter((x) => !/Panel/.test(String(x.n))), story).toEqual([]);
  }
});

test('hareketi azalt: süreler 0 ms, shimmer durur', async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
  await open(page, 'skeleton');
  const r = await page.evaluate(() => ({
    d: getComputedStyle(document.documentElement).getPropertyValue('--duration-normal').trim(),
    anim: getComputedStyle(document.querySelector('.dy-skeleton')!, '::after').animationName,
  }));
  expect(r).toEqual({ d: '0ms', anim: 'none' });
});

test('Snackbar: görünür, Geri al ile kapanır; region canlı', async ({ page }) => {
  await page.goto('/?story=toast');
  await page.getByRole('button', { name: 'Snackbar göster' }).click();
  const region = page.getByRole('region', { name: 'Bildirimler' });
  await expect(region).toHaveAttribute('aria-live', 'polite');
  await expect(page.getByRole('status')).toContainText('Öğle öğünü kaydedildi');
  const r = await new AxeBuilder({ page }).include('.dy-toast-region').analyze();
  expect(r.violations.map((v) => v.id)).toEqual([]);
  await page.getByRole('button', { name: /Geri al/ }).click();
  await expect(page.getByRole('status')).toHaveCount(0);
});

test('Tooltip klavye odağında görünür ve Escape ile kapanır', async ({ page }) => {
  await page.goto('/?story=alerts');
  await page.getByRole('button', { name: 'Kamera' }).focus();
  await expect(page.getByRole('tooltip')).toBeVisible();
  await page.keyboard.press('Escape');
  await expect(page.getByRole('tooltip')).toBeHidden();
});
