# Berichtstool Reference

The frontend workspace is `@berichtstool/web` in `apps/frontend`. Paths below are relative to the repository root.

## TanStack Vue Query

`apps/frontend/src/queries/berufsprofil.ts` is the reference for the resource root, detail and filter keys, and reusable mutation composables. This adapted detail example shows how to resolve a reactive ID once per options update and capture it for both the key and the request.

```ts
import { BerufsprofilApi } from "@berichtstool/api/apis";
import { skipToken, useQuery } from "@tanstack/vue-query";
import { toValue, type MaybeRefOrGetter } from "vue";

const berufsprofilApi = new BerufsprofilApi();

export const queryKeys = {
    all: ["berufsprofile"] as const,
    detail: (id: number | undefined) =>
        [...queryKeys.all, "detail", id] as const,
};

export function useBerufsprofil(id: MaybeRefOrGetter<number | undefined>) {
    return useQuery(() => {
        const pk = toValue(id);
        return {
            queryKey: queryKeys.detail(pk),
            refetchOnMount: true,
            queryFn: pk === undefined
                ? skipToken
                : () => berufsprofilApi.berichteApiBerufsprofilRetrieve({ pk }),
        };
    });
}
```

- A consuming component can call `useBerufsprofil(() => props.berufsprofilId)` and keep the same query instance as the prop changes. The query is disabled while the ID is absent. If the component offers manual refresh, enable that action only when it has a valid ID.
- The resource module's review and release mutations invalidate `queryKeys.detail(data.id)`. That prefix also reaches nested requirement queries. `queryKeys.all` reaches the full resource cache, including filtered lists. Choose the prefix to match what the write affected.
- `apps/frontend/src/queries/klientnotiz.ts` gives list, detail, and ratings their own keys. Its ratings query uses `placeholderData: []` so the temporary list has a predictable shape while fetching.
- `apps/frontend/src/main.ts` sets shared Vue Query defaults. Check them before overriding stale time, retries, refetching, or error behavior in a composable.

## Components, date fields, and permissions

- `apps/frontend/src/components/nice/NiceDateInput.vue` adapts a native date string to the API's date-only `Date` model. Reuse it with `apps/frontend/src/utils/date.ts` so dates round-trip at local midnight. A cleared input emits `undefined` and optional API values can arrive as `null`. Preserve this model contract and map explicitly when an endpoint needs a particular value to clear a field.
- `apps/frontend/src/components/editor/extensions/BedingungForm.vue` builds typed select options from shared domain values and emits partial updates through writable computed models. Keep shared editor domain definitions aligned with `packages/tiptap-config` and the backend renderer when changing stored node attributes.
- `apps/frontend/src/components/berufsprofile/BerufsprofilDetailsForm.vue` shows an editable draft, pending save and delete states, a confirmation dialog, and success feedback using `Notify`.
- `apps/frontend/src/components/PermissionNeeded.vue` delegates visibility to `useHasPermission` in `apps/frontend/src/queries/user.ts`. Check the helper's semantics when passing multiple permissions. Protected actions still require backend authorization.

## File-based routing

- `apps/frontend/vite.config.ts` registers `vue-router/vite` and `apps/frontend/src/router/index.ts` consumes `routes` from `vue-router/auto-routes`. Add and rename route source files under `apps/frontend/src/pages`. Use Vite to regenerate route types and inspect the generated names before changing navigation callers.
- `apps/frontend/src/pages/berichte/[berichtId].vue` provides the report tabs and child router view. The child `apps/frontend/src/pages/berichte/[berichtId]/vorschau.vue` generates the name `/berichte/[berichtId]/vorschau` and matches URLs such as `/berichte/42/vorschau`. Link to it with `{ name: "/berichte/[berichtId]/vorschau", params: { berichtId: 42 } }`.
- Use `parseId` from `apps/frontend/src/utils/berichtNeuQuery.ts` to validate the preview route parameter. Both queries stay idle when the computed ID is `undefined`, including for values such as `-1` and `1.5`. The same utility module shows reactive parsing and formatting of query parameters with `useRouteQuery`.

```ts
import { computed } from "vue";
import { useRoute } from "vue-router";

import { useBericht, useBerichtVorschau } from "@/queries/berichte";
import { parseId } from "@/utils/berichtNeuQuery";

const route = useRoute<"/berichte/[berichtId]/vorschau">();
const berichtId = computed(() => parseId(route.params.berichtId));
const { data: bericht } = useBericht(berichtId);
const { data: pdfData, isFetching: isPdfLoading } = useBerichtVorschau(berichtId);
```

## API integration

- Imports from `@berichtstool/api/apis` and `@berichtstool/api/models` use the generated client and models in `packages/api`. Change the backend contract and regenerate when those types need to change.
- Keep `./configureApi` first in `apps/frontend/src/main.ts`. Module-scope clients snapshot middleware at construction. `apps/frontend/src/configureApi.ts` configures common request and error-handling middleware, so inspect it before adding local notifications for failures.

## Styling and copy

- `apps/frontend/src/assets/quasar.variables.scss` defines compile-time Sass values. `apps/frontend/src/assets/base.scss` switches runtime `--q-*` and app CSS tokens under `.body--light` and `.body--dark`. Compose colors from runtime variables when they need to respond to a theme change. `apps/frontend/src/utils/useTheme.ts` applies the saved theme through Quasar.
- Follow the surrounding use of Vue I18n. For new translation keys, update the `de-CH`, `fr`, and `en` resources in `apps/frontend/src/locales`. The message schema derives from `de-CH.ts`.

## Verification from the repository root

```bash
npm run typecheck -w @berichtstool/web
npm run lint:debug -w @berichtstool/web
npm run test:unit:run -w @berichtstool/web -- NiceDateInput.spec.ts
npm run test:e2e -w @berichtstool/web -- BerichtContentView.e2e.spec.ts
```

Substitute the affected test filename. `lint:debug` checks without fixing source files. Vitest component specs use Chromium and `renderWithPlugins` from `apps/frontend/src/__tests__/index.ts`, which installs Quasar, Vue Query, the router, and i18n. It supplies a fresh query client by default. `apps/frontend/src/components/__tests__/NiceDateInput.spec.ts` shows tests for emitted values, validation messages, and date serialization. Playwright specs in `apps/frontend/tests` use the shared fixtures and auth setup.
