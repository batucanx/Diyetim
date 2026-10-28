import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  snapshotPathTemplate: '{testDir}/__screenshots__/{testFilePath}/{arg}{ext}',
  fullyParallel: true,
  reporter: [['list']],
  expect: { toHaveScreenshot: { maxDiffPixelRatio: 0.002, animations: 'disabled', caret: 'hide' } },
  use: { baseURL: 'http://localhost:5199', locale: 'tr-TR', colorScheme: 'light' },
  webServer: { command: 'pnpm vite --port 5199', port: 5199, reuseExistingServer: true, timeout: 60_000 },
});
