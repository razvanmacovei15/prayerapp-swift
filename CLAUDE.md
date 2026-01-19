# CLAUDE.md

## CRITICAL RULES - READ FIRST

**DO NOT WRITE OR EDIT ANY CODE FILES.**

- You are a TEACHING ASSISTANT only
- Provide code snippets that the USER will copy/paste into Xcode
- NEVER use Write, Edit, or create files (except CLAUDE.md for session logs)
- Only use Read, Glob, Grep to understand the codebase
- Explain concepts, provide snippets, answer questions
- The user learns by typing the code themselves

---

This file provides guidance to Claude Code (claude.ai/code) when working with this iOS Swift/SwiftUI application.

## Implementation Status

### Completed Features

#### Authentication System (100%)
- [x] **Login flow** - Email/password authentication via `/api/auth/login`
- [x] **Logout flow** - Clears tokens locally + calls backend `/api/auth/logout`
- [x] **Token storage** - Secure Keychain storage via `KeychainManager`
- [x] **Session restoration** - `checkExistingSession()` restores user on app launch
- [x] **Proactive token refresh** - Scheduled 60 seconds before expiry via `scheduleTokenRefresh()`
- [x] **Pre-request token validation** - `ensureValidToken()` checks before API calls
- [x] **401 retry logic** - `authenticatedRequest()` retries once with fresh token
- [x] **Refresh deduplication** - Shared `Task` prevents thundering herd
- [x] **Background return handling** - `checkAndRefreshIfNeeded()` on app foreground
- [x] **TokenProviderProtocol** - Breaks circular dependency between APIClient and AuthService

#### Networking (80%)
- [x] **APIClient** - Base networking with `request()` method
- [x] **authenticatedRequest()** - Auto token injection + 401 retry
- [x] **APIError** - Error types with localized descriptions
- [x] **Environment config** - Dev/prod base URLs
- [ ] **JSON:API parsing** - Generic response wrapper (not yet needed)

#### Models
- [x] **User** - User model with all fields
- [x] **AuthTokens** - Token storage with `isExpired`, `isExpiringSoon`, `secondsUntilExpiry`
- [x] **LoginRequest/LoginResponse** - Auth request/response models
- [x] **RegisterRequest** - Registration request model

#### Register Flow (100%)
- [x] **RegisterRequest model** - `{firstName, lastName, email, password, timezoneOffsetMinutes}`
- [x] **AuthServiceProtocol** - Added `register(request:)` method signature
- [x] **AuthService.register()** - Implementation with token storage and user fetch
- [x] **AuthViewModel.register()** - ViewModel method with loading/error state

### Next Steps (Priority Order)

#### 1. Auth UI (100%) ✅
- [x] Create `AuthTextField` reusable component
- [x] Create dedicated `LoginView` (separate from ContentView)
- [x] Create `RegisterView` with form validation
- [x] Update `ContentView` to use new auth views
- [ ] **PENDING**: Update LoginView/RegisterView to use `NavigationStack` + `.toolbar` for iOS 26 liquid glass headers (pattern provided, ready to implement)

#### 2. Main App Navigation ← **NEXT**
- Create `MainTabView` for authenticated users
- Implement tab-based navigation (Spaces, Journal, Profile)
- Update `ContentView` to show `MainTabView` when authenticated

#### 3. Spaces Feature
- Create `Space` model
- Create `SpacesService` with CRUD operations using `authenticatedRequest()`
- Create `SpacesViewModel`
- Create `SpacesListView` and `SpaceDetailView`

#### 4. Prayer Cards Feature
- Create `PrayerCard` model with all card types
- Create `PrayerCardsService`
- Create `PrayerCardsViewModel`
- Create card views for different types

#### 5. Unit Tests
- Create `MockAuthService` for testing
- Write `AuthViewModelTests`
- Write `AuthServiceTests`

### Files Created/Modified

