//
//  KeychainManager.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 13.01.2026.
//

import Foundation
import Security

final class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() {}
    
    private let service = "com.icf.prayerapp"
    private let authTokensKey = "authTokens"
    
    func saveTokens(_ tokens: AuthTokens) throws {
        let data  = try JSONEncoder().encode(tokens)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: authTokensKey,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }
    
    func getTokens() throws -> AuthTokens? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: authTokensKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                throw KeychainError.dataConversionFailed
            }
            
            let tokens = try JSONDecoder().decode(AuthTokens.self, from: data)
            return tokens
            
        case errSecItemNotFound:
            return nil
            
        default:
            throw KeychainError.retrievalFailed(status)
        }
    }
    
    func deleteTokens() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: authTokensKey
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }
}

enum KeychainError: Error {
    case saveFailed(OSStatus)
    case retrievalFailed(OSStatus)
    case deleteFailed(OSStatus)
    case dataConversionFailed
}
