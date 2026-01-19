//
//  MainTabView.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 19.01.2026.
//

import SwiftUI

// MARK: - Tab Enum
// An enum defines a fixed set of named values. Using an enum for tabs:
// 1. Prevents typos (can't accidentally write "spces" instead of "spaces")
// 2. Gives autocomplete in Xcode
// 3. Makes code more readable than using raw strings or integers

enum Tab: String {
    case spaces = "Spaces"
    case journal = "Journal"
    case profile = "Profile"
}

// MARK: - MainTabView

struct MainTabView: View {

    // MARK: - Properties

    // The viewModel is passed from parent (ContentView)
    // We don't use @State here because the viewModel is created elsewhere
    var viewModel: AuthViewModel

    // @State tracks which tab is currently selected
    // When this changes, SwiftUI automatically updates the UI
    @State private var selectedTab: Tab = .spaces

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {

            // MARK: Spaces Tab
            SpacesView()
                .tabItem {
                    Label("Spaces", systemImage: "square.grid.2x2")
                }
                .tag(Tab.spaces)

            // MARK: Journal Tab
            JournalView()
                .tabItem {
                    Label("Journal", systemImage: "book.closed")
                }
                .tag(Tab.journal)

        }
    }
}

// MARK: - Preview

#Preview {
    MainTabView(
        viewModel: AuthViewModel(
            authService: AuthService(
                apiClient: .shared,
                keychainManager: .shared
            )
        )
    )
}
