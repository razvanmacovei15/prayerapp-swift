# Optionals in Swift

## What You'll Learn
- What an optional is and why Swift uses them
- How to safely unwrap optionals
- Common patterns you'll use every day

---

## The Problem Optionals Solve

In many languages, any variable can be `null`, leading to crashes:

```javascript
// JavaScript - this crashes at runtime!
let user = null;
console.log(user.name);  // Uncaught TypeError!
```

Swift prevents this by forcing you to handle "no value" cases explicitly.

---

## What is an Optional?

An **optional** is a variable that might contain a value, or might contain nothing (`nil`).

Think of it like a box:
- The box might have something in it
- Or the box might be empty
- You need to check before using what's inside

```swift
// Non-optional: MUST have a value
var name: String = "John"
// name = nil  // ERROR! Cannot be nil

// Optional: MIGHT have a value (the ? makes it optional)
var middleName: String? = nil
middleName = "Paul"  // Now it has a value
middleName = nil     // Now it's empty again
```

---

## Declaring Optionals

Add `?` after the type to make it optional:

```swift
var age: Int?           // Optional Int, currently nil
var email: String?      // Optional String, currently nil
var price: Double?      // Optional Double, currently nil

// With initial values
var phone: String? = "555-1234"  // Has a value
var nickname: String? = nil       // Explicitly nil
```

---

## The Danger of Force Unwrapping

You CAN force unwrap with `!`, but **DON'T**:

```swift
var name: String? = nil

// This CRASHES your app!
print(name!)  // Fatal error: Unexpectedly found nil

// NEVER do this unless you're 100% certain it has a value
```

**Rule:** Never use `!` in production code.

---

## Safe Unwrapping Methods

### 1. `if let` - Check and Unwrap

Use when you need to do something if the value exists:

```swift
var middleName: String? = "Paul"

if let name = middleName {
    // name is now a regular String (not optional)
    print("Middle name is: \(name)")
} else {
    print("No middle name")
}
```

### 2. `guard let` - Early Exit (RECOMMENDED)

Use when you want to exit early if value is nil:

```swift
func greetUser(name: String?) {
    // If name is nil, exit the function early
    guard let name = name else {
        print("No name provided")
        return
    }

    // After guard, name is safely unwrapped for rest of function
    print("Hello, \(name)!")
    print("Nice to meet you, \(name)!")
}
```

**Why `guard let` is preferred:**
- Keeps your code flat (not deeply nested)
- Makes it clear what the "happy path" is
- Unwrapped value available for rest of function

### 3. Nil Coalescing (`??`) - Default Value

Use when you want a fallback value:

```swift
var nickname: String? = nil

// If nickname is nil, use "Anonymous"
let displayName = nickname ?? "Anonymous"
print(displayName)  // "Anonymous"

// With a value
nickname = "SwiftFan"
let displayName2 = nickname ?? "Anonymous"
print(displayName2)  // "SwiftFan"
```

### 4. Optional Chaining (`?.`)

Access properties/methods on optionals safely:

```swift
struct User {
    var name: String
    var address: Address?
}

struct Address {
    var city: String
}

let user: User? = User(name: "John", address: nil)

// Safe - returns nil if any part is nil
let city = user?.address?.city  // nil (address is nil)

// Can combine with nil coalescing
let cityName = user?.address?.city ?? "Unknown City"
```

---

## Real-World Example: User Model

Here's how we use optionals in the Prayer App:

```swift
// Some fields are required, some are optional
struct User: Codable {
    let id: Int              // Required - always has value
    let firstName: String    // Required
    let lastName: String     // Required
    let email: String        // Required

    let phone: String?       // Optional - user might not provide
    let imageUrl: String?    // Optional - might not have profile pic
    let onboardedAt: Date?   // Optional - nil until onboarding complete
}

// Using the model
func displayUser(_ user: User) {
    // Required fields - use directly
    print("Name: \(user.firstName) \(user.lastName)")

    // Optional fields - must handle nil case
    if let phone = user.phone {
        print("Phone: \(phone)")
    }

    // Or with nil coalescing
    print("Profile: \(user.imageUrl ?? "No profile picture")")

    // Check if onboarded
    if user.onboardedAt != nil {
        print("User has completed onboarding")
    } else {
        print("User needs to complete onboarding")
    }
}
```

---

## SwiftUI Example

```swift
struct ProfileView: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Required fields - always safe
            Text("\(user.firstName) \(user.lastName)")
                .font(.title)

            Text(user.email)
                .foregroundStyle(.secondary)

            // Optional: Show only if exists
            if let phone = user.phone {
                Label(phone, systemImage: "phone")
            }

            // Optional: Show image or placeholder
            if let imageUrl = user.imageUrl {
                AsyncImage(url: URL(string: imageUrl))
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
            }
        }
    }
}
```

---

## Common Patterns

### Pattern 1: Multiple Optionals with `guard`

```swift
func processForm(email: String?, password: String?) {
    guard let email = email, let password = password else {
        print("Please fill in all fields")
        return
    }

    // Both are now safely unwrapped
    login(email: email, password: password)
}
```

### Pattern 2: Optional with Condition

```swift
guard let email = email, !email.isEmpty else {
    print("Email is required")
    return
}
```

### Pattern 3: Map on Optional

```swift
let number: String? = "42"

// Transform optional without unwrapping
let parsed: Int? = number.map { Int($0) } ?? nil

// Shorter with flatMap when transformation also returns optional
let parsed2: Int? = number.flatMap { Int($0) }
```

---

## Quick Reference

| Method | Use When |
|--------|----------|
| `if let` | Need to do something only if value exists |
| `guard let` | Want to exit early if nil (MOST COMMON) |
| `??` | Want a default value if nil |
| `?.` | Accessing property/method on optional |
| `!` | NEVER (except in tests or truly guaranteed cases) |

---

## Exercise

Try this in a Swift Playground:

```swift
struct Product {
    let name: String
    let price: Double
    let discount: Double?  // Percentage discount, if any
}

let products = [
    Product(name: "iPhone", price: 999, discount: 10),
    Product(name: "Case", price: 29, discount: nil),
    Product(name: "Charger", price: 19, discount: 5)
]

// TODO: Write a function that calculates final price
// If there's a discount, apply it; otherwise use full price
func finalPrice(for product: Product) -> Double {
    // Your code here!
}
```

<details>
<summary>Solution</summary>

```swift
func finalPrice(for product: Product) -> Double {
    guard let discount = product.discount else {
        return product.price  // No discount
    }

    let discountAmount = product.price * (discount / 100)
    return product.price - discountAmount
}

// Or with nil coalescing (one-liner):
func finalPriceShort(for product: Product) -> Double {
    let discount = product.discount ?? 0
    return product.price * (1 - discount / 100)
}
```
</details>

---

## Next Lesson

[Control Flow →](04-control-flow.md)

---

*Remember: When in doubt, use `guard let` for early exits!*
