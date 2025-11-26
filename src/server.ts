import express from "express";
import { createServer } from "http";
import { WebSocketServer, WebSocket } from "ws";
import Docker from "dockerode";
import { v4 as uuidv4 } from "uuid";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const server = createServer(app);
const wss = new WebSocketServer({ server });
const docker = new Docker();

const IMAGE_NAME = "terminal-sandbox";
const CONTAINER_TIMEOUT_MS = 15 * 60 * 1000; // 15 minutes
const MAX_CONTAINERS = 10;
const PROJECTS_PATH = process.env.PROJECTS_PATH || path.join(__dirname, "..", "projects");

interface Session {
  id: string;
  container: Docker.Container;
  stream: NodeJS.ReadWriteStream;
  ws: WebSocket;
  timeout: NodeJS.Timeout;
}

const sessions = new Map<string, Session>();

// Serve static files
app.use(express.static(path.join(__dirname, "..", "public")));

// Health check endpoint
app.get("/health", (_, res) => {
  res.json({ status: "ok", activeSessions: sessions.size });
});

async function createContainer(): Promise<Docker.Container> {
  const container = await docker.createContainer({
    Image: IMAGE_NAME,
    Tty: true,
    OpenStdin: true,
    StdinOnce: false,
    HostConfig: {
      Memory: 256 * 1024 * 1024, // 256MB
      MemorySwap: 256 * 1024 * 1024, // No swap
      CpuPeriod: 100000,
      CpuQuota: 50000, // 50% of one CPU
      PidsLimit: 50,
      ReadonlyRootfs: false, // Set to true for extra security
      NetworkMode: "none", // No network access
      Binds: [`${PROJECTS_PATH}:/home/visitor/projects:ro`], // Read-only mount
      AutoRemove: true,
    },
  });

  await container.start();
  return container;
}

async function cleanupSession(sessionId: string) {
  const session = sessions.get(sessionId);
  if (!session) return;

  clearTimeout(session.timeout);

  try {
    await session.container.stop({ t: 1 });
  } catch {
    // Container might already be stopped
  }

  try {
    await session.container.remove({ force: true });
  } catch {
    // Container might already be removed (AutoRemove: true)
  }

  sessions.delete(sessionId);
  console.log(`Session ${sessionId} cleaned up. Active sessions: ${sessions.size}`);
}

wss.on("connection", async (ws) => {
  // Check if we've hit the max containers
  if (sessions.size >= MAX_CONTAINERS) {
    ws.send("\r\n\x1b[31mServer is at capacity. Please try again later.\x1b[0m\r\n");
    ws.close();
    return;
  }

  const sessionId = uuidv4();
  console.log(`New connection: ${sessionId}`);

  try {
    const container = await createContainer();

    // Attach to container with TTY
    const stream = await container.attach({
      stream: true,
      stdin: true,
      stdout: true,
      stderr: true,
    });

    // Set up session timeout
    const timeout = setTimeout(() => {
      ws.send("\r\n\x1b[33mSession timed out. Goodbye!\x1b[0m\r\n");
      ws.close();
    }, CONTAINER_TIMEOUT_MS);

    const session: Session = { id: sessionId, container, stream, ws, timeout };
    sessions.set(sessionId, session);

    // Container output -> WebSocket
    stream.on("data", (data: Buffer) => {
      if (ws.readyState === WebSocket.OPEN) {
        ws.send(data);
      }
    });

    // WebSocket -> Container input
    ws.on("message", async (data: Buffer) => {
      const message = data.toString();

      // Handle resize messages
      if (message.startsWith("\x1b[8;")) {
        const match = message.match(/\x1b\[8;(\d+);(\d+)t/);
        if (match) {
          const rows = parseInt(match[1], 10);
          const cols = parseInt(match[2], 10);
          try {
            await container.resize({ h: rows, w: cols });
          } catch {
            // Resize might fail if container is stopping
          }
        }
        return;
      }

      stream.write(data);
    });

    ws.on("close", () => {
      console.log(`Connection closed: ${sessionId}`);
      cleanupSession(sessionId);
    });

    ws.on("error", (err) => {
      console.error(`WebSocket error for ${sessionId}:`, err);
      cleanupSession(sessionId);
    });

    console.log(`Session ${sessionId} started. Active sessions: ${sessions.size}`);
  } catch (err) {
    console.error("Failed to create container:", err);
    ws.send("\r\n\x1b[31mFailed to start terminal session. Please try again.\x1b[0m\r\n");
    ws.close();
  }
});

// Cleanup on shutdown
process.on("SIGINT", async () => {
  console.log("\nShutting down...");
  for (const [sessionId] of sessions) {
    await cleanupSession(sessionId);
  }
  process.exit(0);
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
  console.log(`Projects path: ${PROJECTS_PATH}`);
});
