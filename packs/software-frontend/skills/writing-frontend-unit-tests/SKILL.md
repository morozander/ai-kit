---
name: writing-frontend-unit-tests
description: Project conventions for writing Vitest unit and component tests in the the project frontend. Load when writing, reviewing, or refactoring tests for React components, custom hooks, Apollo queries/mutations, Zustand stores, Zod schemas, or pure utilities.
---

# Writing Frontend Unit Tests

Project standard: **Vitest 4 + node (default) / jsdom (components) + `@testing-library/react`**. Use this skill whenever you write or review a `*.test.ts` / `*.test.tsx` file. Deeper background in [`references/vitest-writing-tests-with-ai.md`](./references/vitest-writing-tests-with-ai.md).

---

## 1. Stack

| Concern             | Choice                                                |
| ------------------- | ----------------------------------------------------- |
| Runner              | `vitest` (v4)                                         |
| Default environment | `node`                                                |
| DOM (selective)     | `jsdom` via `environmentMatchGlobs` or file directive |
| Component rendering | `@testing-library/react` (v16)                        |
| User interaction    | `@testing-library/user-event` (v14)                   |
| DOM matchers        | `@testing-library/jest-dom`                           |
| Apollo mocking      | `@apollo/client/testing/react` (`MockedProvider`)     |
| Canvas mocking      | `vitest-canvas-mock` (renderer tests)                 |
| Coverage            | `v8` provider                                         |

### Actual `vitest.config.ts`:

```ts
import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";
import path from "path";

export default defineConfig({
  plugins: [react()],
  test: {
    environment: "node",
    setupFiles: ["./src/test/setup.ts"],
    globals: true,
    include: ["src/**/__tests__/**/*.test.{ts,tsx}"],
    exclude: ["node_modules/**", ".claude/**"],
    passWithNoTests: true,
    environmentMatchGlobs: [
      ["src/features/case-board/renderer/**/*.test.{ts,tsx}", "jsdom"],
      ["src/features/case-board/hooks/**/*.test.{ts,tsx}", "jsdom"],
      ["src/features/case-board/pages/**/*.test.{ts,tsx}", "jsdom"],
      ["src/features/case-board/components/**/*.test.{ts,tsx}", "jsdom"],
      ["src/features/notebook/**/*.test.{ts,tsx}", "jsdom"],
      ["src/features/timeline/__tests__/*.test.{ts,tsx}", "jsdom"],
    ],
    coverage: {
      provider: "v8",
      reporter: ["text", "json-summary"],
      include: ["src/features/notebook/**/*.{ts,tsx}"],
      exclude: ["src/test/**", "src/**/*.test.{ts,tsx}", "src/**/*.d.ts"],
    },
  },
  resolve: {
    alias: [{ find: "@", replacement: path.resolve(__dirname, "src") }],
  },
});
```

### Setup files

- `src/test/setup.ts` — imports `@testing-library/jest-dom/vitest`
- `src/features/case-board/renderer/__tests__/setup.ts` — imports `vitest-canvas-mock` (for canvas-dependent renderer tests)

---

## 2. File location & naming

- **Tests live in `__tests__/` folders** adjacent to the source module they test.
- Pattern: `src/features/notebook/stores/__tests__/studio-store.test.ts` tests `src/features/notebook/stores/studio-store.ts`.
- The include glob is `src/**/__tests__/**/*.test.{ts,tsx}` — tests outside `__tests__/` folders will NOT be picked up.
- One file under test per test file.
- Shared test utilities live in `src/test/` (e.g., `setup.ts`, `smoke.test.ts`).

### Directory pattern examples

```
src/features/case-board/
├── model/
│   ├── filter-engine.ts
│   └── __tests__/
│       └── filter-engine.test.ts
├── stores/
│   ├── view-persistence-store.ts
│   └── __tests__/
│       └── view-persistence-store.test.ts
├── hooks/
│   ├── use-staged-changes.ts
│   └── __tests__/
│       └── use-staged-changes.test.ts
└── components/
    ├── BoardCanvas.tsx
    └── __tests__/
        └── BoardCanvas.test.tsx
```

---

## 3. Environment selection

The default test environment is **`node`** (faster, no DOM overhead). Component and hook tests that need DOM use jsdom via one of two mechanisms:

1. **`environmentMatchGlobs`** in vitest config — auto-applies jsdom to paths matching the globs listed above.
2. **Per-file directive** — add `// @vitest-environment jsdom` as the very first line of a test file when the path is NOT already covered by `environmentMatchGlobs`.

