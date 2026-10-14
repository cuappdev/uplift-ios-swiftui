//
//  KeychainManager.swift
//  Uplift
//
//  Created by Richie Sun on 4/27/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import Foundation
import OSLog
import Security

class KeychainManager {

    // MARK: - Singleton Instance

    static let shared = KeychainManager()

    // MARK: - Init

    private init() { }

    // MARK: - Keychain Management Functions

    func save(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        SecItemDelete(query)

        // readable on a locked phone so background wakes (gym reminders) can see the session
        let addQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData: data
        ] as CFDictionary
        let status = SecItemAdd(addQuery, nil)

        if status != errSecSuccess {
            Logger.services.error("Keychain save failed for \(key): \(status)")
        }
    }

    func get(forKey key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }

        return value
    }

    func delete(forKey key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        let status = SecItemDelete(query)

        if status != errSecSuccess, status != errSecItemNotFound {
            Logger.services.error("Keychain delete failed for \(key): \(status)")
        }
    }
}
