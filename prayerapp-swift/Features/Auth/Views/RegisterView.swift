//
//  RegisterView.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 16.01.2026.
//

import SwiftUI

struct RegisterView: View {
    
    // MARK: - Properties
    
    var viewModel: AuthViewModel
    
    // Form fields
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var newsletter: Bool = false
    
    // Validation error shown in alert
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // Callback when user taps back button
    var onBackTapped: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color(white: 0.11)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        // Content
                        VStack(alignment: .leading, spacing: 24) {
                            
                            // Title section
                            titleSection
                            
                            // Input fields
                            inputFields
                            
                            // Newsletter checkbox
                            newsletterCheckbox
                            
                            // Error message (if any)
                            errorMessage
                            
                            // Register button
                            registerButton
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Registrieren")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        onBackTapped()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
            }
            
        }.alert("Fehler", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        
    }
    
    
    // MARK: - Title Section
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mit E-Mail loslegen")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text("Wir verwenden deine E-Mail-Adresse, um dein Konto zu sichern und dir wichtige Informationen bereitzustellen.")
                .font(.system(size: 15))
                .foregroundColor(Color(white: 0.73))  // #BBBBBB
                .lineSpacing(4)
        }
    }
    
    // MARK: - Input Fields
    
    private var inputFields: some View {
        VStack(spacing: 16) {
            AuthTextField(
                label: "Vorname",
                placeholder: "Vorname eingeben",
                text: $firstName,
                isSecure: false
            )
            .textInputAutocapitalization(.words)
            
            AuthTextField(
                label: "Nachname",
                placeholder: "Nachname eingeben",
                text: $lastName,
                isSecure: false
            )
            .textInputAutocapitalization(.words)
            
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
    
    // MARK: - Newsletter Checkbox
    
    private var newsletterCheckbox: some View {
        Button {
            newsletter.toggle()
        } label: {
            HStack(alignment: .top, spacing: 9) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(newsletter ? Color.blue : Color(white: 0.47), lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    if newsletter {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Label text
                Text("Immer auf dem Laufenden bleiben – erhalte aktuelle Neuigkeiten und Inhalte direkt in dein Postfach.")
                    .font(.system(size: 15))
                    .foregroundColor(Color(white: 0.73))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
            }
        }
        .padding(.top, 8)
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
    
    // MARK: - Register Button
    
    private var registerButton: some View {
        Button {
            handleRegister()
        } label: {
            ZStack {
                Text("Registrieren")
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
        .disabled(viewModel.isLoading)
        .opacity(viewModel.isLoading ? 0.6 : 1)
        .padding(.top, 32)
    }
    
    // MARK: - Validation & Registration
    
    private func handleRegister() {
        // Validate first name and last name
        if firstName.isEmpty || lastName.isEmpty {
            alertMessage = "Bitte geben Sie Ihren Namen ein"
            showingAlert = true
            return
        }
        
        // Validate email exists
        if email.isEmpty {
            alertMessage = "Bitte geben Sie Ihre E-Mail-Adresse ein"
            showingAlert = true
            return
        }
        
        // Validate email format
        let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
        if email.firstMatch(of: emailRegex) == nil {
            alertMessage = "Bitte geben Sie eine gültige E-Mail-Adresse ein"
            showingAlert = true
            return
        }
        
        // Validate password exists
        if password.isEmpty {
            alertMessage = "Bitte geben Sie ein Passwort ein"
            showingAlert = true
            return
        }
        
        // Validate password length
        if password.count < 6 {
            alertMessage = "Passwort muss mindestens 6 Zeichen lang sein"
            showingAlert = true
            return
        }
        
        // Calculate timezone offset (same as RN: -new Date().getTimezoneOffset())
        let timezoneOffsetMinutes = -TimeZone.current.secondsFromGMT() / 60
        
        Task {
            await viewModel.register(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                timezoneOffsetMinutes: timezoneOffsetMinutes
            )
        }
    }
}

// MARK: - Preview

#Preview {
    RegisterView(
        viewModel: AuthViewModel(
            authService: AuthService(
                apiClient: .shared,
                keychainManager: .shared
            )
        ),
        onBackTapped: {
            print("Back tapped")
        }
    )
}
