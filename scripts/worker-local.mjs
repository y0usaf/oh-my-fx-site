// Local harness for worker/worker.js — runs the same handler locally on PORT
// (default 8788) with GATEWAY_KEY from the environment or worker/.dev.vars.
// This is a test stand-in for `wrangler dev`; it exercises the exact fetch
// handler that deploys, minus Cloudflare-specific bindings.
import http from "node:http";
import { readFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import worker from "../worker/worker.js";

function loadEnv() {
  const env = { ...process.env };
  const devVars = fileURLToPath(new URL("../worker/.dev.vars", import.meta.url));
  if (existsSync(devVars)) {
    for (const line of readFileSync(devVars, "utf8").split("\n")) {
      const m = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*?)\s*$/);
      if (m && !(m[1] in env)) env[m[1]] = m[2].replace(/^["']|["']$/g, "");
    }
  }
  return env;
}

const env = loadEnv();
const port = Number(env.PORT || 8788);

const server = http.createServer(async (req, res) => {
  const chunks = [];
  for await (const c of req) chunks.push(c);
  const body = chunks.length ? Buffer.concat(chunks) : undefined;
  const r = new Request(`http://127.0.0.1:${port}${req.url}`, {
    method: req.method,
    headers: req.headers,
    body: ["GET", "HEAD"].includes(req.method) ? undefined : body,
    duplex: body ? "half" : undefined,
  });
  const resp = await worker.fetch(r, env);
  res.writeHead(resp.status, Object.fromEntries(resp.headers));
  res.end(Buffer.from(await resp.arrayBuffer()));
});

server.listen(port, () => {
  console.log(`worker harness on :${port} → ${env.UPSTREAM_BASE || "https://ai-gateway.vercel.sh"}`);
});
