import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./tests/browser",
  use: { baseURL: "http://127.0.0.1:4183" },
  projects: [
    { name: "desktop", use: { ...devices["Desktop Chrome"] } },
    { name: "touch", use: { ...devices["Pixel 7"], defaultBrowserType: "chromium" } },
  ],
  webServer: {
    command: "bun run preview --host 127.0.0.1 --port 4183 --strictPort",
    url: "http://127.0.0.1:4183",
  },
});
