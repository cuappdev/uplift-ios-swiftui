//
//  GymIdentifier.swift
//  Uplift
//
//  Created by jiwon jeong on 10/2/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import Foundation

/// An enumeration representing the gyms.
enum GymIdentifier: String, CaseIterable, Identifiable {
    case teagleUp = "TEAGLEUP"
    case teagleDown = "TEAGLEDOWN"
    case helenNewman = "HELENNEWMAN"
    case toniMorrison = "TONIMORRISON"
    case noyes = "NOYES"

    var id: String { rawValue }

}

extension GymIdentifier {

    /// Returns the display name (capitalized) for UI.
    func displayName() -> String {
        switch self {
        case .teagleUp: return "Teagle Up"
        case .teagleDown: return "Teagle Down"
        case .helenNewman: return "Helen Newman"
        case .toniMorrison: return "Toni Morrison"
        case .noyes: return "Noyes"
        }
    }

}
