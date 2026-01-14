//
//  User.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 13.01.2026.
//
import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let imageUrl: String?
    let firstName: String?
    let lastName: String?
    let email: String
    let phone: String?
    let username: String?
    let timezoneOffsetMinutes: String?
    let onboardedAt: String?  // API returns ISO8601 string, not Date
}
