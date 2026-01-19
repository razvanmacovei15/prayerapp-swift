//
//  LoginView.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 16.01.2026.
//

import SwiftUI

struct LoginView : View {
    var viewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var onCreateAccountTapped: () -> Void
    
    var body: some View {
        NavigationStack{
            ZStack {
                // Background color — fills entire screen
                Color(white: 0.11)  // #1C1C1E
                    .ignoresSafeArea()
                
                ScrollView {
                    
                    // MARK: Content
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Subtitle
                        Text("Melde dich mit deiner E-Mail Adresse an")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Input fields
                        inputFields
                        
                        // Error message (if any)
                        errorMessage
                        
                        // Buttons
                        buttonSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                
            }
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack {
            Spacer()
            Text("Login")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Input Fields
    
    private var inputFields: some View {
        VStack(spacing: 10) {
            AuthTextField(
                label: "E-Mail Adresse",
                placeholder: "E-Mail eingeben",
                text: $email,
                isSecure: false
            )
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            
            AuthTextField(
                label: "Passwort",
                placeholder: "••••••",
                text: $password,
                isSecure: true
            )
        }
    }
    
    // MARK: - Error Message
    
    @ViewBuilder
    private var errorMessage: some View {
        if let error = viewModel.errorMessage {
            Text(error)
                .font(.system(size: 14))
                .foregroundColor(.red)
                .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Button Section
    
    private var buttonSection: some View {
        VStack(spacing: 25) {
            // Login Button
            Button {
                Task {
                    await viewModel.login(email: email, password: password)
                }
            } label: {
                ZStack {
                    Text("Log in")
                        .opacity(viewModel.isLoading ? 0 : 1)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .cornerRadius(25)
            }
            .disabled(viewModel.isLoading || email.isEmpty || password.isEmpty)
            .opacity((viewModel.isLoading || email.isEmpty || password.isEmpty) ? 0.6 : 1)
            
            // Forgot Password Button
            Button {
                // TODO: Implement forgot password
            } label: {
                Text("Passwort vergessen?")
                    .font(.system(size: 17))
                    .foregroundColor(.blue)
            }
            
            // Create Account Button
            Button {
                onCreateAccountTapped()
            } label: {
                Text("Neuen Account erstellen")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white.opacity(0.12))
                    .cornerRadius(25)
            }
            .disabled(viewModel.isLoading)
        }
        .padding(.top, 45)
    }
}

#Preview {
    LoginView(
        viewModel: AuthViewModel(
            authService: AuthService(
                apiClient: .shared,
                keychainManager: .shared
            )
        ),
        onCreateAccountTapped: {
            print("Create account tapped")
        }
    )
}
