export const floors = ["2F", "3F"] as const;
export type Floor = (typeof floors)[number];
export interface Shelf {
  id: string;
  floor: Floor;
  section: string;
  x: number;
  z: number;
}

// The sample plan spans 20 × 12 local units. Positive z points down on the floor plan.
const sections: Record<Floor, string[]> = {
  "2F": ["建筑与空间", "艺术与设计", "人文与社会", "历史与地理"],
  "3F": ["数学与物理", "计算机科学", "工程技术", "环境科学"],
};
export function shelvesOn(floor: Floor): Shelf[] {
  return sections[floor].map((section, i) => ({
    id: `${floor}-${floor === "2F" ? "A" : "B"}0${i + 1}`,
    floor,
    section,
    x: i % 2 === 0 ? -4.8 : 4.8,
    z: i < 2 ? -2.8 : 2.3,
  }));
}
export const shelves = floors.flatMap(shelvesOn);
export function findShelf(id: string) {
  return shelves.find((shelf) => shelf.id === id);
}
