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

    let classInstance: FitnessClassInstance

    @ObservedObject var viewModel: ClassesView.ViewModel
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
        NavigationStack {
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
            .background(Constants.Colors.white)
            .onAppear {
                viewModel.fetchAllClasses()
            }
        }
    }

    private var scrollContent: some View {
        VStack(spacing: 0) {
            heroSection
            dateTimeSection
            DividerLine()
            // TODO: Function data is not in backend
//            functionSection
//            DividerLine()
            // TODO: Preparation data is not in backend
//            preparationSection
//            DividerLine()
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
                    // TODO: Add images from the backend
                    URL(string: "")
                )
                    .placeholder {
                        Constants.Colors.black
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .stretchy(geometry)
            }
            .frame(height: 360)

            VStack {
                Spacer()

                VStack {
                    Text(classInstance.fitnessClass?.name ?? "")
                        .font(Constants.Fonts.s1)
                        .foregroundStyle(Constants.Colors.white)
                        .multilineTextAlignment(.center)

                    Text(classInstance.location)
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.white)
                        .multilineTextAlignment(.center)

                    Text(classInstance.instructor.uppercased())
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

                Text("\(viewModel.determineDuration(classInstance.startTime, classInstance.endTime) ?? "") MIN")
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
                Text(viewModel.toDate(classInstance.startTime)?.dateStringDayMonth ?? "")
                    .font(Constants.Fonts.f2Light)
                    .foregroundStyle(Constants.Colors.black)

                Text(
                    (viewModel.toDate(classInstance.startTime)?.formatted(date: .omitted, time: .shortened) ?? "")
                    + " - "
                    + (viewModel.toDate(classInstance.endTime)?.formatted(date: .omitted, time: .shortened) ?? "")
                )
                    .font(Constants.Fonts.f2)
                    .foregroundStyle(Constants.Colors.black)
            }

            // TODO: Add to calendar
//            Button {
//
//            } label: {
//                VStack(spacing: 4) {
//                    Constants.Images.calendar
//                        .frame(width: 24, height: 24)
//
//                    Text("ADD TO CALENDAR")
//                        .font(Constants.Fonts.labelBold)
//                        .foregroundStyle(Constants.Colors.black)
//                }
//            }
        }
        .padding(textPadding)
    }

    private var functionSection: some View {
        VStack(spacing: 12) {
            Text("FUNCTION")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)

            // TODO: Add to backend
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

            // TODO: Add to backend
            Text("Footwear appropriate for movement")
                .font(Constants.Fonts.bodyLight)
                .foregroundStyle(Constants.Colors.black)
                .multilineTextAlignment(.center)
        }
        .padding(textPadding)
    }

    private var descriptionSection: some View {
        Text(classInstance.fitnessClass?.description ?? "")
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

            VStack(spacing: 12) {
                if viewModel.nextSessions(classInstance: classInstance).isEmpty {
                    VStack {
                        Text("No sessions in the near future...")
                            .font(Constants.Fonts.bodyMedium)
                            .foregroundStyle(Constants.Colors.black)
                    }
                } else {
                    ForEach(viewModel.nextSessions(classInstance: classInstance), id: \.self) { classInstance in
                        NavigationLink {
                            ClassDetailView(classInstance: classInstance, viewModel: viewModel)
                        } label: {
                            NextSessionCell(classInstance: classInstance, viewModel: viewModel)
                        }
                        .contentShape(Rectangle()) // Fixes navigation link tap area
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
        }
        .padding(sessionsPadding)
    }

}