| File | Status | Purpose |
|------|--------|---------|
| `Networking/TokenProviderProtocol.swift` | NEW | Protocol for APIClient token management |
| `Networking/APIClient.swift` | MODIFIED | Added `tokenProvider`, `authenticatedRequest()` |
| `Networking/APIError.swift` | EXISTS | Error handling |
| `Features/Auth/Models/AuthTokens.swift` | MODIFIED | Added `isExpiringSoon`, `secondsUntilExpiry` |
| `Features/Auth/Models/User.swift` | EXISTS | User model |
| `Features/Auth/Models/LoginRequest.swift` | EXISTS | Login request body |
| `Features/Auth/Models/LoginResponse.swift` | MODIFIED | Added `EmptyResponse` |
| `Features/Auth/Models/RegisterRequest.swift` | NEW | Registration request body |
| `Features/Auth/Services/AuthService.swift` | MODIFIED | Full token refresh + `register()` method |
| `Features/Auth/ViewModels/AuthViewModel.swift` | MODIFIED | Session management + `register()` method |
| `Core/Utilities/KeychainManager.swift` | EXISTS | Secure token storage |
| `Core/Config/Environment.swift` | EXISTS | API configuration |
| `prayerapp_swiftApp.swift` | MODIFIED | Dependency wiring, lifecycle observers |
| `ContentView.swift` | MODIFIED | Navigation between LoginView/RegisterView + authenticated state |
| `Features/Auth/Views/Components/AuthTextField.swift` | NEW | Reusable text field with focus state, secure entry, eye toggle |
| `Features/Auth/Views/LoginView.swift` | NEW | Login screen with email/password fields |
| `Features/Auth/Views/RegisterView.swift` | NEW | Registration screen with validation |

---

## 📝 Session Log

### 2026-01-19
**Accomplished:**
- Created `AuthTextField` reusable component with `@Binding`, `@State`, `@FocusState`
- Created `LoginView` with styled inputs, error handling, navigation callback
- Created `RegisterView` with form validation, newsletter checkbox, alert dialogs
- Updated `ContentView` to use new auth views with `showingRegister` state toggle
- Discussed iOS 26 liquid glass — should use `NavigationStack` + `.toolbar` for automatic glass headers

**Concepts Learned:**
- SwiftUI View struct basics and `body` computed property
- `@State` for internal state, `@Binding` for two-way parent connection
- `@FocusState` for keyboard focus tracking
- Extracted computed properties for cleaner `body`
- `@ViewBuilder` for conditional views
- iOS 26 liquid glass via `NavigationStack` + `.navigationTitle` + `.toolbar`

**Next Session:**
- Implement liquid glass headers using `NavigationStack` pattern (code provided)
- Start Main App Navigation (MainTabView)

---

## Project Overview

**ICF Prayer App** - A native iOS prayer community platform being rebuilt from React Native to Swift/SwiftUI. The app enables users to create, share, and manage prayer requests within different spaces (communities).

- **Target**: iOS 26.0+ (with native liquid glass UI support)
- **Architecture**: MVVM (Model-View-ViewModel)
- **Language**: Swift 5
- **UI Framework**: SwiftUI
- **Networking**: URLSession (graduating to Alamofire later)
- **Backend**: Laravel JSON:API

## Tech Stack & Versions

| Technology | Version | Purpose |
|------------|---------|---------|
| Swift | 5.0 | Primary language |
| SwiftUI | iOS 26+ | UI framework |
| URLSession | Native | HTTP networking |
| XCTest | Native | Unit & UI testing |
| Keychain | Native | Secure token storage |

## Project Structure

