//
//  ContentView.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 13.01.2026.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @State private var email = ""
    @State private var password = ""
    @State private var resultMessage = ""
    @State private var isLoading = false
    
    private let authService = AuthService()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login Test")
                .font(.largeTitle)
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button("Login") {
                Task{
                    await performLogin()
                }
            }.disabled(isLoading || email.isEmpty || password.isEmpty)
            
            if isLoading {
                ProgressView()
            }
            
            Text(resultMessage)
                .foregroundStyle(resultMessage.contains("Error") ? .red : .green)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func performLogin()  async {
        isLoading = true
        resultMessage = ""
        
        do {
            let user = try await authService.login(email: email, password: password)
            resultMessage = "Success! Welcome \(user.firstName ?? "") \(user.lastName ?? "")"
        } catch {
            resultMessage = "Error: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

#Preview {
    ContentView()
}
