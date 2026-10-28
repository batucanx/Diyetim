import { test, expect } from '@playwright/test';

/** Sabit görsel referanslar: her hikâye × tema × (mobil 390, masaüstü 1280). */
const STORIES = ['text', 'number', 'icon', 'surface', 'skeleton', 'button', 'textfield', 'select', 'choice'];
const VIEWPORTS = [{ name: 'mobil', width: 390, height: 844 }, { name: 'masaustu', width: 1280, height: 900 }];

for (const theme of ['light', 'dark'] as const) {
  for (const vp of VIEWPORTS) {
    for (const story of STORIES) {
      test(`görsel · ${story} · ${theme} · ${vp.name}`, async ({ page }) => {
        await page.setViewportSize({ width: vp.width, height: vp.height });
        await page.emulateMedia({ reducedMotion: 'reduce' });
        await page.goto(`/?story=${story}&theme=${theme}`);
        await page.evaluate(() => document.fonts.ready);
        await expect(page.locator('main')).toHaveScreenshot(`${story}-${theme}-${vp.name}.png`);
      });
    }
  }
  test(`görsel · select açık · ${theme}`, async ({ page }) => {
    await page.setViewportSize({ width: 390, height: 600 });
    await page.emulateMedia({ reducedMotion: 'reduce' });
    await page.goto(`/?story=select-open&theme=${theme}`);
    await page.getByRole('combobox').focus();
    await page.keyboard.press('ArrowDown');
    await expect(page.getByRole('listbox')).toBeVisible();
    await page.evaluate(() => document.fonts.ready);
    await expect(page).toHaveScreenshot(`select-open-${theme}.png`);
  });
}
