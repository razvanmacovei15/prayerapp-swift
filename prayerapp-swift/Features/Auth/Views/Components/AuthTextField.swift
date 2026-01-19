//
//  AuthTextField.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 16.01.2026.
//

import Foundation
import SwiftUI

struct AuthTextField: View {
    
    let label: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    @State private var showPassword: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.system(size:14, weight:.semibold))
                .foregroundColor(Color.white.opacity(0.6))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            
            HStack {
                if isSecure && !showPassword {
                    SecureField(placeholder, text: $text)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                }
                
                if isSecure {
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(Color.blue)
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 54)
            .background(Color(hex: "#3A3A3C"))
            .cornerRadius(15)
            .foregroundColor(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
    }
}


#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: 20) {
            AuthTextField(
                label: "Email",
                placeholder: "Enter your email",
                text: .constant("test@example.com"),
                isSecure: false
            )
            
            AuthTextField(
                label: "Password",
                placeholder: "••••••",
                text: .constant(""),
                isSecure: true,
            )
        }
        .padding()
    }
}