**Rule**: If your test renders components, hooks with DOM, or touches `window`/`document`, ensure jsdom is active. Pure logic/utility tests should stay in `node` environment.

---

## 4. Run commands

| Command                                            | Purpose                      |
| -------------------------------------------------- | ---------------------------- |
| `yarn vitest run`                                  | Single run (CI, agents)      |
| `yarn vitest run src/path/__tests__/file.test.tsx` | Single file                  |
| `yarn vitest`                                      | Watch mode (interactive dev) |

**Agents must always use `vitest run`** — never the watch default.

---

## 5. Core principles

1. **Test behavior, not implementation.** Assert on rendered output, return values, thrown errors. Never on whether an internal method was called in a specific order.
2. **One concept per test.** Short names: `'renders empty state'`, `'submits payload on valid form'`. Not full sentences.
3. **Query priority** (RTL): `getByRole` > `getByLabelText` > `getByText` > `getByTestId`. `data-testid` is last resort.
4. **`userEvent` over `fireEvent`.** Always create per-test: `const user = userEvent.setup()`. Use `fireEvent` only for low-level events that `userEvent` doesn't cover (e.g., `keyDown` with custom `selectionStart`).
5. **Async**: prefer `findBy*` and `waitFor`. Never `setTimeout` in tests. Use `vi.useFakeTimers()` to advance time.
6. **Arrange–Act–Assert.** Visible blank lines between phases.
7. Test the public contract. A test that breaks on harmless refactor is a bad test.

---

## 6. Project-specific patterns

### Apollo hooks & components

Use `MockedProvider` from `@apollo/client/testing/react` (note: **not** `@apollo/client/testing`).

```tsx
// @vitest-environment jsdom
import { renderHook, waitFor } from "@testing-library/react";
import { MockedProvider } from "@apollo/client/testing/react";
import { useGetCaseBasics, GET_CASE_BASICS } from "../useGetCaseBasics";

const MOCK_CASE_ID = "case-123";

const mocks = [
  {
    request: {
      query: GET_CASE_BASICS,
      variables: { caseDetailsInput: { caseId: MOCK_CASE_ID } },
    },
    result: {
      data: {
        caseDetails: {
          title: "Operation Tideline",
          caseNumber: "2026-SVU-0847",
        },
      },
    },
  },
];

function wrapper({ children }: { children: React.ReactNode }) {
  return <MockedProvider mocks={mocks}>{children}</MockedProvider>;
}

describe("useGetCaseBasics", () => {
  it("returns case name and number", async () => {
    const { result } = renderHook(() => useGetCaseBasics(MOCK_CASE_ID), {
      wrapper,
    });
    await waitFor(() => expect(result.current.loading).toBe(false));
    expect(result.current.caseName).toBe("Operation Tideline");
  });

  it("skips query when caseId is empty", () => {
    const { result } = renderHook(() => useGetCaseBasics(""), { wrapper });
    expect(result.current.loading).toBe(false);
  });
});
```

For mutations:

```tsx
import { renderHook, waitFor, act } from "@testing-library/react";
import { MockedProvider } from "@apollo/client/testing/react";

it("resolves with success on mutation", async () => {
  const { result } = renderHook(() => useMyMutation(), { wrapper });

  await act(async () => {
    const [mutate] = result.current;
    const response = await mutate({ variables: { id: "123" } });
    expect(response.data?.myMutation.success).toBe(true);
  });

  await waitFor(() => expect(result.current[1].loading).toBe(false));
});
```

### Mocking Apollo Client directly (stores that import `apolloClient`)

When a store/module imports `apolloClient` directly (not via hooks), mock the module:

```ts
const mockApolloQuery = vi.fn();
const mockApolloMutate = vi.fn();
vi.mock("@/api/graphql/client/client", () => ({
  apolloClient: {
    query: (...args: unknown[]) => mockApolloQuery(...args),
    mutate: (...args: unknown[]) => mockApolloMutate(...args),
  },
}));
```

### Zustand stores

Stores are testable as plain modules. Reset state before each test with a full initial state object:

