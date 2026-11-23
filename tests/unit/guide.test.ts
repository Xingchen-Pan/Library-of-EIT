import { afterEach, expect, test } from "bun:test";
import { PerspectiveCamera, Vector2, Vector3 } from "three";
import { findShelf, floors, shelves } from "../../src/spatial/floors";
import { useGuide } from "../../src/stores/guide";
import { makeFloor } from "../../src/viewer/scene";
import catalog from "../../public/data/catalog.json";

afterEach(() => useGuide.getState().selectFloor("2F"));

test("every sample copy locates a unique mapped shelf", () => {
  expect(new Set(shelves.map((s) => s.id)).size).toBe(shelves.length);
  expect(new Set(catalog.map((b) => b.copy_id)).size).toBe(catalog.length);
  for (const book of catalog) expect(findShelf(book.shelf_id)).toBeDefined();
});

test("Zustand locates across floors and clears stale or unknown selections", () => {
  const { selectFloor, selectShelf } = useGuide.getState();
  selectShelf("3F-B02");
  expect(useGuide.getState()).toMatchObject({ floor: "3F", shelfId: "3F-B02" });
  selectFloor("2F");
  expect(useGuide.getState()).toMatchObject({ floor: "2F", shelfId: null });
  selectShelf("2F-A04");
  selectShelf("unknown");
  expect(useGuide.getState().shelfId).toBeNull();
});

for (const floor of floors) {
  test(`Three.js picks the mapped shelves on ${floor} and misses the aisle`, () => {
    const model = makeFloor(floor);
    const camera = new PerspectiveCamera(50, 1, 0.1, 100);
    camera.position.set(0, 18, 10);
    camera.lookAt(0, 0, 0);
    camera.updateMatrixWorld();
    model.root.updateMatrixWorld(true);
    try {
      for (const shelf of shelves.filter((s) => s.floor === floor)) {
        const projected = new Vector3(shelf.x, 1.6, shelf.z).project(camera);
        expect(model.pick(new Vector2(projected.x, projected.y), camera)).toBe(shelf.id);
      }
      expect(model.pick(new Vector2(0, 0), camera)).toBeNull();
    } finally {
      model.dispose();
    }
  });
}
