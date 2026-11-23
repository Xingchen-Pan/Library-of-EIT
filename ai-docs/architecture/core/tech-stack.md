# Web 技术栈

## React 与 TypeScript 7

React + React DOM 承载单页应用。组件使用 `.tsx`，空间数据、API 适配和查看器控制逻辑使用 `.ts`。前端以正式包 `typescript@7.0.2` 为迁移基线，使用与 React 主版本匹配的 `@types/react`、`@types/react-dom`。版本核对日期为 2026-11-23。[TypeScript 7 发布说明](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/) · [7.0.2 发布记录](https://registry.npmjs.org/typescript/7.0.2) · [React TypeScript 指南](https://react.dev/learn/typescript)

Vite 使用 React 插件转译 TSX 和打包。类型检查单独运行工作区的 `tsc --noEmit`，保留严格检查与 bundler 模块解析，启用 `jsx: "react-jsx"`。检查范围覆盖 React 入口、业务组件、空间模块和 Vite 配置；测试和 Bun 脚本使用相应运行环境的类型。本地和 CI 共用 Bun 脚本和锁文件。当前安装项及其测试见[技术基线](../../standards/baseline.md)。[Vite 的 TypeScript 支持](https://vite.dev/guide/features.html#typescript)

## 按职责选型

| 职责 | 目标技术与选择依据 |
| --- | --- |
| 建模与发布 | Blender 制作分层建筑，导出 glTF 2.0 二进制文件 GLB。用 glTF Transform、Meshopt 优化时核验语义节点和解码配置。 |
| 三维场景 | Three.js、WebGL 2、GLTFLoader 和 Raycaster 负责显示与拾取。首版直接使用 Three.js；如改用 React Three Fiber / Drei，再核验 React 主版本兼容性。复杂场景出现拾取瓶颈时评估 three-mesh-bvh。 |
| 业务界面 | Ant Design 提供搜索、列表、详情和楼层选择控件，Tailwind CSS 负责布局。Pointer Events 统一处理鼠标和触屏。 |
| 状态与请求 | Zustand 保存界面选择，TanStack Query + Fetch 管理服务端结果、请求取消、缓存与重试。 |
| 导航与资源 | SVG 或 Canvas 绘制二维楼层图；Three.js Line 或 TubeGeometry 绘制三维路线。模型使用带版本的 URL，可由静态站点或 CDN 按 HTTP 缓存策略分发。 |
| 质量检查 | Bun、Biome 延续仓库现有工作流。纯空间变换与映射用单元测试覆盖，可沿用 Bun test；需要 Vite 组件测试时采用 Vitest。真实浏览器的选择、触控、跨层指引用 Playwright 验收。 |
