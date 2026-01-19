//
//  Color+Hex.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 16.01.2026.
//

import SwiftUI
                                                                                                   
 extension Color {
     // Initialize Color from a hex string like "#3A3A3C" or "3A3A3C"
     init(hex: String) {
         let cleanedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
                                                                                                   
         var int: UInt64 = 0
         Scanner(string: cleanedHex).scanHexInt64(&int)
                                                                                                   
         let r, g, b: UInt64
         switch cleanedHex.count {
         case 6: // RGB (24-bit)
             (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
         default:
             (r, g, b) = (0, 0, 0)
         }
                                                                                                   
         self.init(
             red: Double(r) / 255,
             green: Double(g) / 255,
             blue: Double(b) / 255
         )
     }
 }
