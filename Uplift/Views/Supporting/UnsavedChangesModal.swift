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

    // MARK: Properties

    let onSaveChanges: () -> Void
    let onContinue: () -> Void
    let onCancel: () -> Void

    // MARK: UI

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Constants.Colors.white)
                .frame(width: 249, height: 242)
                .shadow(radius: 10, x: 0, y: 4)
                .overlay(

                    VStack(spacing: 16) {
                        Constants.Images.pencil
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.top, 20)

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

                        Spacer()
                    }
                )

            VStack {
                HStack {
                    Spacer()

                    Button {
                        onCancel()
                    } label: {
                        Constants.Images.cross_thin
                            .foregroundColor(Constants.Colors.black)
                            .frame(width: 32, height: 32)
                    }
                    .padding(.top, 11)
                    .padding(.trailing, 11)
                }

                Spacer()
            }
            .frame(width: 249, height: 242)
        }
    }
}

#Preview {
    UnsavedChangesModal(onSaveChanges: {}, onContinue: {}, onCancel: {})
        .background(Constants.Colors.black)
}
