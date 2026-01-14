//
//  Environment.swift
//  prayerapp-swift
//
//  Configuration for different environments (Development vs Production)
//
//  LESSON: This file teaches you about:
//  - Enums in Swift
//  - Static properties
//  - Computed properties
//  - How to manage different environments
//

import Foundation

/// Represents the different environments the app can run in.
///
/// An enum (short for "enumeration") is a type that has a fixed set of possible values.
/// Think of it like a multiple-choice question - it can only be one of the defined cases.
///
/// Example:
/// ```
/// let env = Environment.development
/// print(env.baseURL)  // "http://localhost:8000"
/// ```
enum Environment {

    // MARK: - Cases

    /// Development environment - for local testing
    /// Your Laravel backend running on your machine
    case development

    /// Production environment - the live server
    /// The real API that users will connect to
    case production

    // MARK: - Current Environment

    /// The current environment the app is using.
    ///
    /// Change this value to switch between environments:
    /// - Use `.development` when working locally
    /// - Use `.production` for release builds
    ///
    /// TODO: In a real app, you might set this based on build configuration
    /// (e.g., Debug vs Release builds)
    static let current: Environment = .development

    // MARK: - Configuration Values

    /// The base URL for API requests.
    ///
    /// This is a "computed property" - it calculates its value each time you access it.
    /// The `switch` statement checks which case `self` is and returns the appropriate URL.
    var baseURL: String {
        switch self {
        case .development:
            // Your local Laravel server
            // Change this to match your local setup
            return "http://localhost"

        case .production:
            // Your production API server
            // TODO: Replace with your actual production URL
            return "https://api.yourapp.com"
        }
    }

    /// The API version prefix (for JSON:API endpoints)
    var apiVersion: String {
        return "/api/v1"
    }

    /// The authentication endpoint prefix
    var authPrefix: String {
        return "/api/auth"
    }

    /// Full URL for API requests (baseURL + apiVersion)
    ///
    /// Example: "http://localhost/api/v1"
    var apiBaseURL: String {
        return baseURL + apiVersion
    }

    /// Full URL for auth requests (baseURL + authPrefix)
    ///
    /// Example: "http://localhost/api/auth"
    var authBaseURL: String {
        return baseURL + authPrefix
    }

    // MARK: - Debug Settings

    /// Whether to print network requests to console (for debugging)
    var isDebugLoggingEnabled: Bool {
        switch self {
        case .development:
            return true  // Show logs during development
        case .production:
            return false // Hide logs in production
        }
    }
}

// MARK: - Convenience Access

/// Quick access to current environment settings.
///
/// Instead of writing `Environment.current.baseURL`, you can write `Config.baseURL`.
/// This is just a convenience wrapper.
///
/// Usage:
/// ```
/// let url = Config.apiBaseURL + "/spaces"
/// // Returns: "http://localhost:8000/api/v1/spaces"
/// ```
enum Config {
    /// Base URL for all API requests
    static var baseURL: String {
        Environment.current.baseURL
    }

    /// Base URL for JSON:API endpoints
    static var apiBaseURL: String {
        Environment.current.apiBaseURL
    }

    /// Base URL for authentication endpoints
    static var authBaseURL: String {
        Environment.current.authBaseURL
    }

    /// Whether debug logging is enabled
    static var isDebugLoggingEnabled: Bool {
        Environment.current.isDebugLoggingEnabled
    }
}
