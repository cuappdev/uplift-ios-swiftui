//
//  GiveawayPopup.swift
//  Uplift
//
//  Created by Vin Bui on 4/15/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// View representing the giveaway popup.
struct GiveawayPopup: View {

    // MARK: - Properties

    @Binding var didClickSubmit: Bool
    @Binding var instagram: String
    @Binding var netID: String
    @Binding var popUpGiveaway: Bool
    @Binding var submitSuccessful: Bool

    // MARK: - UI

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                if submitSuccessful {
                    thanksMessage
                } else {
                    header
                    bodySection
                }
            }

            closeButton
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(height: 469)
        .upliftShadow(Constants.Shadows.smallDark)
    }

    private var header: some View {
        ZStack(alignment: .center) {
            Constants.Images.giveawayPopupBackground
                .resizable()
                .scaledToFill()
                .frame(height: 165)
                .clipped()

            Constants.Images.logoWhite
                .resizable()
                .frame(width: 82, height: 82)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    private var bodySection: some View {
        VStack(spacing: 40) {
            VStack(spacing: 12) {
                Text("Uplift Giveaway!")
                    .font(Constants.Fonts.h1)

                Text("Tell us who you are for a chance to win special prizes!!")
                    .font(Constants.Fonts.bodyNormal)
                    .multilineTextAlignment(.leading)
            }

            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    netIDTextField
                    instagramTextField
                }

                submitButton
            }
        }
        .foregroundStyle(Constants.Colors.black)
        .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
        .background(Constants.Colors.white)
    }

    private var netIDTextField: some View {
        TextField(
            "",
            text: $netID,
            prompt: Text("Cornell NetID")
                .foregroundColor(Constants.Colors.gray02)
        )
        .font(Constants.Fonts.bodyLight)
        .padding(8)
        .background(Constants.Colors.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Constants.Colors.gray02, lineWidth: 1)
        )
    }

    private var instagramTextField: some View {
        TextField(
            "",
            text: $instagram,
            prompt: Text("Instagram username")
                .foregroundColor(Constants.Colors.gray02)
        )
        .font(Constants.Fonts.bodyLight)
        .padding(8)
        .background(Constants.Colors.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Constants.Colors.gray02, lineWidth: 1)
        )
    }

    private var submitButton: some View {
        Button {
            if !netID.isEmpty {
                didClickSubmit = true
            }
        } label: {
            Text("SUBMIT")
                .font(Constants.Fonts.h3)
                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Constants.Colors.yellow)
                )
                .opacity(netID.isEmpty ? 0.5 : 1)
        }
    }

    private var closeButton: some View {
        Button {
            withAnimation {
                popUpGiveaway = false
            }
        } label: {
            Constants.Images.cross
                .resizable()
                .frame(width: 12, height: 12)
                .background(
                    Circle()
                        .fill(Constants.Colors.white)
                        .frame(width: 28, height: 28)
                )
        }
        .padding([.trailing, .top], 24)
    }

    private var thanksMessage: some View {
        ZStack(alignment: .center) {
            Constants.Images.giveawayPopupBackground
                .resizable()
                .scaledToFill()
                .clipped()

            VStack(spacing: 32) {
                Constants.Images.logoWhite
                    .resizable()
                    .frame(width: 82, height: 82)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Text("Thanks for your response!")
                    .foregroundStyle(Constants.Colors.white)
                    .font(Constants.Fonts.h1)
                    .multilineTextAlignment(.center)
                    .background(
                        Constants.Colors.giveawayBgColor
                    )
            }
            .padding(.horizontal, 40)
        }
    }

}
