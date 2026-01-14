//
//  LoginRequest.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 13.01.2026.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}
