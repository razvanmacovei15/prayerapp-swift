//
//  ProfileView.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 19.01.2026.
//

import SwiftUI

// The Profile view displays user information and provides the logout button.
// It receives the AuthViewModel to:
// 1. Display the current user's info (name, email)
// 2. Call viewModel.logout() when the logout button is tapped

struct ProfileView: View {

    // MARK: - Properties

    // viewModel is passed from MainTabView, not created here
    // This ensures we use the same instance throughout the app
    var viewModel: AuthViewModel

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color matching the app's dark theme
                Color(white: 0.11)
                    .ignoresSafeArea()

                VStack(spacing: 24) {

                    // MARK: User Info Section
                    userInfoSection

                    Spacer()

                    // MARK: Logout Button
                    logoutButton
                }
                .padding()
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - User Info Section

    private var userInfoSection: some View {
        VStack(spacing: 16) {
            // Profile image placeholder
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.secondary)

            // User name - uses nil coalescing (??) for safe unwrapping
            // If user is nil, shows "User" as fallback
            Text(viewModel.user?.firstName ?? "User")
                .font(.title)
                .foregroundStyle(.white)

            // User email
            if let email = viewModel.user?.email {
                Text(email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.top, 40)
    }

    // MARK: - Logout Button

    private var logoutButton: some View {
        Button {
            // Task creates an asynchronous context for calling async functions
            // logout() is async because it makes a network call to the backend
            Task {
                await viewModel.logout()
            }
        } label: {
            Text("Abmelden")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.red.opacity(0.8))
                .cornerRadius(25)
        }
        .padding(.bottom, 20)
    }
}

// MARK: - Preview

#Preview {
    ProfileView(
        viewModel: AuthViewModel(
            authService: AuthService(
                apiClient: .shared,
                keychainManager: .shared
            )
        )
    )
}
