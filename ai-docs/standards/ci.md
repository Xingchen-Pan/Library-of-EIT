# CI 与发布

拉取请求和 main 推送仅涉及 Markdown 或 ai-docs/ 时跳过 CI。其余改动在 Ubuntu 上依次执行冻结安装、`check`、生产构建、Chromium 安装和浏览器测试。CI 从 package.json 读取命令，浏览器用与 Playwright 对应的版本。变更门禁时同时更新开发指南。[工作流](../../.github/workflows/ci.yml)

`dist/` 是静态部署目录，包含入口、懒加载的三维模块与公开样例数据。发布时一起提供这些文件，保留 Vite 资源哈希。预览时验证浏览器可读取静态馆藏和按需下载的三维模块。仓库当前配置的是检查流水线，正式托管与地址由部署环境确定。

Bun 下载缓存按操作系统、架构和 bun.lock 区分；锁文件变化时可复用已有包，随后执行冻结安装。Playwright 浏览器缓存按操作系统、架构及锁定版本的 browsers.json 区分。命中后仍运行带 --with-deps 的安装命令，确保新 runner 具备系统库。