```
prayerapp-swift/
├── prayerapp-swift/
│   ├── App/
│   │   └── prayerapp_swiftApp.swift      # App entry point (@main)
│   │
│   ├── Core/
│   │   ├── Config/
│   │   │   ├── Environment.swift          # Dev/Prod API configuration
│   │   │   └── APIConfig.swift            # Endpoint definitions
│   │   ├── Extensions/
│   │   │   ├── View+Extensions.swift
│   │   │   ├── String+Extensions.swift
│   │   │   └── Date+Extensions.swift
│   │   ├── Utilities/
│   │   │   ├── KeychainManager.swift      # Secure storage for tokens
│   │   │   └── Logger.swift               # Debug logging helper
│   │   └── Theme/
│   │       ├── Colors.swift               # App color palette
│   │       ├── Fonts.swift                # Typography definitions
│   │       └── LiquidGlass.swift          # iOS 26 glass effect modifiers
│   │
│   ├── Features/
│   │   ├── Auth/
│   │   │   ├── Models/
│   │   │   │   ├── User.swift
│   │   │   │   ├── AuthTokens.swift
│   │   │   │   ├── LoginRequest.swift
│   │   │   │   └── RegisterRequest.swift
│   │   │   ├── ViewModels/
│   │   │   │   └── AuthViewModel.swift
│   │   │   ├── Views/
│   │   │   │   ├── LoginView.swift
│   │   │   │   ├── RegisterView.swift
│   │   │   │   └── Components/
│   │   │   │       └── AuthTextField.swift
│   │   │   └── Services/
│   │   │       └── AuthService.swift
│   │   │
│   │   ├── Prayer/
│   │   │   ├── Models/
│   │   │   ├── ViewModels/
│   │   │   ├── Views/
│   │   │   └── Services/
│   │   │
│   │   ├── Spaces/
│   │   │   ├── Models/
│   │   │   ├── ViewModels/
│   │   │   ├── Views/
│   │   │   └── Services/
│   │   │
│   │   └── Journal/
│   │       ├── Models/
│   │       ├── ViewModels/
│   │       ├── Views/
│   │       └── Services/
│   │
│   ├── Networking/
│   │   ├── APIClient.swift               # Base networking layer
│   │   ├── HTTPMethod.swift              # GET, POST, PUT, DELETE enum
│   │   ├── APIError.swift                # Error types
│   │   ├── Endpoints/
│   │   │   ├── AuthEndpoints.swift
│   │   │   ├── SpacesEndpoints.swift
│   │   │   └── PrayerEndpoints.swift
│   │   └── Interceptors/
│   │       └── AuthInterceptor.swift     # JWT token injection
│   │
│   ├── Components/
│   │   ├── Buttons/
│   │   │   ├── PrimaryButton.swift
│   │   │   └── GlassButton.swift
│   │   ├── Cards/
│   │   │   └── PrayerCardView.swift
│   │   ├── Navigation/
│   │   │   └── MainTabView.swift
│   │   └── Loading/
│   │       └── LoadingView.swift
│   │
│   └── Resources/
│       └── Assets.xcassets/
│
├── prayerapp-swiftTests/
│   ├── Features/
│   │   └── Auth/
│   │       ├── AuthViewModelTests.swift
│   │       └── AuthServiceTests.swift
│   ├── Networking/
│   │   └── APIClientTests.swift
│   └── Mocks/
│       ├── MockAuthService.swift
│       └── MockAPIClient.swift
│
├── lessons/                               # Learning documentation
│   ├── README.md
│   ├── 01-swift-basics/
│   ├── 02-swiftui-fundamentals/
│   └── ...
│
└── prayerapp-swift.xcodeproj/
```

## Domain Concepts

### User Roles
| Role | Description |
|------|-------------|
| **Normal User** | Standard end users - can create prayer requests, join spaces |
| **Brand Account** | Verified organizational accounts (churches, ministries) - can create all card types |
| **Super User** | Internal admin team with full access |

### Space Types
| Type | Description |
|------|-------------|
| **Public** | Only Brand Accounts can post; all users can read/subscribe |
| **Closed** | Invitation-only access with owner/admin management |
| **Private** ("Meine Spaces") | Personal spaces for individual users |

