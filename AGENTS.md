# 工程约定

本仓库是 Vue 3 单页示例，使用 Bun、TypeScript、Vite、Tailwind CSS 4 和 Biome。

## 开发

- 使用根目录 `package.json` 中的 Bun 脚本运行开发、检查和构建。
- `src/main.ts` 负责启动，`src/App.vue` 负责页面组合，全局样式放在 `src/style.css`。
- Vue 组件使用 `<script setup lang="ts">`；保持类型严格，纯类型依赖使用 `import type`。
- 只在需求出现时添加路由、状态管理或其他运行时依赖。
- 新增或移除依赖时同步更新 `bun.lock`，并在开发指南中记录其用途。
