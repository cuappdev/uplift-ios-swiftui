//
//  Double+Extension.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//

import Foundation

extension Double {

    /// This double rounded as a percentage.
    var percentString: String {
        "\(Int((self * 100.0).rounded()))%"
    }

}