### Prayer Card Types
| Type | Who Can Create |
|------|----------------|
| `prayer_request` | All users |
| `free_prayer` | Brand Accounts only |
| `timer` | Brand Accounts only |
| `instruction` | Brand Accounts only |
| `bible_verse` | Brand Accounts only |
| `song_lyrics` | Brand Accounts only |
| `actions` | Brand Accounts only |

### Card Status
- `active` - Currently visible and prayable
- `answered` - Marked as answered prayer
- `archived` - Hidden from main views

## Code Conventions

### File Naming
- **Types**: PascalCase - `AuthViewModel.swift`, `PrayerCard.swift`
- **Protocols**: End with `Protocol` - `AuthServiceProtocol`
- **Extensions**: `TypeName+Category.swift` - `View+LiquidGlass.swift`

### Code Organization
Always organize code with MARK comments:

```swift
import SwiftUI

final class AuthViewModel {

    // MARK: - Properties

    private let authService: AuthServiceProtocol
    private(set) var user: User?
    private(set) var isLoading = false

    // MARK: - Initialization

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    // MARK: - Public Methods

    func login(email: String, password: String) async {
        // Implementation
    }

    // MARK: - Private Methods

    private func validateEmail(_ email: String) -> Bool {
        // Implementation
    }
}
```

### Swift Style Rules
1. **Prefer `let` over `var`** - Use constants unless mutation is needed
2. **No force unwrapping** - Never use `!` except in tests
3. **Use `guard let` for early returns** - Keeps code flat
4. **Trailing closure syntax** - For single closures
5. **Explicit access control** - Mark `private`, `private(set)`, etc.

### Swift 6 Concurrency Notes
This project uses Swift 6 strict concurrency. Key patterns:

1. **All auth-related classes are `@MainActor`** - `AuthService`, `AuthViewModel`, `APIClient`, `KeychainManager`
2. **No default parameters referencing singletons** - Swift 6 evaluates defaults in caller's context
   ```swift
   // BAD - causes concurrency error in Swift 6
   init(apiClient: APIClient = .shared) { }

   // GOOD - pass dependencies explicitly
   init(apiClient: APIClient) { }
   ```
3. **Wire dependencies in App init** - Create services in `prayerapp_swiftApp.init()` and pass down
4. **Use `State(initialValue:)` wrapper** - When initializing @State in View init:
   ```swift
   init() {
       _viewModel = State(initialValue: AuthViewModel(authService: authService))
   }
   ```

### Safe Optional Handling

```swift
// GOOD - guard let for early exit
func processUser(_ user: User?) {
    guard let user = user else {
        print("No user provided")
        return
    }
    // user is now safely unwrapped
    print(user.firstName)
}

// GOOD - if let when you need the else branch
if let phone = user.phone {
    callNumber(phone)
} else {
    showNoPhoneAlert()
}

// GOOD - nil coalescing for defaults
let displayName = user.nickname ?? user.firstName

// BAD - NEVER do this
let name = user.nickname! // CRASHES if nil
```

## MVVM Pattern

### Model (Data Layer)
Plain structs that conform to `Codable` for JSON parsing:

```swift
// Features/Auth/Models/User.swift
struct User: Codable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?           // Optional fields use ?
    let imageUrl: String?
    let onboardedAt: Date?
}
```

### ViewModel (Business Logic)
`@Observable` classes that manage state and call services:

```swift
// Features/Auth/ViewModels/AuthViewModel.swift
import Foundation

@MainActor  // Ensures UI updates happen on main thread
@Observable
final class AuthViewModel {

    // MARK: - Properties

    // private(set) = readable externally, only writable internally
    private(set) var user: User?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let authService: AuthServiceProtocol

    // MARK: - Computed Properties

    var isAuthenticated: Bool {
        user != nil
    }

    // MARK: - Initialization

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    // MARK: - Public Methods

    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        // defer = runs when function exits, even on error
        defer { isLoading = false }

        do {
            user = try await authService.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() async {
        do {
            try await authService.logout()
            user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

### View (UI Layer)
SwiftUI views that observe ViewModels:

```swift
// Features/Auth/Views/LoginView.swift
import SwiftUI

