import { useEffect, useRef, useState } from "react";
import {
  AmbientLight,
  DirectionalLight,
  PerspectiveCamera,
  Scene,
  Vector2,
  WebGLRenderer,
} from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import type { Floor } from "../spatial/floors";
import { useGuide } from "../stores/guide";
import { FloorPlan } from "./FloorPlan";
import { makeFloor } from "./scene";

export default function ModelView({ floor }: { floor: Floor }) {
  const mount = useRef<HTMLDivElement>(null);
  const [failed, setFailed] = useState(false);
  useEffect(() => {
    const host = mount.current;
    if (!host || failed) return;
    let renderer: WebGLRenderer;
    try {
      renderer = new WebGLRenderer({ antialias: true });
    } catch {
      setFailed(true);
      return;
    }
    const canvas = renderer.domElement;
    host.appendChild(canvas);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.setClearColor(0xf0f3ed);
    const scene = new Scene();
    const model = makeFloor(floor);
    scene.add(model.root, new AmbientLight(0xffffff, 1.8));
    const sun = new DirectionalLight(0xfff2d6, 2.2);
    sun.position.set(-8, 15, 5);
    scene.add(sun);
    const camera = new PerspectiveCamera(40, 1, 0.1, 250);
    camera.position.set(14, 20, 22);
    const controls = new OrbitControls(camera, canvas);
    controls.maxPolarAngle = Math.PI / 2.2;
    controls.minDistance = 8;
    controls.maxDistance = 70;
    controls.update();
    const render = () => renderer.render(scene, camera);
    controls.addEventListener("change", render);
    const resize = () => {
      if (!host.clientWidth || !host.clientHeight) return;
      camera.aspect = host.clientWidth / host.clientHeight;
      camera.updateProjectionMatrix();
      renderer.setSize(host.clientWidth, host.clientHeight);
      render();
    };
    const observer = new ResizeObserver(resize);
    observer.observe(host);
    model.highlight(useGuide.getState().shelfId);
    resize();
    const unsubscribe = useGuide.subscribe(({ shelfId }) => {
      model.highlight(shelfId);
      render();
    });
    let start: PointerEvent | null = null;
    function down(e: PointerEvent) {
      start = e.isPrimary && e.button === 0 ? e : null;
    }
    function move(e: PointerEvent) {
      if (
        start?.pointerId === e.pointerId &&
        Math.hypot(e.clientX - start.clientX, e.clientY - start.clientY) > 5
      )
        start = null;
    }
    function cancel() {
      start = null;
    }
    function up(e: PointerEvent) {
      const origin = start;
      start = null;
      if (
        !origin ||
        e.pointerId !== origin.pointerId ||
        Math.hypot(e.clientX - origin.clientX, e.clientY - origin.clientY) > 5
      )
        return;
      const rect = canvas.getBoundingClientRect();
      const pointer = new Vector2(
        ((e.clientX - rect.left) / rect.width) * 2 - 1,
        1 - ((e.clientY - rect.top) / rect.height) * 2,
      );
      useGuide.getState().selectShelf(model.pick(pointer, camera));
    }
    const lost = () => setFailed(true);
    canvas.addEventListener("webglcontextlost", lost);
    canvas.addEventListener("pointerdown", down);
    canvas.addEventListener("pointermove", move);
    canvas.addEventListener("pointercancel", cancel);
    canvas.addEventListener("pointerup", up);
    return () => {
      unsubscribe();
      observer.disconnect();
      canvas.removeEventListener("pointerdown", down);
      canvas.removeEventListener("pointerup", up);
      canvas.removeEventListener("pointermove", move);
      canvas.removeEventListener("pointercancel", cancel);
      canvas.removeEventListener("webglcontextlost", lost);
      controls.dispose();
      model.dispose();
      renderer.dispose();
      renderer.forceContextLoss();
      canvas.remove();
    };
  }, [floor, failed]);
  return failed ? (
    <>
      <p role="status">三维视图不可用，已显示平面图。</p>
      <FloorPlan floor={floor} />
    </>
  ) : (
    <div className="model-view" ref={mount} aria-label={`${floor} 三维模型`} role="img" />
  );
}
