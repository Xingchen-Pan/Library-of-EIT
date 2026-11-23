# 仓库结构

| 路径 | 职责 |
| --- | --- |
| `src/main.tsx`、`src/App.tsx` | React DOM 挂载、Provider 装配、地图与检索界面 |
| `src/api/`、`public/data/` | Fetch 查询边界和随应用发布的示例数据 |
| `src/spatial/` | 楼层坐标、书架 ID 与分类 |
| `src/stores/` | 当前楼层、选中架号以及切换操作 |
| `src/viewer/` | 二维布局、Three.js 场景和 WebGL 生命周期 |
| `tests/unit/`、`tests/browser/` | 数据与几何测试、生产构建的浏览器测试 |
| `ai-docs/three-party/` | 外部服务契约与联调条件 |

新增正式模型时在资源目录按版本发布；扩展模块的依赖关系见[Viewer 设计](viewer.md)。
