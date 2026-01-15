//
//  TokenroviderProtocol.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 15.01.2026.
//

protocol TokenProviderProtocol: AnyObject {
    func getValidToken() async throws -> String
    func refreshToken() async throws -> String
    func handleAuthenticationFailure() async
}
