import { expect, test } from "@playwright/test";
import { PerspectiveCamera, Vector3 } from "three";

test("find a copy, locate its shelf, then change floors", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByRole("heading", { name: "馆藏导览" })).toBeVisible();
  const search = page.getByRole("textbox", { name: "搜索书名或架号" });
  await search.fill("没有这本书");
  await expect(page.getByText("没有匹配的馆藏")).toBeVisible();
  await search.fill("计算机");
  await page.getByRole("button", { name: /计算机程序/ }).click();
  await expect(page.getByRole("button", { name: "3F", exact: true })).toHaveAttribute(
    "aria-pressed",
    "true",
  );
  await expect(page.getByRole("button", { name: /3F-B02 计算机科学/ })).toHaveAttribute(
    "aria-pressed",
    "true",
  );
  await page.getByRole("button", { name: "2F", exact: true }).click();
  await expect(page.getByText("选择书架以查看位置")).toBeVisible();
  await page.getByRole("button", { name: /2F-A03 人文与社会/ }).click();
  await expect(page.getByRole("button", { name: /2F-A03 人文与社会/ })).toHaveAttribute(
    "aria-pressed",
    "true",
  );
});

test("loads a three-dimensional canvas and returns to the floor plan", async ({ page }) => {
  await page.goto("/");
  await page.getByRole("button", { name: "查看三维模型" }).click();
  const canvas = page.locator("canvas");
  await expect(canvas).toBeVisible();
  const bounds = await canvas.boundingBox();
  if (!bounds) throw new Error("Canvas has no layout");
  const camera = new PerspectiveCamera(40, bounds.width / bounds.height, 0.1, 250);
  camera.position.set(14, 20, 22);
  camera.lookAt(0, 0, 0);
  camera.updateMatrixWorld();
  const projected = new Vector3(-4.8, 1.6, -2.8).project(camera);
  const position = {
    x: ((projected.x + 1) * bounds.width) / 2,
    y: ((1 - projected.y) * bounds.height) / 2,
  };
  if (!test.info().project.use.hasTouch) {
    const x = bounds.x + position.x;
    const y = bounds.y + position.y;
    await page.mouse.move(x, y);
    await page.mouse.down();
    await page.mouse.move(x + 24, y);
    await page.mouse.move(x, y);
    await page.mouse.up();
    await expect(page.locator(".selection")).toHaveText("选择书架以查看位置");
  }
  if (test.info().project.use.hasTouch) await canvas.tap({ position });
  else await canvas.click({ position });
  await expect(page.locator(".selection")).toContainText("2F-A01");
  await page.getByRole("button", { name: "查看平面图" }).click();
  await expect(page.locator("canvas")).toHaveCount(0);
  await expect(page.getByRole("button", { name: /2F-A01 建筑与空间/ })).toBeVisible();
});

test("WebGL failure preserves interactive floor selection", async ({ page }) => {
  await page.addInitScript(() => {
    const getContext = HTMLCanvasElement.prototype.getContext;
    HTMLCanvasElement.prototype.getContext = function (
      this: HTMLCanvasElement,
      type: string,
      ...args: unknown[]
    ) {
      return type.startsWith("webgl") ? null : Reflect.apply(getContext, this, [type, ...args]);
    } as typeof getContext;
  });
  await page.goto("/");
  await page.getByRole("button", { name: "查看三维模型" }).click();
  await expect(page.getByText("三维视图不可用，已显示平面图。")).toBeVisible();
  await page.getByRole("button", { name: /2F-A03 人文与社会/ }).click();
  await expect(page.getByRole("button", { name: /2F-A03 人文与社会/ })).toHaveAttribute(
    "aria-pressed",
    "true",
  );
});

test("invalid catalog can be retried without refetching on selection", async ({ page }) => {
  let requests = 0;
  await page.route("**/data/catalog.json", async (route) => {
    requests++;
    if (requests === 1) await route.fulfill({ json: [{ title: "无架号" }] });
    else await route.continue();
  });
  await page.goto("/");
  await expect(page.getByRole("alert")).toContainText("馆藏加载失败");
  await page.getByRole("button", { name: "重试" }).click();
  await page.getByRole("button", { name: /设计心理学/ }).click();
  await expect(page.getByRole("button", { name: /2F-A02 艺术与设计/ })).toHaveAttribute(
    "aria-pressed",
    "true",
  );
  expect(requests).toBe(2);
});

test("failed 3D module download leaves the guide usable", async ({ page }) => {
  await page.route("**/assets/ModelView-*.js", (route) => route.abort());
  await page.goto("/");
  await page.getByRole("button", { name: "查看三维模型" }).click();
  await expect(page.getByRole("status")).toContainText("三维模块加载失败");
  await page.getByRole("button", { name: /设计心理学/ }).click();
  await expect(page.getByRole("button", { name: /2F-A02 艺术与设计/ })).toHaveAttribute(
    "aria-pressed",
    "true",
  );
});
