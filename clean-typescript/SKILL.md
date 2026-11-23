---
name: clean-typescript
description: Writes and reviews TypeScript with runtime validation at boundaries, named functions, and narrow exceptions for assertions and inline callbacks. Use for handwritten TypeScript changes and reviews.
---

# Clean TypeScript Guidelines

Follow these rules when writing or reviewing TypeScript code.

## Scope

Apply the rules to handwritten TypeScript in scope for the task. Leave generated files, vendor code, JavaScript-only changes, and unrelated cleanup outside this workflow.

## 1. Type Safety

* **No type casts or assertions:** Never use `as Type`, `<Type>value`, or the non-null assertion operator (`!`). These bypass the compiler and defeat static typing.
* **No `any`:** Use `unknown` for values whose shape is not yet verified, then narrow them before use.
* **Use type guards and narrowing:** Write user-defined type guards (`value is Type`), or use `in` checks, `typeof`, `instanceof`, and discriminated unions so the compiler proves types naturally.
* **Validate at boundaries:** Parse external inputs (JSON responses, environment variables, form data) with runtime checks or schema validators at the system boundary.
* **Prefer string union types over `enum`:** Use `type Status = "open" | "closed"` instead of `enum` for simpler runtime behavior and cleaner narrowing.
* **Exceptions:** Only use a type assertion when interfacing with a broken third-party type definition where no runtime check is possible. Isolate the assertion inside a single small helper function and add a comment explaining why it cannot be avoided.

```ts
// Avoid
function getUserName(data: unknown): string {
  return (data as { name: string }).name;
}

// Prefer
function isUserRecord(value: unknown): value is { name: string } {
  return typeof value === "object" && value !== null && "name" in value && typeof value.name === "string";
}

function getUserName(data: unknown): string {
  if (!isUserRecord(data)) {
    throw new Error("Invalid user record");
  }
  return data.name;
}
```

## 2. Functions

* **Use `function` declarations:** Always use the `function` keyword for named functions instead of assigning arrow functions to `const` variables.
* **Avoid inline functions:** Do not pass multi-line or complex inline callbacks to methods like `.map()`, `.filter()`, `.reduce()`, or event listeners. Extract them into named `function` declarations.
* **When inline functions are acceptable:** Short, single-expression callbacks that depend directly on local closure variables (such as `items.filter((item) => item.groupId === currentGroupId)`) are acceptable when extracting them would obscure intent. Otherwise, pass a named function reference (such as `items.filter(isActive)`).

```ts
// Avoid
const getActiveUserEmails = (users: User[]): string[] => {
  return users
    .filter((user) => {
      return user.isActive && !user.isSuspended;
    })
    .map((user) => user.email);
};

// Prefer
function isEligibleUser(user: User): boolean {
  return user.isActive && !user.isSuspended;
}

function getUserEmail(user: User): string {
  return user.email;
}

function getActiveUserEmails(users: User[]): string[] {
  return users.filter(isEligibleUser).map(getUserEmail);
}
```

## 3. File and Module Structure

* **Balanced granularity:** Group related types, constants, and functions into cohesive modules organized by feature or domain.
* **Avoid extremes:**
  * Do not put the entire application into one giant file.
  * Do not create a separate file for every tiny function or single-property type.
* **Practical boundaries:**
  * Consider splitting when distinct responsibilities can be named and used independently. Length is a signal to inspect cohesion.
  * Consider merging small files that serve one responsibility and are always used together.
* **Explicit exports:** Export only the public API of each module. Keep internal helper functions unexported at the bottom of the file.

## 4. Readability and Naming

* **Keep code readable:** Favor clear, step-by-step logic over clever one-liners, nested ternaries, or dense method chains. Assign intermediate steps to named variables.
* **Use plain words:** Name variables, functions, types, and files with simple, everyday words that describe what they hold or do.
* **Avoid unnecessary adjectives:** Do not use vague, promotional, or filler adjectives in names, comments, or documentation (avoid words like `smart`, `fast`, `simple`, `advanced`, `clean`, `helper`, or `manager`). Only use an adjective when it states a concrete domain fact (such as `activeUsers` or `emptyCart`).
