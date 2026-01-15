//
//  LoginResponse.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 13.01.2026.
//
import Foundation

struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
}

struct EmptyResponse: Decodable {}
