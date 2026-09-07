# Writing Tests with AI

AI coding assistants can help you write tests faster, but the quality of the output depends heavily on what you put in. A vague prompt produces vague tests. A specific prompt with the right context produces tests that are actually worth keeping.

This page covers how to get good test code from AI tools, and what to watch for when reviewing the results.

## Providing Context

The single most important thing you can do is give the AI enough context to understand what it's testing.

- **Start with the source file itself:** The AI needs to see the actual implementation, not just a description of what the function does. Include the full file, or at least the function you want tested along with its imports and types.
- **Share existing test files from the same project:** This helps the AI match your conventions: whether you use `test` or `it`, how you structure `describe` blocks, whether you prefer `test.extend` fixtures or `beforeEach`, and how you name your tests. AI tools are good at pattern matching, but they need patterns to match against.
- **Include your Vitest config:** Especially if you've enabled globals, set a custom environment, or configured `setupFiles`. Without this context, the AI might generate unnecessary imports, use the wrong test environment, or miss setup that your tests depend on.
- **Provide dependency signatures:** If the code under test has dependencies that need mocking, share those files too (or at least their type signatures). The AI can't write a useful mock for a database client it's never seen.

> 💡 **TIP** > If your project has an `AGENTS.md` or similar file with coding conventions, include that as well. Many AI tools pick up on these automatically and will follow the rules defined there.

---

## Writing Good Prompts

Specific prompts produce better tests than generic ones. Compare these two:

- **Vague:** `"Write tests for userService.js"`
- _Result:_ This will produce tests, but they'll likely be shallow: one happy-path test per function, minimal edge case coverage, and generic test names.

- **Better:** `"Write tests for the createUser function in userService.js. Cover validation errors (missing name, invalid email format, duplicate email), the successful creation path, and verify that the password is hashed before being stored."`
- _Result:_ This tells the AI exactly which function to focus on, which scenarios matter, and what behavior to verify. The output will be more thorough and more relevant.

### Tips for Better Prompts

1. **Ask for edge cases explicitly:** `"Include tests for empty inputs, boundary values, and error handling"` produces more comprehensive coverage than leaving it to the AI's judgment. Without this nudge, most tools will generate a handful of happy-path tests and stop there.
2. **Mention specific Vitest features if you want them used:** `"Use toMatchInlineSnapshot for the error messages"` or `"use test.each for the different currency formats"` guides the AI toward the right tools instead of letting it fall back to repetitive copy-paste tests.
3. **If you're testing async code, say so:** `"The function returns a Promise"` or `"this calls an external API"` helps the AI use `async/await` and appropriate matchers like `.resolves` and `.rejects`.
4. **Tell the AI what not to do:** `"Test against the real implementation, don't mock any modules"` or `"don't use snapshot tests"` prevents common defaults you don't want. AI tools tend to over-mock, and an explicit constraint prevents that.
5. **Describe the test structure you want:** `"Group tests by method using describe blocks"` or `"use test.extend fixtures for the database connection instead of beforeEach"` saves you from restructuring the output afterwards.
6. **Reference existing tests when asking for additions:** `"Follow the same style as the tests in auth.test.js"` is more effective than describing the style from scratch. The AI will pick up on naming conventions, assertion patterns, and import styles from the example.
7. **If the first result isn't right, iterate:** `"These tests are too focused on implementation details. Rewrite them to only assert on the return values and thrown errors"` is a valid follow-up. Refining through conversation often produces better results than trying to write the perfect prompt upfront.

---

## Reviewing AI-Generated Tests

AI-generated tests can look convincing at first glance but still have problems. Here's what to check before committing them.

### 1. Do the tests actually assert something meaningful?

Watch for tests that call a function but only check that it doesn't throw, or tests that assert on the mock itself rather than the behavior. A test like this gives false confidence:

```javascript
test("creates a user", () => {
  const user = createUser("Alice", "alice@example.com");
  expect(user).toBeDefined(); // this passes for almost anything
});
```

A better assertion checks the actual properties:

```javascript
test("creates a user with the correct fields", () => {
  const user = createUser("Alice", "alice@example.com");
  expect(user).toMatchObject({
    name: "Alice",
    email: "alice@example.com",
  });
  expect(user.id).toBeTypeOf("string");
});
```

### 2. Are they testing behavior or implementation?

AI tends to over-mock. If you see a test that mocks every dependency and then asserts that specific internal methods were called in a specific order, that's testing implementation details. These tests break every time you refactor, even if the behavior stays the same.

Ask yourself: _if someone changed the internals but the function still returned the correct result, would this test break?_ If yes, it's probably too coupled to the implementation. See _Testing in Practice_ for more on this distinction.

### 3. Do the tests actually run?

Always run the tests before committing. AI-generated tests can have import errors, reference functions that don't exist, or use APIs incorrectly. A test that looks correct in a chat window might fail immediately when you actually execute it:

```bash
vitest run src/userService.test.js

```

### 4. Are there real edge cases?

AI tools tend to generate happy-path tests and skip the hard cases. After reviewing the generated tests, ask yourself: what happens with empty input? What about `null` or `undefined`? What if the network request fails? What if the list is empty?

If these scenarios aren't covered, ask the AI to add them, or write them yourself.

---

## Iterating on the Output

Treat AI-generated tests as a first draft, not a finished product. A good workflow looks like:

1. Generate the initial tests with a specific prompt and good context.
2. Run them immediately to catch errors.
3. Review each test for the issues described above.
4. Ask for revisions if entire sections need improvement (_"these tests mock too much, rewrite them to test the actual integration with the database module"_).
5. Edit manually for small fixes rather than re-prompting for every detail.

Over time, as the AI sees more of your codebase and test patterns, its output will improve. The earlier tests in your project set the pattern for everything that follows, so it's worth getting those right.

---

## Common Pitfalls

### Wrong APIs

The most frequent issue with AI-generated Vitest tests is using the wrong API surface. AI models are trained on a lot of Jest code, so they sometimes generate `jest.fn()` instead of `vi.fn()`, or `jest.mock` instead of `vi.mock`. These will fail immediately.

A related problem is imports: if your config has `globals: true`, the AI might still add `import { test, expect } from 'vitest'` (harmless but unnecessary), or the reverse, generating tests without imports when globals aren't enabled. If you keep seeing Jest APIs, point the AI to the Vitest API reference or include it in the context.

### Mock Cleanup

AI-generated tests often set up spies with `vi.spyOn` or replace modules with `vi.mock` but never restore them. If your config doesn't have `restoreMocks: true`, these mocks leak between tests and cause confusing failures. The easiest fix is enabling that config option globally.

On a related note, AI tools tend to mock modules using string paths (`vi.mock('./module.js')`) when the `import()` form (`vi.mock(import('./module.js'))`) is preferable for type safety and automatic refactoring. See _Mock Functions_ for why this matters.

### Verbose Test Names

AI tends to produce names like `"should correctly return the formatted price string when given a valid positive number and a supported currency code."` These are hard to scan when you have dozens of tests. Shorter names that describe the behavior work better: `"formats USD prices"`, `"throws for negative amounts"`, `"returns empty array when no items match."`

### Watch Mode

Vitest runs in watch mode by default, waiting for file changes and re-running tests interactively. Vitest tries to detect CI and non-interactive or agent environments and disable watch mode automatically, but this detection can be fragile.

When telling an AI agent to run tests, always use `vitest run` or `vitest --no-watch` to ensure the process exits after the tests finish.
