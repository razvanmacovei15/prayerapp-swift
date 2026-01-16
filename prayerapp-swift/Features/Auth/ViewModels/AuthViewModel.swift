//
//  AuthViewModel.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 14.01.2026.
//

import Foundation

@MainActor
@Observable
final class AuthViewModel {
    private(set) var user: User?
    private(set) var isLoading: Bool = false
    private(set) var isCheckingAuth: Bool = true
    private(set) var errorMessage: String?
    
    private let authService: AuthServiceProtocol
    
    var isAuthenticated: Bool {
        user != nil
    }
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    /// Called on app launch to check for existing valid session
    func checkExistingAuth() async {
        isCheckingAuth = true
        
        defer { isCheckingAuth = false }
        
        do {
            user = try await authService.checkExistingSession()
        } catch {
            user = nil
        }
    }
    
    func register(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        timezoneOffsetMinutes: Int
    ) async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let request = RegisterRequest(firstName: firstName, lastName: lastName, email: email, password: password, timezoneOffsetMinutes: timezoneOffsetMinutes)
            user = try await authService.register(request: request)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Login with email and password
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            user = try await authService.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Logout and clear all auth state
    func logout() async {
        user = nil
        errorMessage = nil
        
        do {
            try await authService.logout()
        } catch {
            print("Backend logout failed: \(error)")
        }
    }
    
    func checkAndRefreshIfNeeded() async {
        guard isAuthenticated else { return }

        do {
            _ = try await authService.ensureValidToken()
        } catch {
            await logout()
        }
    }
}
