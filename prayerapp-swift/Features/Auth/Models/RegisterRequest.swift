//
//  RegisterRequest.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 15.01.2026.
//

import Foundation

struct RegisterRequest: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let timezoneOffsetMinutes: Int
}
