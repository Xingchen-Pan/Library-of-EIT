# Library-of-EIT

东方理工大学图书馆 Web 三维导览前端。目标是让读者从馆藏副本定位到具体书架，并按楼层查看室内路线。当前 React + TypeScript 7 版本提供两层示意书架、馆藏检索和二维 / 三维联动。页面使用本地样例，实际馆藏位置与路线待服务端联调。

| 文档 | 用途 |
| --- | --- |
| [架构总览](ai-docs/architecture/README.md) | 读者流程、Viewer 模块、空间数据与技术选型 |
| [Go 服务适配](ai-docs/three-party/library-go.md) | 对接独立服务仓库需要的接口与联调条件 |
| [技术规范](ai-docs/standards/README.md) | 依赖基线、测试和 CI 验收 |
| [调研索引](ai-docs/research/README.md) | 技术选择的依据与验证范围 |
| [任务索引](ai-docs/task-index.md) | 查找工作项、创建任务、核对验收状态 |

## 快速开始

需要安装 [Bun](https://bun.sh/)。

```sh
bun install --frozen-lockfile
bun run dev
```

常用命令和依赖说明见[开发指南](ai-docs/development.md)。

## Dart 平面图源码

[`assets/dart/`](assets/dart/) 保存从 Flutter `library_app` 移植的图书馆 2F、3F、5F 平面图 Dart 源码，包含地图绘制、标签、锚点和缩放交互，并保留原有的 part 文件结构。