struct LoginView: View {

    // MARK: - Properties

    @State private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            // Email field
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textContentType(.emailAddress)
                .autocapitalization(.none)

            // Password field
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .textContentType(.password)

            // Error message
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
            }

            // Login button
            Button("Login") {
                Task {
                    await viewModel.login(email: email, password: password)
                }
            }
            .disabled(viewModel.isLoading || email.isEmpty || password.isEmpty)

            // Loading indicator
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    LoginView()
}
```

### Service (Network Layer)
Protocol + implementation for testability:

```swift
// Features/Auth/Services/AuthService.swift
import Foundation

// 1. Define protocol first (for testing)
protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> User
    func register(request: RegisterRequest) async throws -> User
    func refreshToken() async throws -> AuthTokens
    func logout() async throws
}

// 2. Implement the protocol
final class AuthService: AuthServiceProtocol {

    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func login(email: String, password: String) async throws -> User {
        let request = LoginRequest(email: email, password: password)
        let response: AuthResponse = try await apiClient.post(
            endpoint: "/api/auth/login",
            body: request
        )

        // Store tokens securely
        try KeychainManager.shared.saveTokens(response.tokens)

        return response.user
    }

    // ... other methods
}
```

## API Integration

### Backend Configuration
| Environment | Base URL |
|-------------|----------|
| Development | `http://localhost:8000` (or your local Laravel URL) |
| Production | `https://api.yourapp.com` |

### Authentication Flow
1. User logs in with email/password
2. Backend returns `accessToken` (60 min TTL) + `refreshToken` (14 days TTL)
3. Store both tokens in Keychain
4. Include `Authorization: Bearer {accessToken}` in all API requests
5. When access token expires, use refresh token to get new tokens
6. On 401 response, attempt token refresh; if that fails, logout user

### Auth Endpoints
```
POST /api/auth/register     - Create new account
     Body: { firstName, lastName, email, password, timezoneOffsetMinutes }
     Returns: { user, accessToken, refreshToken, expiresIn }

POST /api/auth/login        - Authenticate user
     Body: { email, password }
     Returns: { user, accessToken, refreshToken, expiresIn }

POST /api/auth/refresh      - Refresh access token
     Header: Authorization: Bearer {refreshToken}
     Returns: { accessToken, refreshToken, expiresIn }

POST /api/auth/logout       - Invalidate tokens
     Header: Authorization: Bearer {accessToken}

POST /api/auth/me           - Get current user
     Header: Authorization: Bearer {accessToken}
     Returns: { user }
```

### JSON:API Endpoints (all require Bearer token)
```
GET    /api/v1/spaces              - List user's spaces
POST   /api/v1/spaces              - Create new space
GET    /api/v1/spaces/{id}         - Get space details
PUT    /api/v1/spaces/{id}         - Update space
DELETE /api/v1/spaces/{id}         - Delete space

GET    /api/v1/prayer-cards        - List prayer cards
POST   /api/v1/prayer-cards        - Create prayer card
GET    /api/v1/prayer-cards/{id}   - Get card details
PUT    /api/v1/prayer-cards/{id}   - Update card
DELETE /api/v1/prayer-cards/{id}   - Delete/archive card

POST   /api/v1/prayer-cards/{id}/pray     - Mark card as prayed
POST   /api/v1/prayer-cards/{id}/archive  - Archive card

GET    /api/v1/journal-entries     - List journal entries
POST   /api/v1/journal-entries     - Create entry
...
```

