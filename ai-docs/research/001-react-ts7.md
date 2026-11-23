# 001 — React、TS7 与浏览器验证

核对日期为 2026-11-23。TypeScript 7 已通过正式 typescript 包提供 tsc。React 的 JSX 和 DOM 类型由相应的声明包提供，项目采用 TSX、react-jsx 与独立的严格类型检查。[TypeScript 7 发布说明](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/) · [React TypeScript 指南](https://react.dev/learn/typescript)

Vite 和 React 插件生成浏览器资源。Playwright 的每个版本对应指定浏览器构建，升级依赖后重新安装 Chromium，并用生产预览验证完整入口。触屏模拟的验收结果单独标注。[Playwright 浏览器文档](https://playwright.dev/docs/browsers)

项目首版使用原生 Three.js 场景和 Bun 单元测试。模型压缩、空间加速与其他渲染封装待有实际资产或性能数据时评估。
