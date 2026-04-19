//
//  DeleteAccountModal.swift
//  Uplift
//
//  Created by jiwon jeong on 4/19/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A modal for confirming account deletion.
struct DeleteAccountModal: View {
    let onDelete: () -> Void
    let onBack: () -> Void
    let onClose: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 16) {
                Constants.Images.trash
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Constants.Colors.black)

                VStack(spacing: 8) {
                    Text("Are you sure you want to\ndelete your Uplift account?")
                        .font(Constants.Fonts.f3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Constants.Colors.black)

                    Text("All workout data will be lost.")
                        .font(Constants.Fonts.labelNormal)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Constants.Colors.gray04)
                }
                .padding(.horizontal, 20)

                Button {
                    onDelete()
                } label: {
                    Text("Delete")
                        .frame(width: 209, height: 41)
                        .foregroundStyle(Constants.Colors.white)
                        .font(Constants.Fonts.h3)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Constants.Colors.black)
                        )
                }

                Button {
                    onBack()
                } label: {
                    Text("Back")
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.h3)
                }
            }

            Button {
                onClose()
            } label: {
                Constants.Images.crossThin
                    .foregroundStyle(Constants.Colors.black)
                    .frame(width: 32, height: 32)
            }
            .offset(x: -10, y: -10)
        }
        .frame(width: 249, height: 242)
    }
}

#Preview {
    DeleteAccountModal(onDelete: {}, onBack: {}, onClose: {})
        .background(Constants.Colors.black)
}