### JSON:API Response Format
```swift
// Wrapper for JSON:API responses
struct JSONAPIResponse<T: Codable>: Codable {
    let data: T
    let included: [JSONAPIResource]?
    let meta: JSONAPIMeta?
    let links: JSONAPILinks?
}

struct JSONAPIMeta: Codable {
    let page: PageMeta?
}

struct PageMeta: Codable {
    let currentPage: Int
    let lastPage: Int
    let perPage: Int
    let total: Int
}
```

### Token Storage
```swift
// Store tokens securely in Keychain - NEVER in UserDefaults
struct AuthTokens: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int        // Minutes until access token expires
    let tokenIssuedAt: Date   // When token was issued

    var isExpired: Bool {
        let expirationDate = tokenIssuedAt.addingTimeInterval(TimeInterval(expiresIn * 60))
        return Date() >= expirationDate
    }
}
```

### Token Refresh Architecture

The app implements automatic token refresh using three triggers (matching the React Native implementation):

#### Trigger 1: Proactive Scheduled Refresh
- Schedules refresh **60 seconds BEFORE** token expires
- Uses Swift's `Task.sleep()` for scheduling (equivalent to RN's `setTimeout`)
- Cancels pending refresh when user logs out
- Minimum 30 second delay to prevent race conditions

```swift
// In AuthService
private var refreshTask: Task<Void, Never>?

func scheduleTokenRefresh() {
    refreshTask?.cancel()

    guard let tokens = try? keychainManager.getTokens() else { return }

    // expiresIn is in MINUTES, subtract 1 minute buffer
    let refreshDelaySeconds = max(30, (tokens.expiresIn - 1) * 60)

    refreshTask = Task {
        try? await Task.sleep(for: .seconds(refreshDelaySeconds))
        guard !Task.isCancelled else { return }
        try? await refreshToken()
    }
}
```

#### Trigger 2: Pre-Request Validation
- `ensureValidToken()` called before each API request
- If token expires within 60-second buffer → refresh immediately
- Returns fresh token for the request

```swift
// In AuthService
func ensureValidToken() async throws -> String {
    guard let tokens = try keychainManager.getTokens() else {
        throw AuthError.notAuthenticated
    }

    // Check if expiring within 60 second buffer
    let bufferSeconds: TimeInterval = 60
    let elapsedTime = Date().timeIntervalSince(tokens.tokenIssuedAt)
    let expiresInSeconds = TimeInterval(tokens.expiresIn * 60)

    if elapsedTime >= expiresInSeconds - bufferSeconds {
        return try await refreshToken()
    }

    return tokens.accessToken
}
```

#### Trigger 3: 401 Response Recovery
- If API returns 401 despite checks → attempt one refresh
- Retry the failed request with new token
- If retry still fails → force logout

```swift
// In APIClient.request() - pseudo-code
case 401:
    // Attempt refresh and retry ONCE
    let newToken = try await authService.refreshToken()
    // Retry request with newToken
    // If still 401 → throw and let ViewModel handle logout
```

#### Refresh Deduplication (Preventing Thundering Herd)
Multiple concurrent requests might detect expired token simultaneously. To prevent multiple refresh calls:

```swift
// In AuthService
private var refreshPromise: Task<String, Error>?

func refreshToken() async throws -> String {
    // If refresh already in progress, await same task
    if let existing = refreshPromise {
        return try await existing.value
    }

    let task = Task { () -> String in
        defer { refreshPromise = nil }

        guard let tokens = try keychainManager.getTokens() else {
            throw AuthError.notAuthenticated
        }

        // POST /api/auth/refresh with Bearer {refreshToken}
        let response: RefreshResponse = try await apiClient.request(
            endpoint: "/api/auth/refresh",
            method: "POST",
            token: tokens.refreshToken
        )

        // Store new tokens
        let newTokens = AuthTokens(from: response)
        try keychainManager.saveTokens(newTokens)

        // Schedule next refresh
        scheduleTokenRefresh()

        return newTokens.accessToken
    }

    refreshPromise = task
    return try await task.value
}
```

#### App Lifecycle Handling
When app returns from background, token might have expired:

