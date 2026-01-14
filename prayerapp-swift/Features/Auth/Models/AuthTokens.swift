//
//  AuthTokens.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 13.01.2026.
//

import Foundation

struct AuthTokens: Codable {
    
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
    let tokenIssuedAt: Date
    
    var isExpired: Bool {
        let expirationDate = tokenIssuedAt.addingTimeInterval(TimeInterval(expiresIn * 60))
        return Date() >= expirationDate
    }
    
    init(from response: LoginResponse) {
        self.accessToken = response.accessToken
        self.refreshToken = response.refreshToken
        self.tokenType = response.tokenType
        self.expiresIn = response.expiresIn
        
        tokenIssuedAt = Date()
    }
}
