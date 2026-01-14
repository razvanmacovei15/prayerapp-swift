# ICF Prayer App - Swift Learning Path

Welcome to your Swift learning journey! This folder contains lesson files that will teach you Swift and iOS development as we build the ICF Prayer App together.

## How to Use These Lessons

1. **Read before coding** - Each lesson explains a concept before you see it in the actual app code
2. **Try the examples** - Create a Swift Playground in Xcode to experiment
3. **Reference during development** - Come back to lessons when you need a refresher
4. **Ask questions** - Don't hesitate to ask Claude to explain things differently

## Learning Path Overview

### Module 1: Swift Basics
*Learn the Swift programming language fundamentals*

| Lesson | Topic | Description |
|--------|-------|-------------|
| 01 | Variables & Constants | `let` vs `var`, when to use each |
| 02 | Data Types | String, Int, Double, Bool, and more |
| 03 | Optionals | Swift's way of handling "no value" |
| 04 | Control Flow | if/else, switch, loops |
| 05 | Functions | Creating reusable code blocks |
| 06 | Closures | Functions as values (important for SwiftUI!) |
| 07 | Structs vs Classes | When to use each, value vs reference types |

### Module 2: SwiftUI Fundamentals
*Build user interfaces with Apple's modern UI framework*

| Lesson | Topic | Description |
|--------|-------|-------------|
| 01 | Views & Modifiers | The building blocks of SwiftUI |
| 02 | State Management | @State, @Binding, and data flow |
| 03 | Layout System | VStack, HStack, ZStack, and more |
| 04 | Navigation | Moving between screens |
| 05 | Lists & Grids | Displaying collections of data |

### Module 3: MVVM Architecture
*Organize code for maintainability and testability*

| Lesson | Topic | Description |
|--------|-------|-------------|
| 01 | What is MVVM? | Understanding the pattern |
| 02 | Models | Data structures and Codable |
| 03 | ViewModels | @Observable and business logic |
| 04 | Dependency Injection | Making code testable |

### Module 4: Networking
*Communicate with the backend API*

| Lesson | Topic | Description |
|--------|-------|-------------|
| 01 | URLSession Basics | Making HTTP requests |
| 02 | Async/Await | Modern Swift concurrency |
| 03 | JSON Decoding | Parsing API responses |
| 04 | Building an API Client | Reusable networking layer |

### Module 5: Authentication
*Secure user login and session management*

| Lesson | Topic | Description |
|--------|-------|-------------|
| 01 | JWT Explained | How JSON Web Tokens work |
| 02 | Keychain Storage | Secure token storage |
| 03 | Token Refresh Flow | Keeping users logged in |

### Module 6: Testing
*Write tests to ensure code quality*

| Lesson | Topic | Description |
|--------|-------|-------------|
| 01 | XCTest Basics | Writing your first test |
| 02 | Testing ViewModels | Unit testing business logic |
| 03 | Mocking Services | Isolating code for testing |

### Module 7: Xcode Essentials
*Master your development environment*

| Lesson | Topic | Description |
|--------|-------|-------------|
| 01 | Project Structure | Understanding Xcode projects |
| 02 | Build & Run | Running your app |
| 03 | Debugging | Finding and fixing bugs |
| 04 | Simulator | Testing on virtual devices |

---

## Recommended Order

For building the ICF Prayer App, follow this order:

1. **Start with Xcode Essentials (Module 7)** - Get comfortable with the tools first
2. **Swift Basics (Module 1)** - Learn the language fundamentals
3. **SwiftUI Fundamentals (Module 2)** - Build your first views
4. **MVVM Architecture (Module 3)** - Structure your code properly
5. **Networking (Module 4)** - Connect to the backend
6. **Authentication (Module 5)** - Implement login
7. **Testing (Module 6)** - Ensure quality as you go

## Quick Reference

### Important Swift Concepts
- **Optional** (`?`) - A value that might be nil
- **`let`** - Constant (cannot change)
- **`var`** - Variable (can change)
- **`guard let`** - Safe unwrapping with early exit
- **`async/await`** - Modern way to handle asynchronous code

### Important SwiftUI Concepts
- **`@State`** - Local view state
- **`@Observable`** - Observable object (iOS 17+)
- **`@Binding`** - Two-way connection to parent state
- **View modifier** - Chains like `.padding().background()`

### Common Keyboard Shortcuts (Xcode)
| Shortcut | Action |
|----------|--------|
| Cmd + R | Run app |
| Cmd + B | Build |
| Cmd + U | Run tests |
| Cmd + Shift + K | Clean build folder |
| Cmd + Click | Jump to definition |
| Option + Click | Quick documentation |

---

## Resources

### Official Documentation
- [Swift Language Guide](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)

### Recommended Learning Sites
- [Hacking with Swift](https://www.hackingwithswift.com) - Free, beginner-friendly
- [Swift Playgrounds](https://www.apple.com/swift/playgrounds/) - Interactive learning

### Video Resources
- [Stanford CS193p](https://cs193p.sites.stanford.edu) - Free Stanford iOS course
- [WWDC Videos](https://developer.apple.com/videos/) - Apple's official sessions

---

*Lessons are added as we build features. Check back for new content!*
