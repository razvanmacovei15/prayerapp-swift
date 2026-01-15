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
    
    func refreshToken() async throws -> String
    func ensureValidToken() async throws -> String
    func scheduleTokenRefresh()
    func cancelScheduledRefresh()
    
    func checkExistingSession() async throws -> User?
}

@MainActor
final class AuthService: AuthServiceProtocol, TokenProviderProtocol {
    private let apiClient: APIClient
    private let keychainManager: KeychainManager
    
    private var refreshTask: Task<String, Error>?
    private var scheduledRefreshTask: Task<Void, Never>?
    
    init(
        apiClient: APIClient,
        keychainManager: KeychainManager
    ) {
        self.apiClient = apiClient
        self.keychainManager = keychainManager
    }
    
    // MARK: - Public Methods
    
    func login(email: String, password: String) async throws -> User {
        let loginRequest = LoginRequest(email: email, password: password)
        
        let response: LoginResponse = try await apiClient.request(
            endpoint: "/api/auth/login",
            method: "POST",
            body: loginRequest
        )
        
        let tokens = AuthTokens(from: response)
        
        try keychainManager.saveTokens(tokens)
        
        scheduleTokenRefresh()

        return try await getCurrentUser()
    }
    
    func getCurrentUser() async throws -> User {
        guard let tokens = try keychainManager.getTokens() else {
            throw AuthError.notAuthenticated
        }
        
        let user: User = try await apiClient.request(
            endpoint: "/api/auth/me",
            method: "POST",
            token: tokens.accessToken
        )
        
        return user
    }
    
    func logout() async throws {
        cancelScheduledRefresh()
        
        let token = try? keychainManager.getTokens()?.accessToken
        
        try keychainManager.deleteTokens()
        
        if let token = token {
            Task {
                do {
                    let _: EmptyResponse = try await apiClient.request(
                        endpoint: "/api/auth/logout",
                        method: "POST",
                        token: token
                    )
                } catch {
                    print("Backend logout failed (non-critical): \(error)")
                }
            }
        }
    }
    
    func refreshToken() async throws -> String {
        if let existingTask = refreshTask {
            return try await existingTask.value
        }

        let task = Task<String, Error> {
            guard let tokens = try keychainManager.getTokens() else {
                throw AuthError.notAuthenticated
            }

            guard !tokens.refreshToken.isEmpty else {
                throw AuthError.noRefreshToken
            }

            let response: LoginResponse

            do {
                response = try await apiClient.request(
                    endpoint: "/api/auth/refresh",
                    method: "POST",
                    token: tokens.refreshToken
                )
            } catch let error as APIError {
                if case .unauthorized = error {
                    throw AuthError.sessionExpired
                }
                throw AuthError.tokenRefreshFailed
            } catch {
                throw AuthError.tokenRefreshFailed
            }

            let newTokens = AuthTokens(from: response)
            try keychainManager.saveTokens(newTokens)

            scheduleTokenRefresh()

            return newTokens.accessToken
        }

        refreshTask = task

        defer { refreshTask = nil }

        return try await task.value
    }
    
    func ensureValidToken() async throws -> String {
        guard let tokens = try keychainManager.getTokens() else {
            throw AuthError.notAuthenticated
        }

        if tokens.isExpired || tokens.isExpiringSoon {
            return try await refreshToken()
        }

        return tokens.accessToken
    }
    
    func scheduleTokenRefresh() {
        scheduledRefreshTask?.cancel()
        scheduledRefreshTask = nil

        guard let tokens = try? keychainManager.getTokens() else {
            return
        }

        let delay = max(30, tokens.secondsUntilExpiry - 60)

        scheduledRefreshTask = Task {
            try? await Task.sleep(for: .seconds(delay))

            guard !Task.isCancelled else { return }

            do {
                _ = try await refreshToken()
            } catch {
                // Refresh failed - will be handled on next API request
            }
        }
    }
    
    func cancelScheduledRefresh() {
        scheduledRefreshTask?.cancel()
        scheduledRefreshTask = nil
        
        refreshTask?.cancel()
        refreshTask = nil
    }
    
    func checkExistingSession() async throws -> User? {
        guard (try? keychainManager.getTokens()) != nil else {
            return nil
        }

        do {
            _ = try await ensureValidToken()
            let user = try await getCurrentUser()
            scheduleTokenRefresh()
            return user
        } catch {
            try? keychainManager.deleteTokens()
            return nil
        }
    }
}

// MARK: - Auth Errors

enum AuthError: LocalizedError {
    case notAuthenticated
    case tokenRefreshFailed
    case noRefreshToken
    case sessionExpired
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "User is not authenticated"
        case .tokenRefreshFailed:
            return "Failed to refresh authentication token"
        case .noRefreshToken:
            return "No refresh token available"
        case .sessionExpired:
            return "Your session has expired. Please log in again"
        }
    }
}

extension AuthService {
    func getValidToken() async throws -> String {
        return try await ensureValidToken()
    }
    
    func handleAuthenticationFailure() async {
        cancelScheduledRefresh()
        try? keychainManager.deleteTokens()
    }
}
