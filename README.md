# Browser Terminal Portfolio

A browser-based terminal that spawns isolated Docker containers for each visitor. Users can explore your projects using real tools like nvim, git, and standard Unix commands.

## Architecture

```
Browser (xterm.js) <--WebSocket--> Node Server <--Docker API--> Containers
```

Each visitor gets their own isolated container with:
- 256MB memory limit
- 50% CPU limit
- No network access
- Read-only access to your projects
- 15-minute session timeout
- Auto-cleanup on disconnect

## Local Development

### Prerequisites
- Node.js 20+
- Docker

### Setup

```bash
# Install dependencies
npm install

# Build the sandbox image
npm run docker:build

# Add your projects to the projects/ directory
cp -r /path/to/your/project ./projects/

# Run in development mode
npm run dev
```

Visit http://localhost:3000
