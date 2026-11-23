import { BoxGeometry, Group, Mesh, MeshStandardMaterial, Raycaster } from "three";
import type { Camera, Vector2 } from "three";
import type { Floor } from "../spatial/floors";
import { shelvesOn } from "../spatial/floors";

export function makeFloor(floor: Floor) {
  const root = new Group();
  const blocks = new BoxGeometry(1, 1, 1);
  const paper = new MeshStandardMaterial({ color: 0xeae6d9 });
  const wall = new MeshStandardMaterial({ color: 0xbfc9bd });
  const shelfMeshes: Mesh<BoxGeometry, MeshStandardMaterial>[] = [];
  function box(
    x: number,
    y: number,
    z: number,
    w: number,
    h: number,
    d: number,
    material: MeshStandardMaterial,
  ) {
    const mesh = new Mesh(blocks, material);
    mesh.position.set(x, y, z);
    mesh.scale.set(w, h, d);
    root.add(mesh);
    return mesh;
  }
  box(0, -0.2, 0, 20, 0.4, 12, paper);
  box(0, 0.45, -6, 20, 0.9, 0.18, wall);
  box(-10, 0.45, 0, 0.18, 0.9, 12, wall);
  box(10, 0.45, 0, 0.18, 0.9, 12, wall);
  for (const shelf of shelvesOn(floor)) {
    const material = new MeshStandardMaterial({ color: 0x477369 });
    const mesh = box(shelf.x, 0.8, shelf.z, 5.5, 1.6, 1.4, material);
    mesh.userData.shelfId = shelf.id;
    shelfMeshes.push(mesh);
  }
  const raycaster = new Raycaster();
  return {
    root,
    highlight(id: string | null) {
      for (const mesh of shelfMeshes)
        mesh.material.color.setHex(mesh.userData.shelfId === id ? 0xd1894a : 0x477369);
    },
    pick(pointer: Vector2, camera: Camera): string | null {
      raycaster.setFromCamera(pointer, camera);
      return raycaster.intersectObjects(shelfMeshes, false)[0]?.object.userData.shelfId ?? null;
    },
    dispose() {
      blocks.dispose();
      paper.dispose();
      wall.dispose();
      for (const mesh of shelfMeshes) mesh.material.dispose();
    },
  };
}
