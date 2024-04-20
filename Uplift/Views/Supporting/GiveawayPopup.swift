//
//  GiveawayPopup.swift
//  Uplift
//
//  Created by Belle Hu on 4/6/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI
import UpliftAPI

/// View representing the giveaway popup.
struct GiveawayPopup: View {

    // MARK: - Properties
    @State var instaAcct: String = ""
    @State var netid: String = ""
    @Binding var popupIsPresented: Bool
    @Binding var popupSubmitted: Bool
    @StateObject private var viewModel = ViewModel()

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            logoView
                .frame(width: 351, height: 165, alignment: .top)

            infoView
                .frame(width: 351, height: 304, alignment: .top)
                .background(Constants.Colors.white)
        }
        .frame(width: 351, height: 469, alignment: .top)
        .cornerRadius(20)
    }

    private var logoView: some View {
        ZStack {
            Constants.Images.giveawayInfo
            Button {
                popupIsPresented = false
            } label: {
                Constants.Images.xIcon
                    .frame(width: 29, height: 29, alignment: .trailing)
                    .padding(EdgeInsets(top: 13, leading: 311, bottom: 124, trailing: 0))
            }
        }
    }

    private var infoView: some View {
        VStack {
            Spacer()
                .frame(height: 21)

            Text("Uplift Giveaway!")
                .font(Constants.Fonts.h1)
                .foregroundStyle(Constants.Colors.black)

            Spacer()
                .frame(height: 14)

            Text("Tell us who you are for a chance to \n win special prizes!!")
                .font(Constants.Fonts.bodyNormal)
                .foregroundStyle(Constants.Colors.black)
                .multilineTextAlignment(.leading)
                .lineLimit(2, reservesSpace: true)

            Spacer()
                .frame(height: 39)

            TextField("", text: $netid, prompt: placeholderText("Cornell NetID"))
                .autocapitalization(.none)
                .padding()
                .frame(width: 266, height: 36)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Constants.Colors.gray02, lineWidth: 3)
                )
                .cornerRadius(10)

            TextField("", text: $instaAcct, prompt: placeholderText("Instagram account"))
                .autocapitalization(.none)
                .padding()
                .frame(width: 266, height: 36)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Constants.Colors.gray02, lineWidth: 3)
                )
                .cornerRadius(10)

            Spacer()
                .frame(height: 28)

            submitButton

            Spacer()
                .frame(height: 19)
        }
    }

    private func placeholderText(_ txt: String) -> Text {
        Text(txt)
            .font(Constants.Fonts.bodyLight)
            .foregroundColor(Constants.Colors.gray04)
    }

    private var submitButton: some View {
        Button {
            self.popupSubmitted = true

            Task {
                await viewModel.createUser(self.netid)
                await viewModel.enterGiveaway(2, self.netid)
            }

        } label: {
            Text("SUBMIT")
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.black)
                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                .background(Constants.Colors.yellow)
                .clipShape(
                    RoundedRectangle(cornerRadius: 38)
                )
        }
    }

}
