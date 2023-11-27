//
//  HomeViewModel.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//

import SwiftUI

extension HomeView {

    /// The ViewModel for the Home page view.
    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Helpers

        /**
         The heading text for the navigation bar based on the current time of day.

         * "Good Morning!" if the current hour is from 12 AM to 11AM.
         * "Good Afternoon!" if the current hour is from 12PM to 5PM.
         * "Good Evening!" if the current hour is from 6PM to 11PM.
         */
        var headingText: String {
            let hour = Calendar.current.component(.hour, from: Date.now)
            switch hour {
            case 0..<12:
                return "Good Morning!"
            case 13..<17:
                return "Good Afternoon!"
            default:
                return "Good Evening!"
            }
        }

    }

}
