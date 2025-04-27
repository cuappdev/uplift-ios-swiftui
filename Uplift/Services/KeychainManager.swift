//
//  KeychainManager.swift
//  Uplift
//
//  Created by Richie Sun on 4/27/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import Foundation
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

        let addQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        SecItemAdd(addQuery, nil)
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
        SecItemDelete(query)
    }
}
