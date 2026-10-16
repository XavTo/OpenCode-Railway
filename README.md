# Deploy and Host OpenCode on Railway

OpenCode (Open Code) is an open-source AI coding agent. This template gives you the official OpenCode web interface, browser terminal and HTTP API in a private, persistent Railway workspace.

## About Hosting OpenCode

One service runs OpenCode **1.19.2**, the current stable release of the 1.x line, with a persistent volume at `/data`. Caddy exposes the service on Railway's HTTPS domain, forwards streaming responses and WebSockets, and provides a real readiness check. The agent runs as an unprivileged user. Git, Bash, Node.js, npm, Python, SSH client tools and ripgrep are installed for coding tasks.

Projects, Git repositories, conversations, provider credentials, configuration and caches survive container replacement. OpenCode uses its embedded SQLite storage; no separate database or Redis service is needed.

### Get started

1. Deploy the template. No AI key is required to start the web app.
2. In the **OpenCode** service's Variables tab, reveal `OPENCODE_SERVER_PASSWORD`.
3. Open the service's public Railway domain. Sign in with username `opencode` and that generated password.
4. Open the project directory **`/data/workspace`** or create/clone a repository inside it using the browser terminal. For example: `cd /data/workspace && git clone https://github.com/your-account/your-project.git`.
5. Connect your AI provider in OpenCode's interface, or add the provider's environment variable, such as `OPENAI_API_KEY` or `ANTHROPIC_API_KEY`, to the service and redeploy.
6. Choose a model and start a coding session. Any free models offered by OpenCode depend on upstream availability and limits.

Use `/data/workspace` or another directory **inside `/data`** for work you want to keep. Files elsewhere in the container are ephemeral.

### Persistent paths

| Path | Content |
| --- | --- |
| `/data/workspace` | Coding workspace and Git repositories |
| `/data/home` | Home directory, shell settings and SSH configuration |
| `/data/xdg/data/opencode` | OpenCode database, sessions and provider credentials |
| `/data/xdg/config/opencode` | Global OpenCode configuration |
| `/data/xdg/state/opencode` | Runtime state |
| `/data/xdg/cache/opencode` | Models metadata and downloaded tools |

### Variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `PORT` | `8080` | Public application port; keep the service domain's target port in sync |
| `OPENCODE_SERVER_USERNAME` | `opencode` | HTTP Basic Auth username |
| `OPENCODE_SERVER_PASSWORD` | `${{secret(32)}}` | Unique generated password; at least 16 characters |
| `OPENCODE_DISABLE_AUTOUPDATE` | `true` | Updates are made through the versioned template source |
| `RAILWAY_RUN_UID` | `0` | Allows initial volume ownership setup; the entrypoint then drops to UID 1000 |

AI provider keys are optional at deployment time. Provider configuration saved through the app also persists on the volume. Protect the generated password: access grants control of this coding environment and its provider credentials. This is a single-owner workspace, not an isolated multi-tenant hosting service. Agent tools can execute code within the container. Nested Docker and a full virtual machine are not included.

### Readiness and lifecycle

Railway checks **`/healthz`**. It proxies only to OpenCode's authenticated `/global/health` endpoint, so a healthy response requires the OpenCode server to be running. All other API and terminal connections retain OpenCode's own authentication. OpenCode listens only on `127.0.0.1:4096`; Caddy is the only public listener. No extra origins are allowed by default.

Both processes receive shutdown signals. If either exits, the service exits and Railway's restart policy applies. A persistent volume uses one replica and may cause a brief interruption during redeployment. Enable Railway volume backups for important work.

## Common Use Cases

- Run a private OpenCode AI coding agent from a browser, tablet or remote computer.
- Clone a repository, edit files, run scripts and inspect Git changes in a persistent workspace.
- Keep coding sessions and provider setup across restarts.
- Attach the OpenCode CLI or build integrations using the authenticated OpenCode API.

## Dependencies for OpenCode Hosting

- Railway service and volume resources.
- An AI model provider for agent tasks; model charges are separate from Railway hosting.

### Deployment Dependencies

- [Official OpenCode source and stable release](https://github.com/anomalyco/opencode/releases/tag/v1.19.2)
- [OpenCode web interface](https://docs.opencode.ai/docs/web/)
- [OpenCode server API](https://docs.opencode.ai/docs/server/)
- [Template source](https://github.com/XavTo/OpenCode-Railway)

## Why Deploy OpenCode on Railway?

Railway supplies HTTPS, a public domain, persistent storage, deployment logs and restart controls. This template combines those with the official OpenCode web app, generated authentication and a preinstalled coding toolchain so you can start a remote AI coding workspace with one service.
