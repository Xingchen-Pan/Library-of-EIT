import { useQuery } from "@tanstack/react-query";
import { Button, Input } from "antd";
import { lazy, Suspense, useState } from "react";
import { catalogQuery } from "./api/catalog";
import type { Floor } from "./spatial/floors";
import { findShelf, floors } from "./spatial/floors";
import { useGuide } from "./stores/guide";
import { FloorPlan } from "./viewer/FloorPlan";

const ModelView = lazy(() =>
  import("./viewer/ModelView").catch(() => ({
    default: ({ floor }: { floor: Floor }) => (
      <>
        <p role="status">三维模块加载失败，已显示平面图。刷新页面可重试。</p>
        <FloorPlan floor={floor} />
      </>
    ),
  })),
);
export function App() {
  const [term, setTerm] = useState("");
  const [model, setModel] = useState(false);
  const { floor, shelfId, selectFloor, selectShelf } = useGuide();
  const catalog = useQuery(catalogQuery);
  const books = catalog.data?.filter(
    (book) =>
      book.title.includes(term.trim()) ||
      book.shelf_id.toLowerCase().includes(term.trim().toLowerCase()),
  );
  const shelf = shelfId ? findShelf(shelfId) : undefined;
  return (
    <main className="shell mx-auto">
      <header className="masthead">
        <span className="brand-mark" aria-hidden="true">
          ▥
        </span>
        东方理工大学图书馆
      </header>
      <h1>馆藏导览</h1>
      <section className="workspace">
        <article className="map-panel">
          <div className="panel-header">
            <h2>楼层地图</h2>
            <div className="switch">
              {floors.map((id) => (
                <Button
                  key={id}
                  type={id === floor ? "primary" : "text"}
                  aria-pressed={id === floor}
                  onClick={() => selectFloor(id)}
                >
                  {id}
                </Button>
              ))}
            </div>
          </div>
          <div className="map-area">
            {model ? (
              <Suspense fallback={<p role="status">正在加载三维视图…</p>}>
                <ModelView key={floor} floor={floor} />
              </Suspense>
            ) : (
              <FloorPlan floor={floor} />
            )}
          </div>
          <div className="map-toolbar">
            <span>示意楼层 · {floor}</span>
            <Button onClick={() => setModel(!model)}>
              {model ? "查看平面图" : "查看三维模型"}
            </Button>
          </div>
          <div className="selection" aria-live="polite">
            {shelf ? (
              <>
                <strong>{shelf.id}</strong>　{shelf.section}
              </>
            ) : (
              "选择书架以查看位置"
            )}
          </div>
        </article>
        <aside className="catalog">
          <h2>示例馆藏</h2>
          <Input
            aria-label="搜索书名或架号"
            placeholder="搜索书名或架号"
            value={term}
            allowClear
            onChange={(e) => setTerm(e.target.value)}
          />
          {catalog.isPending && <p role="status">正在载入馆藏…</p>}
          {catalog.isError && (
            <p role="alert">
              馆藏加载失败。 <Button onClick={() => void catalog.refetch()}>重试</Button>
            </p>
          )}
          {books?.length === 0 && <p role="status">没有匹配的馆藏</p>}
          <ul className="book-list">
            {books?.map((book) => (
              <li key={book.copy_id}>
                <Button
                  type="text"
                  disabled={!findShelf(book.shelf_id)}
                  onClick={() => selectShelf(book.shelf_id)}
                >
                  <span>{book.title}</span>
                  <small>{book.shelf_id}</small>
                </Button>
              </li>
            ))}
          </ul>
        </aside>
      </section>
    </main>
  );
}
