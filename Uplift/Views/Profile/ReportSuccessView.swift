//
//  ReportSuccessView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 10/16/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// The view for the success page of the reporting an issue flow.
struct ReportSuccessView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss

    // MARK: - UI

    var body: some View {
        NavigationStack {
            VStack {
                header
                content
            }
            .ignoresSafeArea(.all, edges: .top)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavBackButton(color: Constants.Colors.black, dismiss: dismiss)
                }
            }
            .background(Constants.Colors.white)
        }
    }

    private var header: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Text("Report an issue")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h2)

                Spacer()
            }
        }
        .padding(.bottom, 8)
        .background(Constants.Colors.lightGray)
        .frame(height: 96)
    }

    private var content: some View {
        VStack(spacing: 60) {
            Spacer()

            VStack(spacing: 24) {
                Constants.Images.greenCheckCircle

                VStack(spacing: 8) {
                    Text("Thank you for your input!")
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.h2)

                    Text("Your report has been submitted.")
                        .foregroundStyle(Constants.Colors.black)
                        .font(Constants.Fonts.f3)
                }
            }

            VStack(spacing: 16) {
                submitButton

                Button {

                } label: {
                    HStack {
                        Text("Return to Home")
                            .foregroundStyle(Constants.Colors.gray04)
                            .font(Constants.Fonts.f3)
                    }
                }
            }

            Spacer()
        }
    }

    private var submitButton: some View {
        NavigationLink {
            ReportView()
        } label: {
            VStack {
                Text("SUBMIT ANOTHER")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h3)
            }
            .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
            .background(
                RoundedRectangle(cornerRadius: 36)
                    .foregroundStyle(Constants.Colors.gray01)
            )
            .upliftShadow(Constants.Shadows.smallLight)
        }
    }
}

#Preview {
    ReportSuccessView()
}
