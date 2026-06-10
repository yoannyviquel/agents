# Node.js Testing Standards

A guide to testing patterns, strategies and best practices for Node.js backends — achieving high-quality, trustworthy coverage.

## Table of Contents

1. [Testing Pyramid](#testing-pyramid)
2. [Tooling](#tooling)
3. [Unit Testing](#unit-testing)
4. [Integration Testing](#integration-testing)
5. [End-to-End Testing](#end-to-end-testing)
6. [Coverage Targets](#coverage-targets)
7. [Mocking Strategies](#mocking-strategies)
8. [Test Organization](#test-organization)
9. [Best Practices](#best-practices)

## Testing Pyramid

```
       /\
      /  \      E2E Tests (Few)        - full flow, real server + deps, slow/brittle
     /____\
    /      \    Integration (Some)     - routes via supertest, repos vs real/in-memory DB
   /________\
  /          \  Unit Tests (Many)      - services & pure functions, deps mocked, fast
 /____________\
```

**Distribution:** ~70% unit, ~20% integration, ~10% E2E.

The layered architecture makes this natural: **services** are unit-tested with mocked repositories (no I/O), **repositories and routes** are integration-tested against a real datastore, **critical journeys** get a thin E2E layer.

## Tooling

Match the project. Common Node stacks:

- **Test runner:** Vitest (fast, ESM-native, TS out of the box), Jest, or the built-in `node:test` + `node:assert`.
- **HTTP assertions:** `supertest` against the exported app (no bound port).
- **Real dependencies in integration:** `testcontainers` (ephemeral Postgres/Mongo/Redis) or an in-memory equivalent; a seeded test DB.
- **Coverage:** `c8`/built-in V8 coverage, Vitest `--coverage`, or Jest `--coverage`.

> Export the app separately from `listen()` so tests can drive it in-process:
> `app.ts` builds the app; `server.ts` calls `app.listen()`. Tests import `app`.

## Unit Testing

Verify a single unit (a service method, a pure function) in isolation. Mock repositories, clients and the clock. Fast, deterministic, no network/disk/DB.

### Testing a service (mocked repository)

```javascript
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { UsersService } from './users.service.js';
import { AppError } from '../lib/AppError.js';

describe('UsersService.create', () => {
  let repo, hasher, service;

  beforeEach(() => {
    repo = { existsByEmail: vi.fn(), insert: vi.fn() };
    hasher = { hash: vi.fn().mockResolvedValue('hashed') };
    service = new UsersService(repo, hasher);
  });

  it('creates a user when the email is free', async () => {
    repo.existsByEmail.mockResolvedValue(false);
    repo.insert.mockResolvedValue({ id: '1', email: 'a@b.co' });

    const user = await service.create({ email: 'a@b.co', password: 'secret12', name: 'A' });

    expect(user.id).toBe('1');
    expect(hasher.hash).toHaveBeenCalledWith('secret12');
    expect(repo.insert).toHaveBeenCalledWith(expect.objectContaining({ passwordHash: 'hashed' }));
  });

  it('rejects a duplicate email with 409', async () => {
    repo.existsByEmail.mockResolvedValue(true);

    await expect(service.create({ email: 'a@b.co', password: 'secret12', name: 'A' }))
      .rejects.toMatchObject({ statusCode: 409 });
    expect(repo.insert).not.toHaveBeenCalled();
  });
});
```

### Testing a pure function

```javascript
import { describe, it, expect } from 'vitest';
import { calculateDiscount } from './pricing.js';

describe('calculateDiscount', () => {
  it('computes the discount amount', () => {
    expect(calculateDiscount(100, 10)).toBe(10);
  });
  it('throws on an out-of-range percent', () => {
    expect(() => calculateDiscount(100, 150)).toThrow('between 0 and 100');
  });
});
```

### Testing async error paths

```javascript
it('wraps an upstream failure as a 502', async () => {
  vi.spyOn(globalThis, 'fetch').mockRejectedValue(new Error('ECONNREFUSED'));
  await expect(fetchInvoice('inv_1')).rejects.toMatchObject({ statusCode: 502 });
});
```

## Integration Testing

Verify layers working together: routes through the real middleware stack, repositories against a real datastore.

### HTTP routes with supertest

```javascript
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import request from 'supertest';
import { buildApp } from '../src/app.js';

describe('Auth API', () => {
  let app;
  beforeAll(async () => { app = await buildApp({ db: testDb }); });
  afterAll(async () => { await testDb.disconnect(); });

  it('logs in with valid credentials', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: 'user@example.com', password: 'password123' })
      .expect(200);

    expect(res.body.data).toHaveProperty('token');
  });

  it('rejects invalid credentials with 401', async () => {
    await request(app)
      .post('/api/auth/login')
      .send({ email: 'user@example.com', password: 'wrong' })
      .expect(401);
  });

  it('returns 400 on a malformed body', async () => {
    await request(app).post('/api/auth/login').send({ email: 'nope' }).expect(400);
  });
});
```

### Repository against a real DB (testcontainers)

```javascript
import { PostgreSqlContainer } from '@testcontainers/postgresql';

let container, db;
beforeAll(async () => {
  container = await new PostgreSqlContainer().start();
  db = await connect(container.getConnectionUri());
  await migrate(db);
});
afterAll(async () => { await db.end(); await container.stop(); });
afterEach(async () => { await db.query('TRUNCATE users CASCADE'); });

it('persists and retrieves a user', async () => {
  const repo = new UsersRepository(db);
  const created = await repo.insert({ email: 'x@y.co', passwordHash: 'h', name: 'X' });
  expect(await repo.existsByEmail('x@y.co')).toBe(true);
  expect(created.id).toBeDefined();
});
```

## End-to-End Testing

Few, high-value: exercise a critical journey against the running server and real dependencies. Keep them stable (seeded data, retries on readiness, no shared mutable state).

## Coverage Targets

- **Overall:** 80% minimum.
- **Critical paths:** 90%+ (authentication/authorization, payments, data mutations).
- **Pure utilities/services:** 95%+ (cheap to fully cover).
- **New code:** 90%+ — don't lower coverage with new changes.

**Test:** business logic, validation, error handling, auth, edge/boundary values, concurrency where it matters.
**Don't test:** third-party internals, trivial getters, generated code (migrations), config.

## Mocking Strategies

Mock at the **boundary** — repositories, HTTP/SDK clients, the clock, the file system, queues. Do **not** mock the unit under test.

```javascript
// Module mock (Vitest)
vi.mock('./lib/mailer.js', () => ({ sendEmail: vi.fn().mockResolvedValue(true) }));

// Fake timers for time-dependent logic
vi.useFakeTimers();
vi.setSystemTime(new Date('2026-01-01T00:00:00Z'));
// ... assert ...
vi.useRealTimers();

// Prefer injecting collaborators (constructor DI) over deep module mocks where possible —
// it keeps tests simple and the design decoupled.
```

> `node:test` equivalents: `mock.fn()`, `mock.method()`, `mock.timers.enable()`.

## Test Organization

```
src/
├── users/
│   ├── users.service.ts
│   └── users.service.test.ts      # unit, colocated
tests/
├── integration/
│   └── auth.test.ts               # supertest + DB
└── e2e/
    └── checkout.test.ts
```

- Files: `*.test.ts` / `*.spec.ts`.
- Structure each test **Arrange / Act / Assert**.
- Suites: `describe('UnitName', ...)`; cases: `it('should …', ...)`.

## Best Practices

1. **Descriptive names** — `it('rejects a duplicate email with 409')`, not `it('works')`.
2. **One behavior per test** — separate happy path, edge case, and error into their own `it`.
3. **Independent & deterministic** — no shared mutable state; reset DB/mocks in `beforeEach`/`afterEach`; fake the clock and randomness; never depend on test order.
4. **Test behavior, not implementation** — assert observable outcomes and contracts, not private internals (so refactors don't break tests).
5. **Cover edge cases** — null/empty, boundaries, invalid input, upstream failures, timeouts.
6. **Use builders/factories** — `makeUser({ age: 17 })` to keep tests focused.
7. **Clean up resources** — close servers, DB connections, containers, timers in `afterAll`.
8. **Keep them fast** — unit tests in milliseconds; isolate slow integration/E2E so the inner loop stays quick.

**Remember:** good tests give you the confidence to refactor and ship without fear. Test the contract of each layer, mock across boundaries, and keep the pyramid unit-heavy.
