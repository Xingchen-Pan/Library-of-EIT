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
bun run test
bun run build
```

`bun run check` 会依次运行格式、lint、类型和测试检查。提交时 `.husky/pre-commit` 只检查格式；
推送时 `.husky/pre-push` 检查格式、lint 和测试。检查由 TypeScript 脚本
`scripts/git-hook.ts` 调用 Bun 执行，适用于 Windows 和 Linux。
`bun install` 会通过 `prepare` 自动将 Git hooks 指向 `.husky`；需要手动重装时可运行
`bun run hooks:install`。

`bun run build` 会先执行 Vue / TypeScript 类型检查，再由 Vite 输出生产文件到 `dist/`。使用 `bun run preview` 可本地预览构建结果。

测试使用 Bun 内置测试运行器；组件测试通过 Vite 加载 Vue 单文件组件。

## 依赖说明

运行时依赖保持精简：

- `vue`：页面组件和响应式状态。

开发依赖提供构建、类型检查和代码质量工具：

- `vite`：开发服务器与生产构建。
- `@vitejs/plugin-vue`：让 Vite 编译 Vue 单文件组件。
- `typescript`、`vue-tsc`：TypeScript 及 Vue 模板类型检查。
- `tailwindcss`、`@tailwindcss/vite`：Tailwind CSS 4 与 Vite 集成。
- `@biomejs/biome`：格式化及 lint。

`bun.lock` 与 `package.json` 一起提交。添加或移除依赖时重新生成锁文件，并同步本节说明。当前示例不包含外部测试框架、路由或全局状态库。
