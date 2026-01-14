//
//  AuthService.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 13.01.2026.
//
import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> User
    func logout() async throws
    func getCurrentUser() async throws -> User
}

final class AuthService: AuthServiceProtocol {
    private let apiClient: APIClient
    private let keychainManager: KeychainManager
    
    init(
        apiClient: APIClient = .shared,
        keychainManager: KeychainManager = .shared
    ) {
        self.apiClient = apiClient
        self.keychainManager = keychainManager
    }
    
    // MARK: - Public Methods
    
    func login(email: String, password: String) async throws -> User {
        // Step 1: Create the request body
        let loginRequest = LoginRequest(email: email, password: password)
        
        // Step 2: Call the API
        let response: LoginResponse = try await apiClient.request(
            endpoint: "/api/auth/login",
            method: "POST",
            body: loginRequest
        )
        
        // Step 3: Convert to AuthTokens (adds timestamp)
        let tokens = AuthTokens(from: response)
        
        // Step 4: Save tokens to Keychain
        try keychainManager.saveTokens(tokens)
        
        // Step 5: Fetch and return the user
        return try await getCurrentUser()
    }
    
    func getCurrentUser() async throws -> User {
        // Get the access token from Keychain
        guard let tokens = try keychainManager.getTokens() else {
            throw AuthError.notAuthenticated
        }
        
        // Call /api/auth/me with the token
        let user: User = try await apiClient.request(
            endpoint: "/api/auth/me",
            method: "POST",
            token: tokens.accessToken
        )
        
        return user
    }
    
    func logout() async throws {
        // Delete tokens from Keychain
        try keychainManager.deleteTokens()
        
        // Optionally: call backend to invalidate token
        // For now, just clearing local tokens is enough
    }
}

// MARK: - Auth Errors

enum AuthError: LocalizedError {
    case notAuthenticated
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "User is not authenticated"
        }
    }
}
