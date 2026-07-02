# React Team Review Standards (Cdiscount / Octopia front)

These standards are distilled from **real code-review feedback** on the team's React/TypeScript
codebases (`seller-portal`, `sales-channel-back-office`) and **cross-checked against official
documentation**. Apply them proactively when writing or reviewing React code — they are the
conventions the team enforces in review, so following them upfront avoids review round-trips.

Each rule states the convention, links its authoritative source, and shows a short ✅/❌ example.
The recurring reviewer feedback these encode: *"handle it with react-hook-form + zod"*, *"pass
`onSuccess` at the `mutate`"*, *"this extra state is overkill"*, *"pass the object, that's a lot of
props"*, *"reuse your `ThreadRecipient` type"*, *"isn't there a const for this?"*, *"use `within` /
a test-id"*, *"a test is missing here"*, *"keep the buttons iso, don't resize icons by hand"*.

> Scope note: sections 1, 8 (`onBlur`, `@cdiscount/design-system` iso components) are **team
> conventions**; the rest are general React/TypeScript/ecosystem best practices. When in doubt,
> match the surrounding codebase.

---

## 1. Forms — react-hook-form + zod (validate on blur)

Model form state and validation with **react-hook-form** and a **zod** schema via
`@hookform/resolvers`; do not hand-roll conditional validation in handlers or mirror errors in
`useState`. The team validates on **blur**.

