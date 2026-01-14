# What is MVVM?

## What You'll Learn
- The MVVM architectural pattern
- Why we use it in the Prayer App
- How Model, View, and ViewModel work together

---

## The Problem MVVM Solves

Without architecture, code becomes messy:

```swift
// BAD: Everything mixed together in the View
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var user: User?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)

            Button("Login") {
                // Networking code directly in the view!
                isLoading = true
                let url = URL(string: "https://api.example.com/login")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                // ... 50 more lines of networking code
                // ... token storage
                // ... error handling
                // This becomes unmaintainable!
            }
        }
    }
}
```

Problems:
- Hard to test (can't test UI logic without UI)
- Hard to read (business logic mixed with UI)
- Hard to reuse (login logic stuck in this view)
- Hard to maintain (changes affect everything)

---

## MVVM: Separation of Concerns

**MVVM** stands for **Model-View-ViewModel**. Each part has one job:

```
┌─────────────────────────────────────────────────────────────────┐
│                           USER                                   │
│                            │                                     │
│                            ▼                                     │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                        VIEW                              │    │
│  │  • Displays UI                                           │    │
│  │  • Handles user interactions                             │    │
│  │  • Observes ViewModel for updates                        │    │
│  └─────────────────────────────────────────────────────────┘    │
│                            │                                     │
│                   Calls methods / Observes                       │
│                            │                                     │
│                            ▼                                     │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                     VIEWMODEL                            │    │
│  │  • Holds UI state (isLoading, errorMessage)              │    │
│  │  • Contains business logic                               │    │
│  │  • Calls Services for data                               │    │
│  └─────────────────────────────────────────────────────────┘    │
│                            │                                     │
│                    Requests data                                 │
│                            │                                     │
│                            ▼                                     │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    SERVICE / MODEL                       │    │
│  │  • Makes API calls                                       │    │
│  │  • Manages data                                          │    │
│  │  • Handles storage                                       │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

---

## The Three Parts

### 1. Model (Data)
**What it is:** Plain data structures
**What it does:** Represents your data
**Location:** `Features/{Feature}/Models/`

```swift
// Features/Auth/Models/User.swift
struct User: Codable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?
}

// Models are simple - just data, no logic
```

### 2. View (UI)
**What it is:** SwiftUI views
**What it does:** Displays UI, handles taps/input
**Location:** `Features/{Feature}/Views/`

```swift
// Features/Auth/Views/LoginView.swift
struct LoginView: View {
    @State private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)

            // View just calls ViewModel methods
            Button("Login") {
                Task {
                    await viewModel.login(email: email, password: password)
                }
            }

            // View observes ViewModel state
            if viewModel.isLoading {
                ProgressView()
            }

            if let error = viewModel.errorMessage {
                Text(error).foregroundStyle(.red)
            }
        }
    }
}

// View is simple - just UI, delegates logic to ViewModel
```

### 3. ViewModel (Brain)
**What it is:** `@Observable` classes
**What it does:** Holds state, contains logic, calls services
**Location:** `Features/{Feature}/ViewModels/`

```swift
// Features/Auth/ViewModels/AuthViewModel.swift
@MainActor
@Observable
final class AuthViewModel {

    // MARK: - State (what the View observes)

    private(set) var user: User?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    var isAuthenticated: Bool { user != nil }

    // MARK: - Dependencies

    private let authService: AuthServiceProtocol

    // MARK: - Initialization

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    // MARK: - Actions (what the View calls)

    func login(email: String, password: String) async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            user = try await authService.login(email: email, password: password)
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
        }
    }
}

// ViewModel contains all the logic - validation, state management, etc.
```

---

## Why MVVM is Great for Testing

With MVVM, we can test the ViewModel without any UI:

```swift
// Tests/Features/Auth/AuthViewModelTests.swift
final class AuthViewModelTests: XCTestCase {

