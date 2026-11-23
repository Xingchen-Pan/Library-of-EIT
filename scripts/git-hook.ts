import { spawnSync } from "node:child_process";

const checksByHook: Record<string, string[]> = {
  "pre-commit": ["format:check"],
  "pre-push": ["format:check", "lint", "test"],
};

const hookName = process.argv[2];
const checks = hookName ? checksByHook[hookName] : undefined;

if (!checks) {
  console.error("Usage: bun run scripts/git-hook.ts <pre-commit|pre-push>");
  process.exit(1);
}

for (const check of checks) {
  const result = spawnSync(process.execPath, ["run", check], {
    stdio: "inherit",
  });

  if (result.error) {
    console.error(`Could not run ${check}: ${result.error.message}`);
    process.exit(1);
  }

  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }
}