```swift
// In App entry point or AuthViewModel
.onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
    Task {
        await authViewModel.checkAndRefreshIfNeeded()
    }
}

// In AuthViewModel
func checkAndRefreshIfNeeded() async {
    guard isAuthenticated else { return }

    do {
        _ = try await authService.ensureValidToken()
    } catch {
        // Token refresh failed, force logout
        await logout()
    }
}
```

#### Token Flow Diagram
```
LOGIN/REGISTER
      │
      ▼
┌─────────────────────────────┐
│ Store tokens in Keychain    │
│ Schedule refresh (T - 60s)  │
└──────────────┬──────────────┘
               │
      ┌────────┴────────┐
      │                 │
      ▼                 ▼
[Timer fires]    [API Request]
      │                 │
      ▼                 ▼
ensureValidToken()  ensureValidToken()
      │                 │
      ├── Token OK ─────┼──► Use existing token
      │                 │
      └── Expiring ─────┴──► refreshToken()
                              │
                    ┌─────────┴─────────┐
                    │                   │
                 Success             Failure
                    │                   │
                    ▼                   ▼
            Store new tokens       LOGOUT
            Schedule refresh
```

## Testing Requirements

### Test-Alongside Development
Every new feature must include tests. Place tests in mirror structure under `prayerapp-swiftTests/`.

### Test Naming Convention
Use descriptive names: `test_methodName_condition_expectedResult`

```swift
// prayerapp-swiftTests/Features/Auth/AuthViewModelTests.swift
import XCTest
@testable import prayerapp_swift

final class AuthViewModelTests: XCTestCase {

    var sut: AuthViewModel!  // sut = System Under Test
    var mockService: MockAuthService!

    override func setUp() {
        super.setUp()
        mockService = MockAuthService()
        sut = AuthViewModel(authService: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Login Tests

    func test_login_withValidCredentials_setsUser() async {
        // Given (arrange)
        let expectedUser = User.mock()
        mockService.loginResult = .success(expectedUser)

        // When (act)
        await sut.login(email: "test@example.com", password: "password123")

        // Then (assert)
        XCTAssertNotNil(sut.user)
        XCTAssertEqual(sut.user?.email, "test@example.com")
        XCTAssertNil(sut.errorMessage)
    }

    func test_login_withInvalidCredentials_setsErrorMessage() async {
        // Given
        mockService.loginResult = .failure(APIError.unauthorized)

        // When
        await sut.login(email: "test@example.com", password: "wrong")

        // Then
        XCTAssertNil(sut.user)
        XCTAssertNotNil(sut.errorMessage)
    }

    func test_login_setsIsLoadingDuringRequest() async {
        // Given
        mockService.delay = 0.1  // Add small delay to test loading state

        // When
        let task = Task {
            await sut.login(email: "test@example.com", password: "password")
        }

        // Brief pause to let login start
        try? await Task.sleep(nanoseconds: 10_000_000)

        // Then - loading should be true during request
        XCTAssertTrue(sut.isLoading)

        await task.value

        // After completion, loading should be false
        XCTAssertFalse(sut.isLoading)
    }
}
```

### Mock Services
```swift
// prayerapp-swiftTests/Mocks/MockAuthService.swift
final class MockAuthService: AuthServiceProtocol {

    var loginResult: Result<User, Error> = .failure(APIError.unknown)
    var loginCallCount = 0
    var delay: TimeInterval = 0

    func login(email: String, password: String) async throws -> User {
        loginCallCount += 1

        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }

        switch loginResult {
        case .success(let user):
            return user
        case .failure(let error):
            throw error
        }
    }

    // ... other mock methods
}
```

### What to Test
- ViewModel state changes (loading, error, success states)
- Service method calls (verify correct parameters)
- Error handling paths
- Edge cases (empty inputs, network failures)
- Business logic (validation, calculations)

## Xcode Commands

