# 002 — React 与 TypeScript 7 迁移

- 状态：done
- 依赖：001
- 优先级 / 规模：P0 / M
- 创建 / 更新：2026-11-23 / 2026-11-23

## 目标与开始条件

将现有 Vue 示例替换为 React 应用壳。图书业务与三维模型另行交付。 设计依据见[技术栈](../architecture/core/tech-stack.md)。

## 实施与验收

更新 package.json、bun.lock、Vite 插件、TS 配置及 HTML 入口；用 TSX 替换 App.vue，并改写依赖 Vue SSR 的示例测试。同步开发指南和编辑器配置。

- [x] 锁文件可冻结安装；本地 tsc 输出 7.x，能检查 TSX、普通 TS 和配置。
- [x] 故意引入错误的组件属性能使类型检查失败；撤销后 bun run check 和 bun run build 通过，浏览器能打开 React 首页。

## 工作记录与回退

2026-11-23 已替换应用入口、依赖和测试。React 首页提供可检索的示例馆藏和按 ID 选架的二维 / 三维视图。类型反例、冻结安装和浏览器测试见[验证记录](records/002-react-ts7.md)。迁移按一个可回退的改动交付，出错时将入口、依赖、配置和测试同步恢复。
