# 开发指南

从仓库根目录使用 Bun 安装和启动，Node 需满足锁定 Vite 的 engines 条件。环境版本与依赖用途见[技术基线](standards/baseline.md)。

```sh
bun install --frozen-lockfile
bun run dev
```

打开开发服务器输出的地址。搜索“计算机”并选择结果会切换到 3F、选中 B02 书架。切换三维视图后可拖动旋转、滚轮缩放或点选书架。默认数据来自随构建发布的示例 JSON，开发时可独立于 Go 运行。

## 验证与构建

```sh
bun run check
bun run build
bun run playwright install chromium --only-shell
bun run test:e2e
```

`check` 依次运行格式、lint、TS7 和单元测试。`build` 先检查类型再构建到 `dist/`。浏览器测试自动启动生产预览；单独预览可运行 `bun run preview`。浏览器测试后若修改了应用，先重建再测试。Linux CI 的浏览器安装命令及门禁见[CI 与发布](standards/ci.md)。

安装时 prepare 注册 Git hooks，可用 `bun run hooks:install` 重装。pre-commit 检查格式，pre-push 检查格式、lint 和单元测试。新增依赖时同时更新清单、锁文件、[依赖与验证对照](standards/baseline.md)和对应测试。