Docs: [react-hook-form `useForm`](https://react-hook-form.com/docs/useform) (`mode`, `resolver`) ·
[@hookform/resolvers](https://github.com/react-hook-form/resolvers)

```tsx
// ✅ schema-driven, validate on blur
const form = useForm<MessageForm>({
  mode: 'onBlur',
  resolver: zodResolver(messageSchema),
});

// ❌ manual conditionals + useState error flags to decide validity
const [error, setError] = useState('');
if (!message && recipient === 'operator') setError('required');
```

## 2. Data fetching / mutations — TanStack Query

Pass **UI-scoped** side-effects (`onSuccess`/`onError`) to the **`mutate()` call site**, not threaded
down as a prop. Do **not** redeclare the default handler when you don't change it. Keep **critical
logic that must survive unmount** (e.g. cache invalidation) on `useMutation`, because callbacks passed
to `mutate()` **do not run if the component unmounts** before the mutation settles.

Docs: [TanStack Query — Mutations](https://tanstack.com/query/latest/docs/framework/react/guides/mutations) ·
[useMutation](https://tanstack.com/query/latest/docs/framework/react/reference/useMutation)

```tsx
// ✅ component-scoped effects at the call site
const { mutate, isPending } = useSendMessage();
const onSubmit = (values: MessageForm) =>
  mutate(values, { onSuccess: () => { snackbar.success(); reset(); } });

// ✅ invalidation stays on the hook (persists across unmount)
useMutation({ mutationFn, onSuccess: () => queryClient.invalidateQueries({ queryKey }) });

// ❌ threading a callback through props, or restating the default onError
<MessageForm onSuccessCallback={handleSuccess} />
```

## 3. State — derive, reset declaratively, keep effects disciplined

If a value can be **computed from props/state during render**, don't store it in `useState`. Reset a
subtree with a **`key`** rather than juggling extra state. Use **one** effect and avoid effects that
duplicate render logic (multiple `useEffect` firing overlapping redirects is a bug). Exposing an
imperative `reset()`/`focus()` via `ref` + `useImperativeHandle` is a **last resort** — *"if you can
express something as a prop, you should not use a ref."*

Docs: [You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect) ·
[Choosing the State Structure](https://react.dev/learn/choosing-the-state-structure) ·
[Preserving and Resetting State](https://react.dev/learn/preserving-and-resetting-state) ·
[Synchronizing with Effects](https://react.dev/learn/synchronizing-with-effects) ·
[useImperativeHandle](https://react.dev/reference/react/useImperativeHandle)

```tsx
// ✅ derive during render
const fullName = `${firstName} ${lastName}`;
// ✅ reset the dropdown by remounting it
<ResponseTemplateDropdown key={sentCount} />

// ❌ redundant state synced by an effect
const [fullName, setFullName] = useState('');
useEffect(() => setFullName(`${firstName} ${lastName}`), [firstName, lastName]);
```

## 4. Props & composition — pass objects, avoid drilling

When a component takes many fields of the same entity, pass the **object** (`thread`) instead of many
scalar props. Keep to **≤ 3–4 scalar props**, otherwise group into an object. Forward props with
spread **sparingly**; deep prop drilling belongs in **Context**.

Docs: [Passing Props to a Component](https://react.dev/learn/passing-props-to-a-component) ·
[Passing Data Deeply with Context](https://react.dev/learn/passing-data-deeply-with-context)

```tsx
// ✅
<ThreadHeader thread={thread} />
// ❌ "that's a lot of props"
<ThreadHeader id={thread.id} title={thread.title} status={thread.status} receiver={thread.receiver} />
```

## 5. TypeScript — reuse existing types

Reuse (or derive from) the existing domain types; don't re-declare an equivalent inline type. If a
shape repeats, extract a named type.

```tsx
// ✅ reuse the domain type
function Row({ recipient }: { recipient: ThreadRecipient }) { /* … */ }
// ❌ re-deriving the same union/shape inline
function Row({ recipient }: { recipient: 'customer' | 'operator' }) { /* … */ }
```

## 6. Constants & enums — no magic literals

Use existing constants/enums instead of magic strings/numbers — *"it's always better to go through a
const; fewer fixes when the contract changes."*
**Nuance:** extract a constant for a **reused value or a contract**, **not** for a one-off value such
as a single-use test label (avoid over-abstraction).

```tsx
// ✅
if (recipient === THREAD_RECIPIENTS.CUSTOMER) { /* … */ }
// ❌ magic string
if (recipient === 'customer') { /* … */ }
```

## 7. i18n (react-i18next)

Build translation keys **from the enum value** (`kebabCase(value)`) rather than branching per case.
Use **`<Trans>`** whenever a translation embeds markup (`<strong>`, `<Link>`…); plain `t()` otherwise.
Reuse string helpers (`stringFormat`) instead of ad-hoc interpolation.

Docs: [react-i18next — Trans component](https://react.i18next.com/latest/trans-component)

```tsx
// ✅ key derived from the enum
t(`discussions.receiver.${kebabCase(eligibleReceivers)}`);
// ✅ markup-aware translation
<Trans i18nKey="discussions.thread.info.operator-only" />
// ❌ switch/if to pick a key; t() on a string that contains <strong>…</strong>
```

## 8. Design System (`@cdiscount/design-system`)

Keep components **iso**: never override an icon's size by hand; rely on DS props/tokens. **Reuse DS
components** (Table/DataGrid, Dialog, Tabs, Alert, Menu, Breadcrumbs, pickers…) instead of re-styling
MUI or raw elements.

```tsx
// ✅ default DS sizing
<Icon name="send" />
// ❌ manual sizing breaks iso
<Icon name="send" style={{ fontSize: 18 }} />
```

## 9. Tests (Testing Library)

- **Every behavior change ships a test**, placed **where the behavior lives** (don't add a test in an
  unmodified file).
- Cover **negative / complementary** cases (success ⇒ no snackbar; error ⇒ the text field keeps its
  value).
- **Scope** queries with `within()`. Prefer accessible queries (`ByRole`/`ByLabelText`); use
  **`data-testid` as an escape hatch** to avoid coupling to a child component's internals.
- **Name tests by behavior**, not by a technical term.

Docs: [Guiding Principles](https://testing-library.com/docs/guiding-principles/) ·
[within](https://testing-library.com/docs/dom-testing-library/api-within/) ·
[About Queries — priority](https://testing-library.com/docs/queries/about/) ·
[ByTestId (last resort)](https://testing-library.com/docs/queries/bytestid/)

```tsx
// ✅ scoped + behavior-named
const panel = screen.getByRole('region', { name: /discussion/i });
within(panel).getByRole('button', { name: /send/i });
it('does not show the alert when the recipient is the customer', () => { /* … */ });

// ❌ reaching into a child's structure; opaque test name
it('toggle test 1', () => { container.querySelector('.toggle > span > input'); });
```

## 10. Simplicity & type rigor

Remove no-op operations (e.g. `reverse()` before taking `[0]`). Mind return types — `Date.now()`
returns a **number**, not a string.

```tsx
// ✅
const latest = items[items.length - 1];
// ❌ pointless reverse before indexing a single element
const latest = [...items].reverse()[0];
```

## 11. TypeScript — type-only imports

Use `import type { … }` (or inline `import { type … }`) for imports used **only in type positions**,
so they are elided from the emitted JS. Enforced by `verbatimModuleSyntax` /
`@typescript-eslint/consistent-type-imports`.

Docs: [TypeScript — Type-Only Imports and Exports](https://www.typescriptlang.org/docs/handbook/modules/reference.html)

```tsx
// ✅
import type { ThreadRecipient } from './types';
import { sendMessage, type SendMessageArgs } from './api';
// ❌ value import for something only used as a type
import { ThreadRecipient } from './types';
```

## 12. Loading flags (TanStack Query v5)

Use **`isPending`** for the awaiting state (a mutation in flight, or a query's first load).
`isLoading` is derived as `isPending && isFetching`; `isInitialLoading` is **deprecated**.

Docs: [Migrating to v5](https://tanstack.com/query/latest/docs/framework/react/guides/migrating-to-v5)

```tsx
// ✅
const { mutate, isPending } = useMutation({ mutationFn });
<Button loading={isPending} onClick={() => mutate(payload)} />
// ❌ isInitialLoading / assuming isLoading covers a background refetch
```

## 13. Storybook

Assign **`fn()`** (spy from `storybook/test`) to action args so they are auto-spied; prefer it over
the string-based `action('name')`.

Docs: [Storybook — Actions](https://storybook.js.org/docs/essentials/actions)

```tsx
// ✅
import { fn } from 'storybook/test';
export const Default: Story = { args: { onSend: fn() } };
// ❌
export const Default: Story = { args: { onSend: action('onSend') } };
```

---

## Further reading (official sources)

**React**
- You Might Not Need an Effect — https://react.dev/learn/you-might-not-need-an-effect
- Choosing the State Structure — https://react.dev/learn/choosing-the-state-structure
- Preserving and Resetting State — https://react.dev/learn/preserving-and-resetting-state
- Synchronizing with Effects — https://react.dev/learn/synchronizing-with-effects
- Rules of Hooks — https://react.dev/reference/rules/rules-of-hooks
- useImperativeHandle — https://react.dev/reference/react/useImperativeHandle
- Passing Props to a Component — https://react.dev/learn/passing-props-to-a-component
- Passing Data Deeply with Context — https://react.dev/learn/passing-data-deeply-with-context

**Testing Library**
- Guiding Principles — https://testing-library.com/docs/guiding-principles/
- within — https://testing-library.com/docs/dom-testing-library/api-within/
- About Queries (priority) — https://testing-library.com/docs/queries/about/
- ByTestId — https://testing-library.com/docs/queries/bytestid/

**Ecosystem**
- TanStack Query — Mutations — https://tanstack.com/query/latest/docs/framework/react/guides/mutations
- TanStack Query — useMutation — https://tanstack.com/query/latest/docs/framework/react/reference/useMutation
- TanStack Query — Migrating to v5 — https://tanstack.com/query/latest/docs/framework/react/guides/migrating-to-v5
- react-hook-form — useForm — https://react-hook-form.com/docs/useform
- @hookform/resolvers — https://github.com/react-hook-form/resolvers
- react-i18next — Trans component — https://react.i18next.com/latest/trans-component
- TypeScript — Type-Only Imports and Exports — https://www.typescriptlang.org/docs/handbook/modules/reference.html
- Storybook — Actions — https://storybook.js.org/docs/essentials/actions