```ts
import { describe, it, expect, beforeEach } from "vitest";
import { useStudioStore } from "../studio-store";

const initialState = {
  artifacts: [],
  selectedArtifactId: null,
  isGenerating: false,
  notebookId: null,
};

describe("useStudioStore", () => {
  beforeEach(() => {
    useStudioStore.setState(initialState);
  });

  it("starts with correct defaults", () => {
    const state = useStudioStore.getState();
    expect(state.artifacts).toEqual([]);
    expect(state.selectedArtifactId).toBeNull();
  });

  it("addArtifact prepends to list", () => {
    useStudioStore.getState().addArtifact(makeArtifact({ id: "new" }));
    expect(useStudioStore.getState().artifacts[0].id).toBe("new");
  });
});
```

### Factory helpers

The project heavily uses typed factory functions to create test data. Define them at the top of the test file:

```ts
function makeNode(overrides: Partial<GraphNode> = {}): GraphNode {
  return {
    id: "node-1",
    entityType: "person",
    entitySubtype: "",
    label: "Test Node",
    supportingEvidence: [],
    ...overrides,
  } as unknown as GraphNode;
}

function makeArtifact(overrides: Partial<StudioArtifact> = {}): StudioArtifact {
  return {
    id: "a0000000-0000-0000-0000-000000000001",
    type: "affidavit",
    title: "Test Artifact",
    status: "draft",
    createdAt: "2026-01-01T00:00:00.000Z",
    ...overrides,
  };
}
```

**Pattern**: `make<Entity>(overrides)` — provides sensible defaults, allows per-test overrides via spread.

### Mocking Zustand selectors in component tests

When a component uses `useMyStore(selector)`, mock the store module and implement the selector pattern:

```tsx
const mockSetMessages = vi.fn();

vi.mock("../../../stores/chat-store", () => ({
  useChatStore: vi.fn((selector) => {
    if (typeof selector === "function") {
      return selector({
        messages: [],
        setMessages: mockSetMessages,
        notebookId: null,
      });
    }
    return { messages: [], setMessages: mockSetMessages, notebookId: null };
  }),
}));

import { useChatStore } from "../../../stores/chat-store";

beforeEach(() => {
  vi.mocked(useChatStore).mockImplementation((selector) => {
    if (typeof selector === "function") {
      return (selector as (s: StoreState) => unknown)({
        messages: [],
        setMessages: mockSetMessages,
        notebookId: null,
      });
    }
    return { messages: [], setMessages: mockSetMessages, notebookId: null };
  });
});
```

### React Hook Form + Zod

Test the form as a unit. Drive inputs with `userEvent`, submit, assert on the resulting payload or rendered error message. Do **not** unit-test the Zod resolver in isolation — exercise it through the form.

### MUI components

Query by role/text, never by emotion-generated class name. Wrap in `ThemeProvider` only when the component reads theme tokens at runtime in a way that affects assertions.

### React Router 7

Wrap with `MemoryRouter` and `initialEntries`. Assert navigation by reading the resulting URL via a small location-spy route, not by mocking the router.

### Third-party library mocking (Tiptap, etc.)

Mock heavy third-party libraries at the module level:

```tsx
vi.mock("@tiptap/react", () => ({
  useEditor: () => ({
    getHTML: () => "<p>content</p>",
    commands: { setContent: vi.fn() },
  }),
  EditorContent: () => <div data-testid="editor-content">Editor content</div>,
}));

vi.mock("@tiptap/starter-kit", () => ({ default: {} }));
```

### Pure utility functions

Test directly with no providers or DOM — these run in `node` environment by default:

```ts
import { describe, it, expect } from "vitest";
import { getConfidenceTier, getConfidenceColor } from "../utils/confidence";

describe("getConfidenceTier", () => {
  it("returns high for values >= 90", () => {
    expect(getConfidenceTier(90)).toBe("high");
    expect(getConfidenceTier(100)).toBe("high");
  });

  it("returns low for values < 70", () => {
    expect(getConfidenceTier(50)).toBe("low");
  });
});
```

---

## 7. Mocking rules

- Use `vi.fn()`, `vi.spyOn`, `vi.mock("path/to/module")`. **Never** `jest.fn`/`jest.mock`.
- **String path form** of `vi.mock` is the project convention: `vi.mock("@/path/to/module", () => ({...}))`.
- `vi.mock` calls are **hoisted** — place them before imports of the mocked module. The import still works because Vitest hoists mocks to the top.
- Use `vi.mocked(fn)` for type-safe access to mock internals.
- Mock at boundaries only: network (via `MockedProvider` or direct apollo mock), time (`vi.useFakeTimers`), `window.location`, `console.error` (suppress + assert), `Date.now`.
- Don't mock the module under test. Don't mock pure utilities. Don't mock React.
- For `console.error` suppression: `vi.spyOn(console, "error").mockImplementation(() => {})` — always restore.

