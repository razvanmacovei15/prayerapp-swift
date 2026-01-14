//
//  APIError.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 13.01.2026.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidUrl
    case noData
    case decodingError
    case unauthorized
    case serverError(statusCode: Int)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .noData:
            return "No data returned from the server"
        case .decodingError:
            return "Failed to decode data from the server"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError(statusCode: let statusCode):
            return "Server Error (code: \(statusCode))."
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        }
    }
}
