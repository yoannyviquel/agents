# Node.js Developer Reference Guide

Detailed standards, patterns and best practices for Node.js backend implementation (JavaScript/TypeScript). Distilled from the community consensus (notably the *Node.js Best Practices* list, OWASP, and modern layered-architecture guidance) and adapted to the way this skill works.

## Table of Contents

1. [Project Structure](#project-structure)
2. [Clean Code Standards](#clean-code-standards)
3. [Async & the Event Loop](#async--the-event-loop)
4. [Error Handling](#error-handling)
5. [Configuration & Secrets](#configuration--secrets)
6. [Logging & Observability](#logging--observability)
7. [Input Validation](#input-validation)
8. [Security (OWASP)](#security-owasp)
9. [API & Service Patterns](#api--service-patterns)
10. [Testing Standards](#testing-standards)
11. [Git Workflow](#git-workflow)

## Project Structure

Organize **by feature/domain**, not by technical type. Each feature owns its layers and tests.

```
src/
├── users/                  # feature module
│   ├── users.controller.ts # transport (HTTP) — thin
│   ├── users.service.ts    # business logic — HTTP-agnostic
│   ├── users.repository.ts # data access — only place with queries
│   ├── users.schema.ts     # input validation schemas (Zod/Joi)
│   ├── users.model.ts      # domain types/entities
│   └── users.service.test.ts
├── orders/
│   └── ...
├── middleware/             # cross-cutting: auth, errorHandler, requestId
├── lib/                    # shared infra: db client, http client, logger
├── config/                 # typed, validated config loaded from env
├── app.ts                  # build the app/server (no listen)
└── server.ts               # bootstrap: load config, connect, listen
tests/
├── integration/
└── e2e/
```

**Principles:** separation of concerns, thin controllers, business logic in services, data access in repositories, dependency injection over deep singleton imports, and a clear app/server split so the app is testable without binding a port.

## Clean Code Standards

### Naming

```javascript
// Good
const userProfile = await getUserProfile(userId);
function calculateInvoiceTotal(lines, taxRate) { ... }
const MAX_RETRY_ATTEMPTS = 3;

// Bad
const up = await getUP(u);
function calc(l, t) { ... }
const max = 3;
```

- `camelCase` for variables/functions, `PascalCase` for classes/types, `UPPER_CASE` for constants.
- Booleans start with `is/has/can/should`.
- Files: `kebab-case` or the project's existing convention; one primary export concept per file.

### Function Design

- **Single responsibility**, under ~50 lines. Extract helpers.
- **≤ 3–4 parameters**; use an options object beyond that.
- **Return early** to reduce nesting.

```javascript
// Good — early returns, single responsibility
function assertCanCheckout(cart) {
  if (!cart) throw new AppError('Cart required', 400);
  if (cart.items.length === 0) throw new AppError('Cart is empty', 400);
  if (cart.total <= 0) throw new AppError('Invalid total', 400);
}
```

### DRY & Modules

- Extract repeated logic into named functions/modules.
- Prefer **named exports** over a default-exported object.
- Use `node:` prefixed imports for builtins (`import { readFile } from 'node:fs/promises'`).

```javascript
// Good
export function formatCurrency(amount, currency = 'EUR') {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency }).format(amount);
}
```

## Async & the Event Loop

`async/await` is the default. The event loop is single-threaded — never block it.

```javascript
// Good — await, with timeout and explicit error context
async function fetchInvoice(id, { signal } = {}) {
  const res = await fetch(`${API}/invoices/${id}`, {
    signal: signal ?? AbortSignal.timeout(5000),
  });
  if (!res.ok) throw new AppError(`Invoice fetch failed (${res.status})`, 502);
  return res.json();
}

// Bad — floating promise (unhandled), no error handling
function fetchInvoice(id) {
  fetch(`${API}/invoices/${id}`).then((r) => r.json()); // result lost, errors swallowed
}
```

**Rules:**
- `await` every promise, or explicitly handle it. No floating promises.
- Never use blocking `*Sync` fs calls or heavy CPU loops in request paths — stream, batch, or offload to **worker threads**/a queue.
- Run independent async work concurrently with `Promise.all`; use `Promise.allSettled` when partial failure is acceptable.
- Always bound outbound I/O with timeouts/`AbortSignal`; clean up timers, listeners and streams.

```javascript
// Good — concurrent, not sequential
const [user, orders] = await Promise.all([
  usersRepo.findById(id),
  ordersRepo.findByUser(id),
]);
```

## Error Handling

Distinguish **operational errors** (expected: bad input, not found, upstream down — recover/return a status) from **programmer errors** (bugs — crash and restart).

### A typed application error

```javascript
export class AppError extends Error {
  constructor(message, statusCode = 500, { code, cause, isOperational = true } = {}) {
    super(message, { cause });
    this.name = 'AppError';
    this.statusCode = statusCode;
    this.code = code;
    this.isOperational = isOperational;
    Error.captureStackTrace?.(this, AppError);
  }
}
```

### Centralized handling — one place logs and shapes the response

```javascript
// Express example — single error middleware, registered last
export function errorHandler(err, req, res, _next) {
  const isOperational = err instanceof AppError && err.isOperational;
  const status = isOperational ? err.statusCode : 500;

  req.log.error({ err, reqId: req.id }, 'request failed');

  res.status(status).json({
    error: {
      message: isOperational ? err.message : 'Internal Server Error',
      code: err.code,
      requestId: req.id,
    },
  });
}
```

- Controllers `throw` (or pass to `next`); do **not** scatter try/catch. In Express 4, wrap async handlers (`asyncHandler`) so rejections reach the middleware; Express 5/Fastify/Nest forward them automatically.
- Never swallow an error by returning `null`. If you catch, you either recover meaningfully or rethrow with context (use `{ cause }`).
- Handle process-level safety nets — log fatally and exit so the supervisor restarts:

```javascript
process.on('unhandledRejection', (reason) => { logger.fatal({ reason }, 'unhandledRejection'); process.exit(1); });
process.on('uncaughtException', (err) => { logger.fatal({ err }, 'uncaughtException'); process.exit(1); });
```

## Configuration & Secrets

- **Never hardcode secrets.** Load from environment / secret manager.
- Validate config **once at startup** with a schema and fail fast; export a typed, frozen config object.

```javascript
import { z } from 'zod';

const Env = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  PORT: z.coerce.number().default(3000),
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(32),
});

export const config = Object.freeze(Env.parse(process.env)); // throws → process won't start misconfigured
```

- Different config per environment; no production secrets in the repo or in logs.

## Logging & Observability

- Use a **structured JSON logger** (`pino`, `winston`) — never `console.log` in production code.
- Log levels: `error/warn/info/debug`. Attach a **correlation/request id** to every log line.
- **Never log secrets or PII** (passwords, tokens, card numbers) — redact.
- Expose health/readiness endpoints; emit metrics where the platform expects them.

```javascript
import pino from 'pino';
export const logger = pino({ level: config.NODE_ENV === 'production' ? 'info' : 'debug' });
```

## Input Validation

Validate and parse **all** external input at the boundary (body, params, query, headers, env, message payloads) before it reaches a service.

```javascript
import { z } from 'zod';

export const createUserSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  name: z.string().min(1).max(100),
});

// in the controller
const dto = createUserSchema.parse(req.body); // throws → mapped to 400 by error handler
const user = await usersService.create(dto);
```

- Reject unknown fields, enforce types/ranges, normalize before use.
- Validation errors are operational → 400 with a clear message.

## Security (OWASP)

- **Validate & sanitize** every input; never trust the client. Prevent injection — use **parameterized queries**/ORM bindings, never string-built SQL.
- **No secrets in code or logs.** Rotate, least privilege.
- **HTTP hardening:** `helmet` (security headers), CORS allowlist, body size limits, rate limiting / brute-force protection on auth.
- **Auth:** hash passwords with `argon2` or `bcrypt` (never plain/`md5`/`sha1`); short-lived JWTs + refresh; validate and scope tokens.
- **Avoid dangerous APIs:** no `eval`, no dynamic `require`/`child_process` on user input, avoid prototype pollution (`Object.create(null)`, guard `__proto__`).
- **Dependencies:** run `npm audit` / Dependabot; pin and patch; remove unused deps.
- **Errors don't leak internals:** generic message + status for non-operational errors; details only in logs.

## API & Service Patterns

### Thin controller → service → repository

```javascript
// users.controller.ts — transport only
export async function createUser(req, res) {
  const dto = createUserSchema.parse(req.body);
  const user = await usersService.create(dto);   // delegate
  res.status(201).json({ data: user });           // shape response
}

// users.service.ts — business logic, HTTP-agnostic
export class UsersService {
  constructor(private readonly repo, private readonly hasher) {}
  async create(dto) {
    if (await this.repo.existsByEmail(dto.email)) {
      throw new AppError('Email already registered', 409, { code: 'EMAIL_TAKEN' });
    }
    const passwordHash = await this.hasher.hash(dto.password);
    return this.repo.insert({ ...dto, passwordHash });
  }
}

// users.repository.ts — data access only (parameterized)
export class UsersRepository {
  constructor(private readonly db) {}
  existsByEmail(email) {
    return this.db.user.count({ where: { email } }).then((n) => n > 0);
  }
  insert(data) { return this.db.user.create({ data }); }
}
```

### Consistent response shape & status codes

```javascript
// Success: { data, meta? }   Error: { error: { message, code, requestId } }
// 200 ok · 201 created · 204 no content · 400 validation · 401 auth · 403 forbidden
// 404 not found · 409 conflict · 422 unprocessable · 429 rate limit · 5xx server
```

### Graceful shutdown

```javascript
const server = app.listen(config.PORT);
for (const signal of ['SIGTERM', 'SIGINT']) {
  process.on(signal, async () => {
    server.close();        // stop accepting new connections
    await db.disconnect(); // drain + close resources
    process.exit(0);
  });
}
```

## Testing Standards

See [resources/testing-standards.md](resources/testing-standards.md) for full detail. Essentials:

- **Unit** (most): services and pure functions, repositories/clients mocked.
- **Integration** (some): routes via `supertest`, repositories against a real/in-memory DB or testcontainers.
- **E2E** (few): critical flows end to end.
- 80%+ coverage overall, 90%+ on critical paths (auth, payments, mutations). Test happy path, edge cases, error conditions. Keep tests independent and deterministic (fake timers, seeded data, clean up).

## Git Workflow

### Conventional Commits

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`.

```
feat(auth): add login endpoint with JWT issuance
fix(orders): prevent N+1 query when loading line items
refactor(users): extract password hashing into a service
test(auth): cover invalid-credential and lockout paths
```

### Branches & commit size

- `feature/STORY-ID-short-description`, `fix/ISSUE-ID`, `hotfix/critical-issue`.
- Small, focused commits — one concern each; commit after each logical unit; push regularly.

## Summary

- Layered architecture, organized by feature; thin controllers, HTTP-agnostic services, isolated repositories.
- `async/await` everywhere; never block the event loop; bound I/O with timeouts.
- Operational vs programmer errors; one centralized error handler; never swallow errors.
- Validate all input at the boundary; never trust the client; OWASP hardening.
- Config & secrets from env, validated at startup; structured logging with correlation ids; no secrets/PII logged.
- 80%+ coverage; unit-heavy pyramid; deterministic, independent tests.
- Clean names, small functions, DRY; Conventional Commits; leave code better than you found it.

For more, see:
- [resources/clean-code-checklist.md](resources/clean-code-checklist.md)
- [resources/testing-standards.md](resources/testing-standards.md)
- [templates/code-review.template.md](templates/code-review.template.md)
