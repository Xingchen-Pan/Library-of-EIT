import { queryOptions } from "@tanstack/react-query";

interface Book {
  copy_id: string;
  title: string;
  shelf_id: string;
}
function isBook(value: unknown): value is Book {
  return (
    typeof value === "object" &&
    value !== null &&
    "copy_id" in value &&
    typeof value.copy_id === "string" &&
    "title" in value &&
    typeof value.title === "string" &&
    "shelf_id" in value &&
    typeof value.shelf_id === "string"
  );
}
export const catalogQuery = queryOptions({
  queryKey: ["sample-catalog", "v1"],
  queryFn: async ({ signal }): Promise<Book[]> => {
    const response = await fetch(`${import.meta.env.BASE_URL}data/catalog.json`, { signal });
    if (!response.ok) throw new Error("馆藏加载失败");
    const data: unknown = await response.json();
    if (!Array.isArray(data) || !data.every(isBook)) throw new Error("馆藏数据格式有误");
    return data;
  },
  staleTime: Infinity,
  retry: false,
});
