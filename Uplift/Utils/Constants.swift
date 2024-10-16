//
//  Constants.swift
//  Uplift
//
//  Created by Vin Bui on 11/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
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
        static let lightGray = Color(red: 248/255, green: 250/255, blue: 250/255)
        static let gray00 = Color(red: 239/255, green: 241/255, blue: 244/255)
        static let gray01 = Color(red: 229/255, green: 236/255, blue: 237/255)
        static let gray02 = Color(red: 209/255, green: 213/255, blue: 218/255)
        static let gray03 = Color(red: 161/255, green: 165/255, blue: 166/255)
        static let gray04 = Color(red: 112/255, green: 112/255, blue: 112/255)
        static let gray05 = Color(red: 115/255, green: 131/255, blue: 144/255)

        // Others
        static let giveawayBgColor = Color(red: 34/255, green: 36/255, blue: 42/255)
    }

    /// Facility names in Uplift.
    enum FacilityNames {
        static let hnhFitness = "HNH Fitness Center"
        static let hnhPool = "HNH Pool"
        static let hnhBowling = "HNH Bowling"
        static let hnhCourt1 = "HNH Court 1"
        static let hnhCourt2 = "HNH Court 2"
        static let morrFitness = "Morrison Fitness Center"
        static let noyesFitness = "Noyes Fitness Center"
        static let noyesCourt = "Noyes Court"
        static let teagleDown = "Teagle Down Fitness Center"
        static let teagleUp = "Teagle Up Fitness Center"
        static let teaglePool = "Teagle Pool"
    }

    /// Fonts used in Uplift's design system.
    enum Fonts {
        // H Headers
        static let h0 = Font.custom("Montserrat-Bold", size: 36)
        static let h1 = Font.custom("Montserrat-Bold", size: 24)
        static let h2 = Font.custom("Montserrat-Bold", size: 16)
        static let h3 = Font.custom("Montserrat-Bold", size: 14)
        static let h4 = Font.custom("Montserrat-Bold", size: 12)

        // F Headers
        static let f1 = Font.custom("Montserrat-Medium", size: 24)
        static let f2 = Font.custom("Montserrat-Medium", size: 16)
        static let f2Light = Font.custom("Montserrat-Light", size: 16)
        static let f2Regular = Font.custom("Montserrat-Regular", size: 16)
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
        static let appdevLogo = Image("appdev-logo")
        static let arrowLeft = Image("arrow_left")
        static let basketball = Image("basketball")
        static let bowling = Image("bowling")
        static let calendar = Image("calendar")
        static let capacity = Image("capacity")
        static let chevronDown = Image("chevron_down")
        static let clock = Image("clock")
        static let cross = Image("cross")
        static let dumbbellLarge = Image("dumbbell_large")
        static let dumbbellOutline = Image("dumbbell_outline")
        static let dumbbellSolid = Image("dumbbell_solid")
        static let elevator = Image("elevator")
        static let greenCheckCircle = Image("green_check_circle")
        static let greenTea = Image("green_tea")
        static let giveawayModalBackground = Image("giveaway_modal_bg")
        static let giveawayPopupBackground = Image("giveaway_popup_bg")
        static let lock = Image("lock")
        static let logo = Image("logo")
        static let logoWhite = Image("logo_white")
        static let parking = Image("parking")
        static let pool = Image("pool")
        static let shower = Image("shower")
        static let whistleOutline = Image("whistle_outline")
        static let whistleSolid = Image("whistle_solid")
    }

    /// Padding amounts used in Uplift.
    enum Padding {
        static let classDetailSessionsHorizontal: CGFloat = 16
        static let classDetailSpacing: CGFloat = 24
        static let classDetailTextHorizontal: CGFloat = 48
        static let gymDetailHorizontal: CGFloat = 24
        static let gymDetailSpacing: CGFloat = 20
        static let homeHorizontal: CGFloat = 16
        static let remindersHorizontal: CGFloat = 16
        static let remindersVertical: CGFloat = 24
        static let reportHorizontal: CGFloat = 16
        static let reportVertical: CGFloat = 24
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
