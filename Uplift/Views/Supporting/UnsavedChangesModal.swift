//
//  UnsavedChangesModal.swift
//  Uplift
//
//  Created by jiwon jeong on 9/19/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A modal for the unsaved changes popup.
struct UnsavedChangesModal: View {
    let onSaveChanges: () -> Void
    let onContinue: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 16) {
                Constants.Images.pencil
                    .resizable()
                    .frame(width: 40, height: 40)

                Text("Your unsaved changes will be lost. Save before closing?")
                    .font(Constants.Fonts.f3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.Colors.black)
                    .padding(.horizontal, 20)

                Button {
                    onSaveChanges()
                } label: {
                    Text("Save")
                        .frame(width: 209, height: 41)
                        .foregroundStyle(Constants.Colors.white)
                        .font(Constants.Fonts.h3)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Constants.Colors.black)
                        )
                }

                Button {
                    onContinue()
                } label: {
                    Text("Continue")
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.h3)
                }
            }

            Button {
                onCancel()
            } label: {
                Constants.Images.crossThin
                    .foregroundColor(Constants.Colors.black)
                    .frame(width: 32, height: 32)
            }
            .offset(x: -10, y: -10)
        }
        .frame(width: 249, height: 242)
    }
}

#Preview {
    UnsavedChangesModal(onSaveChanges: {}, onContinue: {}, onCancel: {})
        .background(Constants.Colors.black)
}
