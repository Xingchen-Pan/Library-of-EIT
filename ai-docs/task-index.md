# 任务索引

本库独立编号。目标行为见[架构总览](architecture/README.md)，开发命令见[开发指南](development.md)。索引记录任务的依赖与状态，任务正文记录范围、验收与实际结果。

## 使用方式

1. 非平凡改动先复制[任务模板](task/_template.md)为 `task/NNN-kebab-case.md`。编号取索引最大值加一；保留已结束或取消的编号。已有任务范围内的修复更新原任务。
2. 登记优先级、规模、依赖和状态，检查依赖无环。P0 优先于 P1、P2；规模粗估为 S（一天以内）、M（数天）、L（一周以上）。
3. 前置交付物可用后置为 ready，动工时置为 in-progress。若前置任务仍在进行，注明已取得的具体交付物。调整范围先更新正文，发生阻塞时写明解除条件。
4. 每次提交在任务内记录进展。长记录移入[记录目录](task/records/README.md)，与正文互链。完成时逐项核对证据，同时更新索引与正文。

| 状态 | 使用时机 |
| --- | --- |
| draft | 范围或验收条件仍需明确 |
| planned | 已排入队列，等待指定依赖或输入 |
| ready | 开始条件齐备 |
| in-progress | 正在执行 |
| implemented | 仓库内验证完成，仍有外部验收待补 |
| blocked | 遇到具体阻塞，正文记有解除条件 |
| done | 约定验收全部有证据 |
| deferred | 暂缓排期 |
| cancelled | 已取消，保留原因与编号 |

## 任务队列

| 编号 | 分类 | 任务 | 优先级 | 依赖 | 规模 | 状态 |
| --- | --- | --- | --- | --- | --- | --- |
| 001 | 文档 | [Web 架构与任务系统](task/001-web-design-docs.md) | P0 | — | S | done |
| 002 | 工具链 | [React 与 TypeScript 7 迁移](task/002-react-ts7.md) | P0 | 001 | M | done |
| 003 | 空间数据 | [单层模型与空间标定](task/003-floor-assets.md) | P0 | 001、楼层资料 | M | planned |
| 004 | 交互 | [楼层与书架 Viewer](task/004-shelf-viewer.md) | P1 | 002、003 | M | in-progress |
| 005 | 服务适配 | [馆藏定位与 Go 契约](task/005-go-location.md) | P1 | 002、library-go 契约 | M | planned |
| 006 | 导航 | [跨层路线与移动浏览器验收](task/006-navigation.md) | P1 | 004、005、路线样本 | L | planned |
