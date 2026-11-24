---
name: vue-quasar-frontend
description: Build and review Vue 3 and Quasar frontends using TanStack Vue Query as the server-state layer. Use for domain query composables, reactive query keys, mutation invalidation, file-based routing, data-backed pages and forms, Quasar components, and frontend tests.
---

# Vue and Quasar Frontend Development

Inspect the closest existing page, component, and query before adding a new pattern. Trace a representative flow from route and API response through the rendered state and any mutation. For Berichtstool paths, examples, and verification commands, read [the project reference](references/berichtstool.md). In another app, adapt the patterns to its package versions and existing contracts.

## TanStack Vue Query

- Keep server reads in domain modules such as `src/queries/<resource>.ts`. Export a `queryKeys` factory and named composables such as `useResource` and `useResources`. Put the generated API call, request inputs, and query defaults in the composable. Return the query result so pages can render its data and status directly. Keep form drafts and transient UI state local.
- Define a stable resource root and distinct list, detail, and related-resource keys. Include every request-defining ID, filter, sort, and page in the key, using the same normalized values as the request. Design prefixes around the groups that writes need to refresh. Reuse the factory for reads, cache writes, and invalidation. Alias domain factories at import sites when a component uses several.
- Accept `MaybeRefOrGetter<T>` for inputs that can change while the view stays mounted. From a component, pass a computed ref or a getter such as `() => props.resourceId`. Resolve reactive inputs with `toValue` in a reactive options getter and capture those values for both the key and the request, or read the request parameters from `queryFn`'s `queryKey` context. Every fetch, including a retry, must use the parameters represented by its key.
- Parse URL values before passing them to the composable. When a required input is missing, use `skipToken` or guard inside `queryFn` if the caller needs manual `refetch()`. The `enabled` option controls automatic fetching.
- Use `useMutation` for writes. Put shared cache effects in reusable mutation composables and keep page-specific feedback and navigation near their callers. Capture IDs in mutation variables when navigation can change them during the request. Use `setQueryData` when the response supplies the complete cached shape. Invalidate affected lists and related data through the same factory. Use `exact: true` for a single cache entry and await invalidation when completion depends on refreshed data.
- Use query status to distinguish a first load, an empty response, an error, and a background refresh. Use `placeholderData` for a temporary display value and `initialData` for data intended to populate the cache. Respect shared middleware for API errors.

## Routing

- Inspect the router configuration first. If the app registers routes explicitly, add the route to its existing route table and follow its naming and parameter conventions.
- For file-based routing, add routes through the configured pages directory. Use `index.vue` for a directory's default page and `[param].vue` or a `[param]` directory for dynamic segments. For a parent page with nested child views, render `<RouterView />` in the parent. Let the router plugin regenerate its route declarations after file changes.
- For named routes, use the registered or generated name and explicit `params` for links and programmatic navigation. On a page, use typed `useRoute` where the app provides route types and derive validated params with `computed` so navigating between records on the same page updates the query key. Keep shareable filters in the URL when the existing flow supports it.
- After a route rename or move, check callers and any guards that reference its name or path. Verify direct entry and in-app navigation, including a change of params on the same page when relevant.

## Components and forms

- Use TypeScript single-file components with `<script setup lang="ts">`, typed props and emits, and a typed model for inputs. Derive display values with `computed`. Use local refs for editable drafts and transient UI state. Keep drafts independent of props and cached data, including nested fields the form edits. Reset them when switching records and account for background refetches so they preserve unsaved edits.
- Start with existing Quasar components and app wrappers. Wrap a control when it owns a repeated behavior or type conversion. Preserve the underlying input's attributes, validation and focus behavior when callers rely on them. For `q-select` fields that store IDs or enums, use `emit-value` and `map-options` with the appropriate value and label fields. Handle clearing and validate emitted values at the component boundary.
- Route form submissions through validation, including keyboard submission. Show pending state on the active control and disable competing actions while the mutation runs. Keep input available for correction on failure. Use the existing dialog and notification patterns for destructive confirmation and save feedback.
- Match the surrounding Quasar layout, spacing utilities, and icon set. Use semantic color props and runtime CSS tokens so custom styles follow light and dark mode. Give icon-only actions accessible names and verify keyboard access.

## Verify the affected behavior

Run the project's type check and focused tests. Exercise the user-visible path affected by the change. For forms and data flows, choose relevant cases such as clearing an optional value, changing a route ID or filter without remounting, a failed submit, or list and detail views refreshing after a save. Use component tests with the app's plugin harness for isolated UI behavior and end-to-end tests when the regression spans routes or a real backend workflow.
