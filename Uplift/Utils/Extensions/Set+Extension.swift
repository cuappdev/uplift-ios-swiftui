//
//  Set+Extension.swift
//  Uplift
//
//  Created by Sandy Yang on 10/7/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

extension Set {

    /// Inserts the element if it is not in this set, otherwise removes it.
    mutating func toggle(_ element: Element) {
        if contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}
