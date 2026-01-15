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
    
    private var expirationDate: Date {
        tokenIssuedAt.addingTimeInterval(TimeInterval(expiresIn * 60))
    }

    var isExpired: Bool {
        Date() >= expirationDate
    }

    var isExpiringSoon: Bool {
        let bufferSeconds: TimeInterval = 60
        return Date() >= expirationDate.addingTimeInterval(-bufferSeconds)
    }

    var secondsUntilExpiry: TimeInterval {
        expirationDate.timeIntervalSince(Date())
    }

    init(accessToken: String, refreshToken: String, tokenType: String, expiresIn: Int) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        
        self.tokenIssuedAt = Date()
    }
    
    init(from response: LoginResponse) {
        self.accessToken = response.accessToken
        self.refreshToken = response.refreshToken
        self.tokenType = response.tokenType
        self.expiresIn = response.expiresIn
        
        tokenIssuedAt = Date()
    }
}