---

## 8. What NOT to test

- MUI, React, Apollo, RHF, Zod internals.
- Anything in `src/api/graphql/generated/` — that's codegen output.
- Styled wrappers with no logic (pure JSX + `sx`).
- Large component snapshots. Use `toMatchInlineSnapshot` only for short formatted output.
- Trivial getters or pass-through functions.

---

## 9. Writing tests with AI

When prompting an agent (or yourself) to generate tests:

- **Provide**: the source file, one sibling test file (style anchor), relevant type definitions.
- **Specify scenarios**: validation errors, happy path, empty/null inputs, network failure, boundary values.
- **Constrain**: "Use Vitest, not Jest. Use `userEvent`. Query by role. Don't add snapshot tests. Put in `__tests__/` folder."
- **Iterate**: if output mocks too much, reply "rewrite to test the integration without mocking module X."

Always run the generated tests before committing. Review for:

1. Meaningful assertions (not just `expect(x).toBeDefined()`).
2. Behavior — does the test survive a non-breaking refactor?
3. Real edge cases — empty, null, error paths.
4. No `jest.*` leakage, no leftover `console.log`, no `.only` / `.skip`.
5. Correct environment — `// @vitest-environment jsdom` if needed and not covered by config globs.

---

## 10. Common pitfalls

- **Wrong `MockedProvider` import**: Use `@apollo/client/testing/react`, not `@apollo/client/testing`.
- **Missing jsdom environment**: If your test renders components and you see `document is not defined`, add `// @vitest-environment jsdom` as the first line OR ensure the path matches `environmentMatchGlobs`.
- **Tests in wrong location**: Files must be in `__tests__/` folders matching the include glob `src/**/__tests__/**/*.test.{ts,tsx}`.
- **Jest API leakage**: `jest.fn()`, `jest.mock(...)`. Replace with `vi.*`.
- **Verbose test names**: `'should correctly render the user profile card when given a valid user object'` → `'renders user profile'`.
- **Watch mode hangs in CI/agents**: always `vitest run`.
- **Over-mocking**: every dependency mocked + assertions on call order = brittle. Mock at the edge, run the real code in between.
- **`act` warnings**: usually means an async update was not awaited. Use `findBy*` / `await waitFor`, not manual `act`.
- **Query selectors on MUI classes**: `.MuiButton-root` is implementation. Use `getByRole('button', { name: /save/i })`.
- **Not resetting Zustand state**: Always provide full initial state in `beforeEach` — partial resets can leak between tests.
- **Mock hoisting confusion**: `vi.mock` is hoisted. Declare mock fns (`const mockFn = vi.fn()`) before the `vi.mock` call that references them. Import the mocked module after the `vi.mock` block.

---

## 11. Vitest-specific APIs used in this project

```ts
// Explicit imports (globals: true makes these optional, but the project imports them explicitly)
import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";

// Mocking
vi.mock("@/path/to/module", () => ({ export: vi.fn() }));
vi.mocked(fn); // typed mock access
vi.spyOn(object, "method");
vi.useFakeTimers();
vi.restoreAllMocks();
vi.clearAllMocks();

// Matchers used
expect(x).toBe(y);
expect(x).toEqual(y);
expect(x).toBeNull();
expect(x).toBeTruthy();
expect(x).toHaveLength(n);
expect(x).toHaveBeenCalledOnce();
expect(x).toHaveBeenCalledWith(args);
expect(x).toMatchObject(partial);
expect(x).not.toHaveBeenCalled();
expect(() => fn()).not.toThrow();

// RTL
expect(screen.getByText("x")).toBeTruthy();
expect(screen.queryByText("x")).toBeNull();
expect(await screen.findByText("x")).toBeInTheDocument();
```

---

## 12. Examples

### Component with mocked dependencies

```tsx
// @vitest-environment jsdom
import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import { ChatInput } from "../ChatInput";

vi.mock("../../../stores/chat-store", () => ({
  useChatStore: vi.fn((selector) => {
    if (typeof selector === "function") {
      return selector({ messages: [], setMessages: vi.fn() });
    }
    return { messages: [], setMessages: vi.fn() };
  }),
}));

describe("ChatInput", () => {
  it("calls onSend with trimmed value on Enter", () => {
    const onSend = vi.fn();
    render(<ChatInput onSend={onSend} />);

    const textarea = screen.getByPlaceholderText("Start typing...");
    fireEvent.change(textarea, { target: { value: "  Hello  " } });
    fireEvent.keyDown(textarea, { key: "Enter", shiftKey: false });

    expect(onSend).toHaveBeenCalledWith("Hello");
  });

  it("does not send empty messages", () => {
    const onSend = vi.fn();
    render(<ChatInput onSend={onSend} />);

    const textarea = screen.getByPlaceholderText("Start typing...");
    fireEvent.change(textarea, { target: { value: "   " } });
    fireEvent.keyDown(textarea, { key: "Enter", shiftKey: false });

    expect(onSend).not.toHaveBeenCalled();
  });
});
```

