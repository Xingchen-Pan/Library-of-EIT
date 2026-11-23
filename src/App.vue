<script setup lang="ts">
import { ref } from "vue";

const count = ref(0);
</script>

<template>
  <main class="mx-auto flex min-h-screen max-w-2xl flex-col items-center justify-center gap-5 px-6 text-center">
    <p class="text-sm font-semibold uppercase tracking-[0.2em] text-blue-700">Library of EIT</p>
    <h1 class="text-4xl font-bold tracking-tight text-slate-900">Vue 3 + TypeScript</h1>
    <p class="max-w-lg text-slate-600">
      最小单页示例：使用 Vue 单文件组件、Vite 和 Tailwind CSS。
    </p>
    <button
      class="rounded-lg bg-blue-700 px-5 py-3 font-medium text-white transition hover:bg-blue-800 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-700"
      type="button"
      @click="count += 1"
    >
      点击次数：{{ count }}
    </button>
  </main>
</template>
