# 开发指南

## 环境与命令

使用 Bun 安装依赖并启动开发服务器：

```sh
bun install --frozen-lockfile
bun run dev
```

常用检查与构建：

```sh
bun run format:check
bun run lint
bun run typecheck
bun run build
```

`bun run build` 会先执行 Vue / TypeScript 类型检查，再由 Vite 输出生产文件到 `dist/`。使用 `bun run preview` 可本地预览构建结果。

## 依赖说明

运行时依赖保持精简：

- `vue`：页面组件和响应式状态。

开发依赖提供构建、类型检查和代码质量工具：

- `vite`：开发服务器与生产构建。
- `@vitejs/plugin-vue`：让 Vite 编译 Vue 单文件组件。
- `typescript`、`vue-tsc`：TypeScript 及 Vue 模板类型检查。
- `tailwindcss`、`@tailwindcss/vite`：Tailwind CSS 4 与 Vite 集成。
- `@biomejs/biome`：格式化及 lint。

`bun.lock` 与 `package.json` 一起提交。添加或移除依赖时重新生成锁文件，并同步本节说明。当前示例不包含测试框架、路由或全局状态库。