### Hook with mocked model (renderHook)

```tsx
// @vitest-environment jsdom
import { describe, it, expect, vi } from "vitest";
import { renderHook, act } from "@testing-library/react";
import { useStagedChanges } from "../use-staged-changes";

function makeMockModel(changes = []) {
  return {
    getStagedChanges: vi.fn(() => changes),
    acceptChange: vi.fn(),
    rejectChange: vi.fn(),
  } as unknown as GraphModel;
}

describe("useStagedChanges", () => {
  it("returns empty array when model is null", () => {
    const { result } = renderHook(() => useStagedChanges(null));
    expect(result.current.stagedChanges).toEqual([]);
  });

  it("calls model.acceptChange with id", () => {
    const model = makeMockModel([{ id: "sc-1" }]);
    const { result } = renderHook(() => useStagedChanges(model));

    act(() => result.current.acceptChange("sc-1"));

    expect(model.acceptChange).toHaveBeenCalledWith("sc-1");
  });
});
```

### Zustand store

```ts
import { describe, it, expect, beforeEach } from "vitest";
import { useFilterStore } from "../filterStore";

const initialState = { filters: { archived: false, starred: false } };

beforeEach(() => useFilterStore.setState(initialState));

test("toggles filter", () => {
  useFilterStore.getState().toggle("archived");
  expect(useFilterStore.getState().filters.archived).toBe(true);
});
```

### Pure utility (node environment — no directive needed)

```ts
import { describe, it, expect } from "vitest";
import { FilterEngine } from "../filter-engine";

function makeNode(overrides = {}) {
  return { id: "n1", entityType: "person", label: "Test", ...overrides };
}

describe("FilterEngine", () => {
  const engine = new FilterEngine();

  it("empty spec passes all nodes", () => {
    const { nodePredicate } = engine.buildPredicates({});
    expect(nodePredicate(makeNode())).toBe(true);
  });

  it("entityTypes filter restricts by type", () => {
    const { nodePredicate } = engine.buildPredicates({
      entityTypes: ["person"],
    });
    expect(nodePredicate(makeNode({ entityType: "person" }))).toBe(true);
    expect(nodePredicate(makeNode({ entityType: "place" }))).toBe(false);
  });
});
```

### Async store with Apollo Client mock

```ts
import { describe, it, expect, vi, beforeEach } from "vitest";

const mockApolloQuery = vi.fn();
vi.mock("@/api/graphql/client/client", () => ({
  apolloClient: { query: (...args: unknown[]) => mockApolloQuery(...args) },
}));

import { useViewPersistenceStore } from "../view-persistence-store";

beforeEach(() => {
  useViewPersistenceStore.setState({ positions: {}, zoom: 1 });
  mockApolloQuery.mockReset();
});

it("load populates state from API response", async () => {
  mockApolloQuery.mockResolvedValueOnce({
    data: {
      boardView: { layout: { positions: { n1: { x: 10, y: 20 } }, zoom: 1.5 } },
    },
  });

  await useViewPersistenceStore.getState().load("view-1");

  expect(useViewPersistenceStore.getState().positions).toEqual({
    n1: { x: 10, y: 20 },
  });
  expect(useViewPersistenceStore.getState().zoom).toBe(1.5);
});
```

---

## 13. Definition of done

Before marking a test task complete:

- [ ] `vitest run <file>` passes locally.
- [ ] No `.only`, `.skip`, `console.log`, or commented-out tests.
- [ ] No `jest.*` references.
- [ ] At least one error/empty path covered.
- [ ] Names are short and behavior-describing.
- [ ] No snapshot of a large tree.
- [ ] Test file is in a `__tests__/` folder matching the include glob.
- [ ] Correct environment (jsdom directive or covered by config globs).
- [ ] Factory helpers used for test data (not inline object literals repeated across tests).
- [ ] `MockedProvider` imported from `@apollo/client/testing/react`.
