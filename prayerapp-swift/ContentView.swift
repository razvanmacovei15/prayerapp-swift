import SwiftUI

struct ContentView: View {

    // MARK: - Properties

    var viewModel: AuthViewModel

    // @State tracks whether we're showing the Register screen vs Login screen
    // When this changes, SwiftUI automatically re-renders the appropriate view
    @State private var showingRegister = false

    // MARK: - Body

    var body: some View {
        Group {
            if viewModel.isCheckingAuth {
                // Show loading while checking existing session
                loadingView
            } else if viewModel.isAuthenticated {
                // User is logged in - show main app with tabs
                MainTabView(viewModel: viewModel)
            } else {
                // User is not logged in - show auth flow
                authenticationFlow
            }
        }
    }

    // MARK: - Loading View

    private var loadingView: some View {
        ZStack {
            Color(white: 0.11)
                .ignoresSafeArea()

            ProgressView("Loading...")
                .tint(.white)
                .foregroundStyle(.white)
        }
    }

    // MARK: - Authentication Flow

    // This view switches between Login and Register based on showingRegister state
    @ViewBuilder
    private var authenticationFlow: some View {
        if showingRegister {
            // Show register view with callback to go back to login
            RegisterView(
                viewModel: viewModel,
                onBackTapped: {
                    showingRegister = false
                }
            )
        } else {
            // Show login view with callback to navigate to register
            LoginView(
                viewModel: viewModel,
                onCreateAccountTapped: {
                    showingRegister = true
                }
            )
        }
    }
}

// MARK: - Preview

#Preview {
    let authService = AuthService(
        apiClient: .shared,
        keychainManager: .shared
    )
    return ContentView(viewModel: AuthViewModel(authService: authService))
}
