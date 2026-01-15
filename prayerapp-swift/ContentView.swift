import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @State private var email = ""
    @State private var password = ""
    
    var viewModel: AuthViewModel
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if viewModel.isCheckingAuth {
                // Show loading while checking existing session
                ProgressView("Loading...")
            } else if viewModel.isAuthenticated {
                // User is logged in - show main app
                authenticatedView
            } else {
                // User is not logged in - show login
                loginView
            }
        }
    }
    
    // MARK: - Authenticated View
    
    private var authenticatedView: some View {
        VStack(spacing: 20) {
            Text("Welcome, \(viewModel.user?.firstName ?? "User")!")
                .font(.largeTitle)
            
            Text("You are logged in")
                .foregroundStyle(.secondary)
            
            Button("Logout") {
                Task {
                    await viewModel.logout()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    // MARK: - Login View
    
    private var loginView: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            
            Button("Login") {
                Task {
                    await viewModel.login(email: email, password: password)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading || email.isEmpty || password.isEmpty)
            
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .padding()
    }
}

#Preview {
    let authService = AuthService(
        apiClient: .shared,
        keychainManager: .shared
    )
    return ContentView(viewModel: AuthViewModel(authService: authService))
}
