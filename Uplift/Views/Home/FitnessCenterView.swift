//
//  FitnessCenterView.swift
//  Uplift
//
//  Created by Vin Bui on 12/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI
import UpliftAPI

/// View for displaying fitness center information such as capacities, hours, equipment, etc.
struct FitnessCenterView: View {

    // MARK: - Properties

    let fc: Facility?

    @StateObject private var viewModel = ViewModel()

    // MARK: - Constants

    let vertPadding: CGFloat = 20

    // MARK: - UI

    var body: some View {
        VStack {
            capacitiesSection
            DividerLine()
            hoursSection
            DividerLine()
            equipmentSection
        }
        .onAppear {
            viewModel.fetchDaysOfWeek()

            if let fc {
                viewModel.fetchFitnessCenterHours(for: fc)
            }
        }
    }

    private var capacitiesSection: some View {
        VStack(spacing: 12) {
            sectionHeader(text: "CAPACITIES")

            CapacityCircleView(
                circleWidth: 12,
                closeStatus: fc?.status,
                status: fc?.capacity?.status,
                textFont: Constants.Fonts.h2
            )
            .padding(8)
            .frame(width: 130, height: 130)

            Text("Updated \(fc?.capacity?.updated.dateStringTrailingZeros ?? "")")
                .foregroundStyle(Constants.Colors.gray04)
                .font(Constants.Fonts.labelLight)
        }
        .padding(.vertical, vertPadding)
    }

    private var hoursSection: some View {
        VStack(spacing: 12) {
            sectionHeader(text: "HOURS")

            expandedHours
        }
        .padding(.vertical, vertPadding)
    }

    private var expandedHours: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Constants.Images.clock
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 16, alignment: .trailing)

                expandHoursButton

                // Fix alignment issues
                viewModel.fitnessCenterHours.first != "Closed" ? Spacer() : nil
            }

            if viewModel.expandHours {
                ForEach(viewModel.daysOfWeek.dropFirst().indices, id: \.self) { index in
                    HStack(spacing: 8) {
                        Text(viewModel.daysOfWeek[index])
                            .font(Constants.Fonts.f2)
                            .frame(width: 32, alignment: .trailing)

                        Text(viewModel.fitnessCenterHours[index])
                            .font(Constants.Fonts.f2Regular)
                            .frame(minWidth: 84, alignment: .leading)

                        // Fix alignment issues
                        viewModel.fitnessCenterHours.first != "Closed" ? Spacer() : nil
                    }
                }
            }
        }
        .frame(width: 232)
        .foregroundStyle(Constants.Colors.black)
    }

    private var expandHoursButton: some View {
        Button {
            withAnimation(.easeOut) {
                viewModel.expandHours.toggle()
            }
            AnalyticsManager.shared.log(
                UpliftEvent.expandFitnessHours.toEvent(type: .facility, value: fc?.name)
            )
        } label: {
            HStack(spacing: 8) {
                Text(viewModel.fitnessCenterHours.first ?? "")
                    .font(Constants.Fonts.f2)
                    .multilineTextAlignment(.leading)

                Triangle()
                    .fill(Constants.Colors.black)
                    .rotationEffect(Angle(degrees: viewModel.expandHours ? 180 : 90))
                    .frame(width: 8, height: 8)
            }
        }
        .frame(minWidth: 84, alignment: .leading)
    }

    private var equipmentSection: some View {
        VStack(spacing: 12) {
            sectionHeader(text: "EQUIPMENT")

            equipmentScrollView()
        }
        .padding(.vertical, vertPadding)
    }

    private func equipmentScrollView() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(fc?.equipment.allTypes() ?? [], id: \.self) { equipmentType in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(equipmentType.description)
                            .lineLimit(1)
                            .foregroundStyle(Constants.Colors.black)
                            .font(Constants.Fonts.h3)
                            .padding(.bottom, 2)

                        equipmentTypeCellView(eqmtType: equipmentType)
                            .frame(alignment: .leading)

                        Spacer()
                    }
                    .padding(16)
                    .frame(width: 247)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Constants.Colors.gray01, lineWidth: 1)
                            .upliftShadow(Constants.Shadows.smallLight)
                    )
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private func equipmentTypeCellView(eqmtType: EquipmentType) -> some View {
        ForEach(fc?.equipment.filter({$0.equipmentType == eqmtType}) ?? [], id: \.self) { eqmt in
            HStack(spacing: 12) {
                Text(eqmt.name)
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.labelLight)
                    .multilineTextAlignment(.leading)
                    .frame(width: 190, alignment: .leading)

                Text(eqmt.quantity == nil ? "" : String(eqmt.quantity ?? 0))
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.labelLight)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }

    // MARK: - Supporting

    private func sectionHeader(text: String) -> some View {
        Text(text)
            .foregroundStyle(Constants.Colors.black)
            .font(Constants.Fonts.h2)
    }

}

#Preview {
    FitnessCenterView(fc: DummyData.uplift.getGym(data: DummyData.uplift.helenNewman).fitnessCenters[0])
}
