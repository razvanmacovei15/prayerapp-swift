# Xcode Project Structure

## What You'll Learn
- What all the files in an Xcode project do
- How to navigate the project in Xcode
- What each panel and area is for

---

## Opening Your Project

1. **Find the `.xcodeproj` file** - This is your project file
   - Location: `prayerapp-swift/prayerapp-swift.xcodeproj`
   - Double-click to open in Xcode

2. **Or open from Terminal:**
   ```bash
   open prayerapp-swift.xcodeproj
   ```

---

## The Xcode Interface

When you open Xcode, you'll see several areas:

```
┌─────────────────────────────────────────────────────────────────┐
│                        Toolbar                                   │
├──────────┬────────────────────────────────┬─────────────────────┤
│          │                                │                     │
│ Navigator│          Editor                │    Inspector        │
│  (Left)  │         (Center)               │     (Right)         │
│          │                                │                     │
│          │                                │                     │
├──────────┴────────────────────────────────┴─────────────────────┤
│                      Debug Area (Bottom)                         │
└─────────────────────────────────────────────────────────────────┘
```

### 1. Navigator (Left Panel)
Toggle with: `Cmd + 0`

Contains different views (click icons at top):
- **Project Navigator** (folder icon) - Your files
- **Source Control** (branch icon) - Git changes
- **Search** (magnifying glass) - Find in project
- **Issue Navigator** (warning icon) - Errors & warnings

### 2. Editor (Center)
Where you write code. Can be split:
- `Cmd + Enter` - Show editor only
- `Option + Cmd + Enter` - Show Canvas (SwiftUI preview)

### 3. Inspector (Right Panel)
Toggle with: `Cmd + Option + 0`

Shows properties of selected items:
- File settings
- UI element attributes
- Quick Help documentation

### 4. Debug Area (Bottom)
Toggle with: `Cmd + Shift + Y`

Shows:
- Console output (print statements, errors)
- Variable values when debugging

---

## Project File Structure

Here's what each file/folder does:

```
prayerapp-swift/
├── prayerapp-swift.xcodeproj/     # Project settings (don't edit manually!)
│   └── project.pbxproj            # Build settings, file references
│
├── prayerapp-swift/               # Your source code goes here
│   ├── prayerapp_swiftApp.swift   # App entry point (@main)
│   ├── ContentView.swift          # Initial view (we'll replace this)
│   │
│   ├── Assets.xcassets/           # Images, colors, app icon
│   │   ├── AccentColor.colorset/  # App's accent color
│   │   └── AppIcon.appiconset/    # App icon (all sizes)
│   │
│   └── [Our new folders]          # Core/, Features/, etc.
│
├── prayerapp-swiftTests/          # Unit tests
│
└── lessons/                       # Learning materials (not in app)
```

---

## Understanding Key Files

### 1. `prayerapp_swiftApp.swift` (Entry Point)

```swift
import SwiftUI

@main  // This tells iOS "start here"
struct prayerapp_swiftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()  // The first view users see
        }
    }
}
```

**Key concepts:**
- `@main` - Marks the app's starting point
- `App` protocol - Defines the app structure
- `WindowGroup` - Creates a window for your views
- `ContentView()` - The root view (we'll change this later)

### 2. `ContentView.swift` (Initial View)

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
```

**Key concepts:**
- `View` protocol - Everything visible is a View
- `body` - Required property that defines what's displayed
- `VStack` - Vertical stack (arranges items top to bottom)
- `#Preview` - Shows a preview in the Canvas

### 3. `Assets.xcassets` (Asset Catalog)

A special folder for:
- **Images** - App images, icons
- **Colors** - Named colors (like AccentColor)
- **App Icon** - The icon on home screen

To add new assets:
1. Click on `Assets.xcassets` in Navigator
2. Right-click > "New Color Set" or "New Image Set"
3. Drag images into the slots

---

## The Toolbar

```
[◀ ▶] [▶ Run] [⬜ Stop] | [prayerapp-swift] > [iPhone 16] | [Activity] | [+ - ○]
```

- **Run (▶)** - Build and run the app
- **Stop (⬜)** - Stop the running app
- **Scheme selector** - Choose what to build
- **Device selector** - Choose simulator or device
- **Activity indicator** - Shows build progress

---

## Essential Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Run app | `Cmd + R` |
| Stop app | `Cmd + .` |
| Build (no run) | `Cmd + B` |
| Clean build | `Cmd + Shift + K` |
| Toggle Navigator | `Cmd + 0` |
| Toggle Inspector | `Cmd + Option + 0` |
| Toggle Debug Area | `Cmd + Shift + Y` |
| Show Canvas | `Cmd + Option + Enter` |
| Jump to file | `Cmd + Shift + O` |
| Find in project | `Cmd + Shift + F` |

---

## Common Tasks

### Creating a New Swift File

1. Right-click folder in Navigator
2. Select "New File..."
3. Choose "Swift File"
4. Name it (use PascalCase: `LoginView.swift`)
5. Ensure "prayerapp-swift" target is checked
6. Click "Create"

### Creating a New Folder

1. Right-click in Navigator
2. Select "New Group"
3. Name your folder

**Important:** Groups in Xcode are just for organization. The actual files stay in their original location unless you choose "New Group with Folder".

### Running on Simulator

1. Select a simulator from dropdown (e.g., "iPhone 16")
2. Press `Cmd + R` or click the ▶ button
3. Wait for build and simulator to launch

---

## Try It Now

1. Open the project in Xcode
2. Press `Cmd + R` to run
3. You should see "Hello, world!" in the simulator
4. Try changing the text in `ContentView.swift`
5. Press `Cmd + R` again to see your change

---

## Next Steps

Once you're comfortable navigating Xcode:
- Learn Swift basics in `01-swift-basics/`
- Or jump to `02-build-and-run.md` for more Xcode details

---

*Tip: If Xcode seems slow or buggy, try "Clean Build Folder" (`Cmd + Shift + K`)*
