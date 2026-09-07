# React Best Practices — Code Examples

Good/bad patterns for each rule in [SKILL.md](SKILL.md).

---

## Derive, Don't Store

```tsx
// BAD: Storing derived state
const [fullName, setFullName] = useState("");
useEffect(() => {
  setFullName(`${firstName} ${lastName}`);
}, [firstName, lastName]);

// GOOD: Compute during render
const fullName = `${firstName} ${lastName}`;
```

```tsx
// BAD: Filtering in useEffect
const [filteredBlogs, setFilteredBlogs] = useState(blogs);
useEffect(() => {
  setFilteredBlogs(blogs.filter((b) => b.category === selected));
}, [blogs, selected]);

// GOOD: Compute (memoize only if expensive)
const filteredBlogs = useMemo(
  () => blogs.filter((b) => b.category === selected),
  [blogs, selected],
);
```

---

## Memoization

```tsx
// BAD: Over-memoizing trivial operations
const greeting = useMemo(() => `Hello, ${name}!`, [name]);
const handleClick = useCallback(() => setOpen(true), []);

// GOOD: Only memoize expensive operations
const sortedBlogs = useMemo(
  () => [...blogs].sort((a, b) => new Date(b.date) - new Date(a.date)),
  [blogs],
);
```

---

## Render Factories

```tsx
// BAD: Render factory (camelCase, called as function)
const renderBlogCard = (blog) => {
  return <div className="p-4">{blog.title}</div>;
};
return <div>{renderBlogCard(blog)}</div>;

// GOOD: Proper React component (PascalCase, used as JSX)
const BlogCard = ({ blog }) => {
  return <div className="p-4">{blog.title}</div>;
};
return (
  <div>
    <BlogCard blog={blog} />
  </div>
);
```

---

## Inline Creation in JSX

```tsx
// BAD: New array on every render
<CategoryFilter categories={["Tech", "Startup", "Lifestyle"]} />;

// GOOD: Stable reference (module-level constant)
const CATEGORIES = ["Tech", "Startup", "Lifestyle"];
<CategoryFilter categories={CATEGORIES} />;
```

```tsx
// BAD: Inline style object on every render
<div style={{ padding: '16px', background: '#fff' }}>

// GOOD: Use MUI sx prop with theme tokens
<Box sx={{ p: 2, bgcolor: 'background.paper' }}>
```

---

## Container / Presenter Split

```tsx
// BAD: Mixed data fetching and rendering
const CaseList = () => {
  const { data, loading, error } = useGetCases();
  if (loading) return <Loading />;
  if (error) return <Typography>Error loading cases</Typography>;
  // ... 150 lines of rendering logic
};

// GOOD: Container fetches, presenter renders
const CaseListContainer = () => {
  const { data, loading, error } = useGetCases();
  if (loading) return <Loading />;
  if (error) return <Typography>Error loading cases</Typography>;
  if (!data?.cases?.length) return <EmptyScreen title="No cases found" />;
  return <CaseGrid cases={data.cases} />;
};

const CaseGrid = ({ cases }) => {
  return (
    <Stack spacing={2}>
      {cases.map((caseItem) => (
        <CaseCard key={caseItem.id} caseItem={caseItem} />
      ))}
    </Stack>
  );
};
```

---

## State Colocation

```tsx
// BAD: State lifted too high — parent re-renders everything
const Home = () => {
  const [searchTerm, setSearchTerm] = useState("");
  return (
    <>
      <SearchBar value={searchTerm} onChange={setSearchTerm} />
      <BlogList /> {/* re-renders on every keystroke */}
      <Newsletter />
    </>
  );
};

// GOOD: State pushed down to where it's used
const Home = () => (
  <>
    <SearchSection /> {/* owns its own search state */}
    <BlogList />
    <Newsletter />
  </>
);

const SearchSection = () => {
  const [searchTerm, setSearchTerm] = useState("");
  const debouncedTerm = useDebounce(searchTerm, 300);
  return <SearchBar value={searchTerm} onChange={setSearchTerm} />;
};
```

---

## Data Fetching in Custom Hooks

```tsx
// BAD: Fetching directly in component
const CaseDetail = ({ id }) => {
  const [caseData, setCaseData] = useState(null);
  useEffect(() => {
    fetchCase(id).then((res) => setCaseData(res));
  }, [id]);
  // ...
};

// GOOD: Use Apollo query hook
const CaseDetail = ({ id }) => {
  const { data, loading, error } = useGetCase(id);
  if (loading) return <Loading />;
  if (error) return <Typography>Error</Typography>;
  return <CaseContent caseData={data.case} />;
};
```

---

## useEffect Misuse

