//
//  ClassDetailView.swift
//  Uplift
//
//  Created by Caitlyn Jin on 3/27/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ClassDetailView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss

    // MARK: - Constants

    let textPadding = EdgeInsets(
        top: Constants.Padding.classDetailSpacing,
        leading: Constants.Padding.classDetailTextHorizontal,
        bottom: Constants.Padding.classDetailSpacing,
        trailing: Constants.Padding.classDetailTextHorizontal
    )

    let sessionsPadding = EdgeInsets(
        top: Constants.Padding.classDetailSpacing,
        leading: Constants.Padding.classDetailSessionsHorizontal,
        bottom: Constants.Padding.classDetailSpacing,
        trailing: Constants.Padding.classDetailSessionsHorizontal
    )

    // MARK: - UI

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            scrollContent
        }
        .ignoresSafeArea(.all)
        .padding(.bottom)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavBackButton(dismiss: dismiss)
            }
        }
        .onAppear {
            // TODO: Network requests
        }
        .background(Constants.Colors.white)
    }

    private var scrollContent: some View {
        VStack(spacing: 0) {
            heroSection
            dateTimeSection
            DividerLine()
            functionSection
            DividerLine()
            preparationSection
            DividerLine()
            descriptionSection
            DividerLine()
            nextSessionsSection
        }
        .padding(.bottom)
    }

    private var heroSection: some View {
        ZStack(alignment: .center) {
            GeometryReader { geometry in
                KFImage(
                    // TODO: Networking
                    URL(string: "https://raw.githubusercontent.com/cuappdev/assets/master/uplift/gyms/helen-newman.jpg")
                )
                    .placeholder {
                        Constants.Colors.gray01
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .stretchy(geometry)
            }
            .frame(height: 360)

            VStack {
                Spacer()

                VStack {
                    // TODO: Networking
                    Text("Muscle Pump")
                        .font(Constants.Fonts.s1)
                        .foregroundStyle(Constants.Colors.white)
                        .multilineTextAlignment(.center)

                    // TODO: Networking
                    Text("Helen Newman Hall Dance Studio")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.white)
                        .multilineTextAlignment(.center)

                    // TODO: Networking
                    Text("Debbie".uppercased())
                        .font(Constants.Fonts.h2)
                        .foregroundStyle(Constants.Colors.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)
                }
                .padding(.horizontal, 40)

                durationCircle
            }
        }
        .frame(height: 360)
    }

    private var durationCircle: some View {
        ZStack {
            SemiCircleShape()
                .fill(Constants.Colors.white)
                .frame(width: 84, height: 84)

            VStack {
                Spacer()

                // TODO: Networking
                Text("45 MIN")
                    .font(Constants.Fonts.h3)
                    .foregroundStyle(Constants.Colors.black)
                    .padding(.bottom, 4)
            }
            .frame(height: 84)
        }
    }

    private var dateTimeSection: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                // TODO: Networking
                Text("Tuesday, Oct 8")
                    .font(Constants.Fonts.f2Light)
                    .foregroundStyle(Constants.Colors.black)

                // TODO: Networking
                Text("12:15 PM - 1:00 PM")
                    .font(Constants.Fonts.f2)
                    .foregroundStyle(Constants.Colors.black)
            }

            VStack {
                Button {
                    // TODO: Add to calendar functionality
                } label: {
                    VStack(spacing: 4) {
                        Constants.Images.calendar
                            .frame(width: 24, height: 24)

                        Text("ADD TO CALENDAR")
                            .font(Constants.Fonts.labelBold)
                            .foregroundStyle(Constants.Colors.black)
                    }
                }
            }
        }
        .padding(textPadding)
    }

    private var functionSection: some View {
        VStack(spacing: 12) {
            Text("FUNCTION")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)

            // TODO: Networking
            Text("Core · Overall Fitness · Stability")
                .font(Constants.Fonts.bodyLight)
                .foregroundStyle(Constants.Colors.black)
                .multilineTextAlignment(.center)
        }
        .padding(textPadding)
    }

    private var preparationSection: some View {
        VStack(spacing: 12) {
            Text("PREPARATION")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)

            // TODO: Networking
            Text("Footwear appropriate for movement")
                .font(Constants.Fonts.bodyLight)
                .foregroundStyle(Constants.Colors.black)
                .multilineTextAlignment(.center)
        }
        .padding(textPadding)
    }

    private var descriptionSection: some View {
        // TODO: Networking
        Text("Put a little muscle into your workout and join us for a class designed to build muscle endurance with low to medium weights and high repetitions. " +
             "A variety of equipment and strength training techniques will be used in this class. " +
             "There is no cardio portion in these sessions. Footwear that is appropriate for movement is required for this class.")
            .font(Constants.Fonts.bodyLight)
            .foregroundStyle(Constants.Colors.black)
            .multilineTextAlignment(.center)
            .padding(textPadding)
    }

    private var nextSessionsSection: some View {
        VStack(spacing: 24) {
            Text("NEXT SESSIONS")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)

            // TODO: Networking
            VStack(spacing: 12) {
                ClassCell()
                ClassCell()
                ClassCell()
                ClassCell()
            }
        }
        .padding(sessionsPadding)
    }

}

#Preview {
    ClassDetailView()
}
