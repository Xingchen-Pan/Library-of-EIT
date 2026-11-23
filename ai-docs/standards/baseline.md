# 技术基线与依赖验证

直接依赖的版本声明以 [package.json](../../package.json) 为准，解析结果以 [bun.lock](../../bun.lock) 为准。React 与 React DOM 同步升级，Three.js 与对应类型声明按同一次版本变更验证。使用 Bun 冻结安装复现。

| 直接依赖 | 工程内的最小用途 | 验证方式 |
| --- | --- | --- |
| react、react-dom | 挂载根组件、订阅查询和交互状态、懒加载模型 | 浏览器打开首页、选架、切换模型 |
| antd | 可清空的检索输入框、楼层与馆藏按钮 | 输入书名并点击结果，断言目标楼层和架号 |
| zustand | 同时写入楼层和架号 | 单元测试跨层选架、清空与无效架号；浏览器验证两个视图 |
| @tanstack/react-query | 发出 Fetch、共享缓存、处理失败重试 | 浏览器拦截异常响应，重试成功后检查请求次数 |
| three | 楼板、三维书架、相机控制与 Raycaster | 单元测试将书架中心投影回射线命中；浏览器验证画布加载和降级 |
| typescript、@types/react、@types/react-dom、@types/three、@types/bun | 检查 TSX、根节点、网格及 Bun 测试 API 类型 | `bun run typecheck` 覆盖 src、测试、脚本和配置 |
| vite、@vitejs/plugin-react | TSX 开发与生产构建 | `bun run build`，Playwright 加载 dist 入口与懒加载模块 |
| tailwindcss、@tailwindcss/vite | 编译根样式中的 Tailwind 布局工具类 | 生产构建后由浏览器加载生成的 CSS |
| @biomejs/biome | 格式与 lint | `bun run format:check`、`bun run lint` |
| @playwright/test | 桌面 Chromium 与触屏模拟 | `bun run test:e2e` 通过预览入口执行两套配置 |

引入新包时写出直接消费者及对应的可观察行为。一项工具能覆盖的验证沿用现有入口。