```tsx
// BAD: useEffect for event handling
const handleSubmit = () => {
  setSubmitted(true);
};
useEffect(() => {
  if (submitted) {
    api.createBlog(formData);
    setSubmitted(false);
  }
}, [submitted]);

// GOOD: Logic in the event handler
const handleSubmit = async () => {
  await api.createBlog(formData);
  toast.success("Blog created!");
  navigate("/admin/blogs");
};
```

---

## Early Returns for States

```tsx
// BAD: Nested ternaries
return loading ? (
  <Loading />
) : error ? (
  <ErrorFallback />
) : data ? (
  <Content data={data} />
) : (
  <EmptyScreen />
);

// GOOD: Early returns
if (loading) return <Loading />;
if (error) return <Typography color="error">Something went wrong</Typography>;
if (!data?.cases?.length) return <EmptyScreen title="No cases yet" />;
return <CaseGrid cases={data.cases} />;
```

---

## Error Boundaries

```tsx
import { ErrorBoundary } from "react-error-boundary";
import { useLocation } from "react-router";

// BAD: No error boundary — unhandled errors crash the whole app
const App = () => <Routes>...</Routes>;

// GOOD: Error boundary with route-aware reset and recovery
const ErrorFallback = ({ error, resetErrorBoundary }) => (
  <Box sx={{ p: 4, textAlign: "center" }}>
    <Typography color="error">Something went wrong</Typography>
    <Button onClick={resetErrorBoundary} sx={{ mt: 2 }} variant="contained">
      Try again
    </Button>
  </Box>
);

const App = () => {
  const location = useLocation();
  return (
    <ErrorBoundary
      resetKeys={[location.pathname]}
      FallbackComponent={ErrorFallback}
    >
      <Routes>...</Routes>
    </ErrorBoundary>
  );
};
```

---

## Key Prop Patterns

```tsx
// BAD: Index as key — causes state bugs when list changes
{
  blogs.map((blog, index) => <BlogCard key={index} blog={blog} />);
}

// GOOD: Stable unique ID as key
{
  blogs.map((blog) => <BlogCard key={blog._id} blog={blog} />);
}

// BAD: Random key — forces full remount every render
{
  blogs.map((blog) => <BlogCard key={Math.random()} blog={blog} />);
}

// GOOD: Key on Fragment when mapping fragments
{
  items.map((item) => (
    <React.Fragment key={item.id}>
      <dt>{item.label}</dt>
      <dd>{item.value}</dd>
    </React.Fragment>
  ));
}
```

---

## Conditional Rendering Gotcha

```tsx
// BAD: Renders literal "0" when count is 0
{
  count && <Badge>{count}</Badge>;
}

// GOOD: Explicit comparison
{
  count > 0 && <Badge>{count}</Badge>;
}

// GOOD: Ternary for clarity
{
  count ? <Badge>{count}</Badge> : null;
}
```

---

## Accessibility

```tsx
// BAD: Icon button without label — invisible to screen readers
<IconButton onClick={onDelete}><DeleteIcon /></IconButton>

// GOOD: Accessible icon button
<IconButton onClick={onDelete} aria-label="Delete case"><DeleteIcon /></IconButton>
```

```tsx
// BAD: Error not associated with field
<TextField />;
{
  error && <Typography color="error">{error}</Typography>;
}

// GOOD: Error linked to field via MUI's built-in helperText
<TextField error={!!error} helperText={error} />;
```

```tsx
// GOOD: Live region for dynamic updates
<Box aria-live="polite">{searchResults.length} results found</Box>
```

---

## Route-Level Code Splitting

```tsx
import { lazy, Suspense } from "react";

// BAD: All pages in main bundle
import AdminDashboard from "./pages/admin/Dashboard";
import AddBlog from "./pages/admin/AddBlog";

// GOOD: Lazy-loaded routes
const AdminDashboard = lazy(() => import("./pages/admin/Dashboard"));
const AddBlog = lazy(() => import("./pages/admin/AddBlog"));

const App = () => (
  <Suspense fallback={<PageLoader />}>
    <Routes>
      <Route path="/admin" element={<AdminDashboard />} />
      <Route path="/admin/add" element={<AddBlog />} />
    </Routes>
  </Suspense>
);
```

---

## Axios Request Cancellation

```tsx
// BAD: No cleanup — stale responses update unmounted component
useEffect(() => {
  client.query({ query: GET_CASES }).then((res) => setCases(res.data.cases));
}, []);

// GOOD: Use Apollo hooks which handle cleanup automatically
const { data, loading, error } = useQuery(GET_CASES, {
  fetchPolicy: "cache-and-network",
});
```

---

## React 19: ref as Prop

```tsx
// OLD (React 18): forwardRef boilerplate
const Input = forwardRef((props, ref) => <input ref={ref} {...props} />);

// NEW (React 19): ref as a regular prop
const Input = ({ ref, ...props }) => <input ref={ref} {...props} />;
```
