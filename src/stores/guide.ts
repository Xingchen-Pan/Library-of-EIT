import { create } from "zustand";
import type { Floor } from "../spatial/floors";
import { findShelf } from "../spatial/floors";

interface Guide {
  floor: Floor;
  shelfId: string | null;
  selectFloor: (floor: Floor) => void;
  selectShelf: (id: string | null) => void;
}
export const useGuide = create<Guide>((set) => ({
  floor: "2F",
  shelfId: null,
  selectFloor: (floor) => set({ floor, shelfId: null }),
  selectShelf: (id) => {
    const shelf = id === null ? undefined : findShelf(id);
    if (shelf) set({ floor: shelf.floor, shelfId: shelf.id });
    else set({ shelfId: null });
  },
}));
