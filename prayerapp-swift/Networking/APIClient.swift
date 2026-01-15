//
//  APIClient.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 13.01.2026.
//

import Foundation

@MainActor
final class APIClient {
    
    // MARK: - Singleton
    
    static let shared = APIClient()
    
    private init() {}
    
    weak var tokenProvider: TokenProviderProtocol?
    
    // MARK: - Properties
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()
    
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: (any Encodable)? = nil,
        token: String? = nil
    ) async throws -> T {
        
        guard let url = URL(string: Config.baseURL + endpoint) else {
            throw APIError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try encoder.encode(body)
        }
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw APIError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noData
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw APIError.unauthorized
        default:
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw APIError.decodingError
        }
    }
    
    func authenticatedRequest<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: (any Encodable)? = nil
    ) async throws -> T {
        
        guard let tokenProvider = tokenProvider else {
            throw APIError.unauthorized
        }
        
        let token = try await tokenProvider.getValidToken()
        
        do {
            return try await request(
                endpoint: endpoint,
                method: method,
                body: body,
                token: token
            )
        } catch APIError.unauthorized {
            do {
                let newToken = try await tokenProvider.refreshToken()
                
                return try await request(
                    endpoint: endpoint,
                    method: method,
                    body: body,
                    token: newToken
                )
            } catch {
                await tokenProvider.handleAuthenticationFailure()
                throw APIError.unauthorized
            }
        }
    }
}
