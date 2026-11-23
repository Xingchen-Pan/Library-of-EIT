import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ConfigProvider } from "antd";
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { App } from "./App";
import "./style.css";

const root = document.getElementById("app");
if (!root) throw new Error("Missing application root");
const client = new QueryClient();
createRoot(root).render(
  <StrictMode>
    <ConfigProvider
      button={{ autoInsertSpace: false }}
      theme={{ token: { colorPrimary: "#285e4f", borderRadius: 6 } }}
    >
      <QueryClientProvider client={client}>
        <App />
      </QueryClientProvider>
    </ConfigProvider>
  </StrictMode>,
);
