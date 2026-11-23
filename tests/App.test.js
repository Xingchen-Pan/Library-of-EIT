import { afterAll, beforeAll, describe, expect, it } from "bun:test";
import vue from "@vitejs/plugin-vue";
import { createSSRApp } from "vue";
import { renderToString } from "vue/server-renderer";
import { createServer } from "vite";

let server;
let App;

beforeAll(async () => {
  server = await createServer({
    configFile: false,
    plugins: [vue()],
    server: { middlewareMode: true, hmr: false, ws: false },
    appType: "custom",
  });
  App = (await server.ssrLoadModule("/src/App.vue")).default;
});

afterAll(async () => {
  await server?.close();
});

describe("App", () => {
  it("renders the heading, description, and initial click count", async () => {
    const html = await renderToString(createSSRApp(App));

    expect(html).toContain("Vue 3 + TypeScript");
    expect(html).toContain("最小单页示例");
    expect(html).toContain("点击次数：0");
  });
});