### Building
```bash
# Build for simulator (from project root)
xcodebuild -scheme prayerapp-swift -destination 'platform=iOS Simulator,name=iPhone 17' build

# Clean build folder
xcodebuild -scheme prayerapp-swift clean
```

### Running Tests
```bash
# Run all tests
xcodebuild test -scheme prayerapp-swift -destination 'platform=iOS Simulator,name=iPhone 17'

# Run specific test class
xcodebuild test -scheme prayerapp-swift -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:prayerapp-swiftTests/AuthViewModelTests
```

### List Available Simulators
```bash
xcrun simctl list devices available
```

### Common Issues & Fixes
| Issue | Solution |
|-------|----------|
| "No such module" error | Product > Clean Build Folder (Cmd+Shift+K) |
| Simulator not found | Check available simulators with `xcrun simctl list` |
| Build fails after adding files | Ensure files are added to target in Xcode |

## UI Guidelines

### Liquid Glass Effects (iOS 26+)
iOS 26 introduces native glassmorphism. Use the built-in modifiers:

```swift
// Apply glass background effect
Text("Hello")
    .padding()
    .glassBackgroundEffect()

// Glass effect with tint
Button("Action") { }
    .glassBackgroundEffect(tint: .blue)

// For best glass visibility, test in dark mode
.preferredColorScheme(.dark)
```

### Color Guidelines
- Use semantic colors that adapt to light/dark mode
- Define app colors in Assets.xcassets
- Reference with `Color("ColorName")` or use system colors

```swift
// System colors (auto-adapt to dark mode)
Color.primary           // Main text
Color.secondary         // Secondary text
Color.accentColor       // App accent (defined in Assets)

// Backgrounds
Color(.systemBackground)
Color(.secondarySystemBackground)
```

### Accessibility
Always support accessibility:

```swift
Button(action: { }) {
    Image(systemName: "heart.fill")
}
.accessibilityLabel("Mark as favorite")  // For VoiceOver

Text(prayerCount.description)
    .font(.largeTitle)
    .dynamicTypeSize(...DynamicTypeSize.accessibility3)  // Support Dynamic Type
```

## Rules for Claude

### Beginner-Friendly Development
1. **Explain the WHY** - Add comments explaining why code is written a certain way, not just what it does
2. **One feature at a time** - Complete one feature fully (with tests) before moving to the next
3. **Reference lessons** - Point to relevant lesson files when introducing new concepts

### Code Safety
4. **No force unwrapping** - Never use `!` - always use `guard let`, `if let`, or `??`
5. **Error handling** - Always handle errors gracefully with user-friendly messages
6. **Protocol first** - Define protocols before implementations for testability

### Project Organization
7. **Check existing patterns** - Before creating new files, check if similar patterns exist
8. **Follow folder structure** - Place files in correct locations per the structure above
9. **Ask before architecture changes** - Do not create new base folders without approval

### Learning Support
10. **Create lesson file for new concepts** - When introducing something new, add a lesson file
11. **Link to documentation** - Include links to official Apple docs when relevant
12. **Progressive complexity** - Start simple, add complexity as understanding grows

## Documentation Links

### Official Apple (2025)
- [Swift Language Guide](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [iOS 26 Features](https://developer.apple.com/ios/)
- [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [Keychain Services](https://developer.apple.com/documentation/security/keychain_services)
- [XCTest](https://developer.apple.com/documentation/xctest)

### Community Resources
- [Hacking with Swift](https://www.hackingwithswift.com) - Free tutorials, beginner-friendly
- [Swift by Sundell](https://www.swiftbysundell.com) - In-depth articles
- [Point-Free](https://www.pointfree.co) - Advanced patterns (for later)

### Backend Reference
- API Routes: `../prayerapp-backend/routes/api.php`
- Models: `../prayerapp-backend/app/Models/`
- JSON:API Schemas: `../prayerapp-backend/app/JsonApi/V1/`
