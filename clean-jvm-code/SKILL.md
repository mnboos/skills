---
name: clean-jvm-code
description: Writes and reviews Java and Kotlin code across services, libraries, and apps with boundary validation, clear structure without overengineering, lifecycle/resource care, and minimal comments. Use when asked to 'review Java', 'review Kotlin', 'refactor to clean Kotlin or Java', write type-safe JVM code, or apply clean coding standards across backend, library, or app changes.
---

# Clean JVM Code Guidelines

Follow these rules when writing or reviewing Java or Kotlin code.

## Scope

Apply these rules to handwritten Java and Kotlin code in scope for the task. Leave generated code, binding or R classes, third-party code, build scripts, and unrelated files outside this workflow.

**When not to apply:** Do not force production state machines or strict null-check ceremony onto test fixtures, mocks, or quick throwaway scripts when straightforward test data is clearer.

## 1. Null Safety and Boundaries

- **Rely on types, not force unwraps:** In Kotlin, prefer smart casts and explicit handling of nullable values. Reserve `!!` for test fixtures with a known invariant or a small interop adapter where an API incorrectly declares a guaranteed value nullable. Document the guarantee in the adapter. In Java, use `@Nullable` and `@NonNull` annotations and explicit checks rather than letting `NullPointerException` surface later.
- **Validate at boundaries:** Validate external inputs (network payloads, request bodies, intents, extras, database rows, config or preferences) at the entry point and map them into clean domain models or state objects.
- **Model states explicitly:** Prefer sealed classes or sealed interfaces in Kotlin (and clear immutable state types in Java) over multiple booleans like `isLoading`, `isError`, and `hasData` that can contradict each other.

```kotlin
// Avoid
fun displayUserName(payload: Map<String, Any?>): String {
    return payload["name"]!!.toString()
}

// Prefer
fun parseUserName(payload: Map<String, Any?>): String? {
    val rawName = payload["name"] as? String ?: return null
    return rawName.trim().ifEmpty { null }
}
```

## 2. Structure and Pragmatism

- **Keep architecture light:** Group code by feature or domain rather than scattering tiny single-method classes across deep abstraction layers. Do not introduce interfaces, repositories, use cases, or factories unless there is a real second implementation, async boundary, or testability need.
- **Arrange code top-to-bottom:** Order members predictably inside a class or component: public entry points and state first, helper methods below, and private details at the bottom so a reader can scan from top to bottom.
- **Keep functions focused and shallow:** Use early returns to avoid deep nesting. Extract a helper only when a block has a clear name and independent logic, not for one-line wrappers.
- **Respect lifecycles and resources:** Keep UI components, controllers, or request handlers thin. Avoid holding short-lived UI or request contexts in long-lived objects, close resources or streams cleanly, and cancel or scope background work properly.

```kotlin
// Avoid
class OrderController {
    fun loadOrder(id: String?) {
        if (id != null) {
            if (id.isNotBlank()) {
                val order = fetchOrder(id)
                if (order != null) {
                    showOrder(order)
                }
            }
        }
    }
}

// Prefer
class OrderController {
    fun loadOrder(id: String?) {
        if (id.isNullOrBlank()) return
        val order = fetchOrder(id) ?: return
        showOrder(order)
    }
}
```

## 3. File and Module Organization

- **Right-sized files:** Keep related types, state models, and helpers together in a cohesive file or feature package. Split a file when it grows hard to scan or mixes unrelated concerns. In Kotlin, group small, closely related declarations when that improves readability. In Java, keep each public top-level type in its matching file and group related types by package.
- **Keep public surfaces small:** Make internal helpers `private` or `internal` (package-private in Java). Expose only what callers and tests actually need.

## 4. Naming and Comments

- **No inline comments:** Do not write comments that restate what the code is already doing. Write clear names and structured steps so the code reads like prose. Keep comments rare and only for non-obvious constraints, workarounds, or edge cases.
- **Use plain, concrete names:** Name classes, functions, and variables after what they represent or do. Avoid filler words like `Manager`, `Helper`, `Util`, `Processor`, `Smart`, `Base`, or `Impl` unless they reflect a real, distinct role.
- **Avoid dense expressions:** Break complex conditions, formatting chains, or multi-step calculations into named local variables instead of long chained expressions or nested ternaries.

## Worked Example

Input snippet to review: the caller requires positive integer percentages to display a discount and every other input to display `"No discount"`.

```kotlin
fun formatDiscount(rawPercent: Any?): String {
    return if (rawPercent != null) if ((rawPercent as Int) > 0) "${rawPercent}% off" else "No discount" else "No discount"
}
```

Review output:

- **Major:** `rawPercent as Int` can throw `ClassCastException` on non-integer inputs. For this formatter, accept positive `Int` values and return `"No discount"` for other inputs, including `2.5`. Use `val percent = rawPercent as? Int ?: return "No discount"`.
- **Minor:** The nested `if` expressions make the fallback hard to follow. After the type check, use a single `if` expression to return the discount label for a positive percentage or `"No discount"` otherwise.
