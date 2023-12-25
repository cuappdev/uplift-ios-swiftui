//
//  Constants.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//

import SwiftUI

/// Constants used in Uplift's design system such as colors, fonts, etc.
struct Constants {

    /// Colors used in Uplift's design system.
    enum Colors {
        // Primary
        static let black = Color(red: 34/255, green: 34/255, blue: 34/255)
        static let lightYellow = Color(red: 252/255, green: 245/255, blue: 164/255)
        static let white = Color.white
        static let yellow = Color(red: 248/255, green: 231/255, blue: 28/255)

        // Accent
        static let blue = Color(red: 19/255, green: 149/255, blue: 254/255)
        static let closed = Color(red: 240/255, green: 125/255, blue: 125/255)
        static let open = Color(red: 100/255, green: 194/255, blue: 112/255)
        static let orange = Color(red: 254/255, green: 143/255, blue: 19/255)
        static let purple = Color(red: 56/255, green: 19/255, blue: 254/255)
        static let red = Color(red: 254/255, green: 19/255, blue: 19/255)
        static let seafoam = Color(red: 19/255, green: 254/255, blue: 215/255)
        static let turquoise = Color(red: 74/255, green: 210/255, blue: 242/255)

        // Gray
        static let gray01 = Color(red: 229/255, green: 236/255, blue: 237/255)
        static let gray02 = Color(red: 209/255, green: 213/255, blue: 218/255)
        static let gray03 = Color(red: 161/255, green: 165/255, blue: 166/255)
        static let gray04 = Color(red: 112/255, green: 112/255, blue: 112/255)
        static let gray05 = Color(red: 115/255, green: 131/255, blue: 144/255)
    }

    /// Fonts used in Uplift's design system.
    enum Fonts {
        // H Headers
        static let h1 = Font.custom("Montserrat-Bold", size: 24)
        static let h2 = Font.custom("Montserrat-Bold", size: 16)
        static let h3 = Font.custom("Montserrat-Bold", size: 14)
        static let h4 = Font.custom("Montserrat-Bold", size: 12)

        // F Headers
        static let f1 = Font.custom("Montserrat-Medium", size: 24)
        static let f2 = Font.custom("Montserrat-Medium", size: 16)
        static let f3 = Font.custom("Montserrat-Medium", size: 14)
        static let f4 = Font.custom("Montserrat-Medium", size: 12)

        // S Headers
        static let s1 = Font.custom("BebasNeue-Regular", size: 48)
        static let s2 = Font.custom("BebasNeue-Regular", size: 32)
        static let s3 = Font.custom("BebasNeue-Regular", size: 24)

        // Body
        static let bodyLight = Font.custom("Montserrat-Light", size: 14)
        static let bodyNormal = Font.custom("Montserrat-Regular", size: 14)
        static let bodyMedium = Font.custom("Montserrat-Medium", size: 14)
        static let bodySemibold = Font.custom("Montserrat-SemiBold", size: 14)
        static let bodyBold = Font.custom("Montserrat-Bold", size: 14)

        // Labels
        static let labelLight = Font.custom("Montserrat-Light", size: 12)
        static let labelNormal = Font.custom("Montserrat-Regular", size: 12)
        static let labelMedium = Font.custom("Montserrat-Medium", size: 12)
        static let labelSemibold = Font.custom("Montserrat-SemiBold", size: 12)
        static let labelBold = Font.custom("Montserrat-Bold", size: 12)
    }

    /// Image components used in Uplift.
    enum Images {
        static let basketball = Image("basketball")
        static let bowling = Image("bowling")
        static let dumbbellLarge = Image("dumbbell_large")
        static let dumbbellSmall = Image("dumbbell_small")
        static let pool = Image("pool")
    }

    /// Padding amounts used in Uplift.
    enum Padding {
        static let horizontal: CGFloat = 16
    }

    /// Shadows usde in Uplift's design system.
    enum Shadows {
        static let normalDark = ShadowConfig(
            color: Constants.Colors.black,
            radius: 14,
            x: 0,
            y: 11
        )
        static let normalLight = ShadowConfig(
            color: Constants.Colors.gray01,
            radius: 40,
            x: 0,
            y: 10
        )
        static let smallDark = ShadowConfig(
            color: Constants.Colors.black,
            radius: 20,
            x: 0,
            y: 4
        )
        static let smallLight = ShadowConfig(
            color: Constants.Colors.gray01,
            radius: 20,
            x: 0,
            y: 4
        )
    }

}
