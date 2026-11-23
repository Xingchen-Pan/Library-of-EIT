import type { Floor } from "../spatial/floors";
import { shelvesOn } from "../spatial/floors";
import { useGuide } from "../stores/guide";

export function FloorPlan({ floor }: { floor: Floor }) {
  const { shelfId, selectShelf } = useGuide();
  return (
    <div className="plan-board">
      <div className="plan-compass" title="上方为北">
        ↑ N
      </div>
      <section className="plan-room" aria-label={`${floor} 平面图`}>
        {shelvesOn(floor).map((shelf) => (
          <button
            type="button"
            key={shelf.id}
            className="shelf"
            aria-pressed={shelfId === shelf.id}
            style={{ left: `${(shelf.x + 10) * 5}%`, top: `${((shelf.z + 6) / 12) * 100}%` }}
            onClick={() => selectShelf(shelf.id)}
          >
            <strong>{shelf.id}</strong>
            <span>{shelf.section}</span>
          </button>
        ))}
        <span className="entrance">↑ 入口</span>
      </section>
    </div>
  );
}