    func test_login_withValidCredentials_setsUser() async {
        // Create a mock service (no real network calls!)
        let mockService = MockAuthService()
        mockService.loginResult = .success(User.mock())

        // Create ViewModel with mock
        let viewModel = AuthViewModel(authService: mockService)

        // Call the method we're testing
        await viewModel.login(email: "test@test.com", password: "password")

        // Check the results
        XCTAssertNotNil(viewModel.user)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_login_withEmptyEmail_setsError() async {
        let viewModel = AuthViewModel()

        await viewModel.login(email: "", password: "password")

        XCTAssertNil(viewModel.user)
        XCTAssertEqual(viewModel.errorMessage, "Please fill in all fields")
    }
}
```

**Benefits:**
- Tests run instantly (no waiting for UI)
- Can test all edge cases easily
- Tests are reliable (not affected by UI changes)

---

## Data Flow in MVVM

```
User taps "Login" button
         │
         ▼
┌─────────────────┐
│      View       │  1. Captures email/password
│   LoginView     │  2. Calls viewModel.login()
└─────────────────┘
         │
         ▼
┌─────────────────┐
│   ViewModel     │  3. Validates input
│  AuthViewModel  │  4. Sets isLoading = true
│                 │  5. Calls authService.login()
└─────────────────┘
         │
         ▼
┌─────────────────┐
│    Service      │  6. Makes HTTP request
│  AuthService    │  7. Parses JSON response
│                 │  8. Returns User or throws error
└─────────────────┘
         │
         ▼
┌─────────────────┐
│   ViewModel     │  9. Sets user = response
│  AuthViewModel  │  10. Sets isLoading = false
└─────────────────┘
         │
         ▼
┌─────────────────┐
│      View       │  11. SwiftUI automatically updates
│   LoginView     │  12. Shows logged-in state
└─────────────────┘
```

---

## Folder Structure for Features

Each feature follows the same structure:

```
Features/
├── Auth/
│   ├── Models/
│   │   ├── User.swift           # Data structure
│   │   ├── AuthTokens.swift     # Data structure
│   │   └── LoginRequest.swift   # Request body
│   │
│   ├── ViewModels/
│   │   └── AuthViewModel.swift  # Business logic
│   │
│   ├── Views/
│   │   ├── LoginView.swift      # Login UI
│   │   ├── RegisterView.swift   # Register UI
│   │   └── Components/          # Reusable pieces
│   │       └── AuthTextField.swift
│   │
│   └── Services/
│       └── AuthService.swift    # API calls
│
├── Spaces/
│   ├── Models/
│   ├── ViewModels/
│   ├── Views/
│   └── Services/
│
└── ... (same pattern for each feature)
```

---

## Key Points to Remember

1. **View = Dumb**
   - Only knows how to display things
   - Delegates all logic to ViewModel

2. **ViewModel = Smart**
   - Holds all state the View needs
   - Contains validation and business logic
   - Knows nothing about SwiftUI

3. **Model = Data**
   - Simple structs
   - No business logic
   - Just holds information

4. **Service = Network**
   - Makes API calls
   - Returns Models
   - Knows nothing about UI

---

## Common Mistakes to Avoid

### Mistake 1: Logic in Views
```swift
// BAD
Button("Login") {
    if email.isEmpty { errorMessage = "Email required" }  // Logic in View!
}

// GOOD
Button("Login") {
    await viewModel.login(email: email, password: password)
}
```

### Mistake 2: UI Code in ViewModels
```swift
// BAD
class AuthViewModel {
    func showAlert() {
        // Don't reference UI types in ViewModel!
    }
}

// GOOD
class AuthViewModel {
    var errorMessage: String?  // View decides how to show this
}
```

### Mistake 3: Massive ViewModels
```swift
// BAD - One ViewModel doing everything
class AppViewModel {
    func login() { }
    func fetchSpaces() { }
    func createPrayer() { }
    // Too much!
}

// GOOD - One ViewModel per feature
class AuthViewModel { func login() { } }
class SpacesViewModel { func fetchSpaces() { } }
class PrayerViewModel { func createPrayer() { } }
```

---

## Next Lesson

[Models Explained →](02-models-explained.md)

---

*MVVM might seem like extra work at first, but it pays off quickly when your app grows!*
