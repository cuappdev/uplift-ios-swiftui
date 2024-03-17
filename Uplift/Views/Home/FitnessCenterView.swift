//
//  FitnessCenterView.swift
//  Uplift
//
//  Created by Vin Bui on 12/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// View for displaying fitness center information such as capacities, hours, equipment, etc.
struct FitnessCenterView: View {

    // MARK: - Properties

    let fc: Facility?

    @StateObject private var viewModel = ViewModel()
    @State private var fetchedEqmt: [Equipment] = Equipment.dummyData
    /// Dictionary to track the number of equipment objects in each EquipmentType category
    @State private var eqpmtTypeDict: [EquipmentType: Int] = [
        .cardio: 0,
        .freeWeights: 0,
        .miscellaneous: 0,
        .multiCable: 0,
        .plateLoaded: 0,
        .racksAndBenches: 0,
        .selectorized: 0
    ]

    // MARK: - Constants

    let vertPadding: CGFloat = 20

    // MARK: - UI

    var body: some View {
        VStack {
            capacitesSection
            DividerLine()
            hoursSection
            DividerLine()
            equipmentSection
        }
        .onAppear {
            viewModel.fetchDaysOfWeek()
            if let eqpmtLst = fc?.equipment {
                for eqmt in eqpmtLst {
                    ///Check if dictionary contains this eqmt type already
                    if eqpmtTypeDict.contains(where: {$0.key == eqmt.equipmentType}) {
                        eqpmtTypeDict[eqmt.equipmentType]! += 1
                    }
                }
            }

            if let fc {
                viewModel.fetchFitnessCenterHours(for: fc)
            }
        }
    }

    private var capacitesSection: some View {
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
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(EquipmentType.allEquipmentTypes, id: \.self) { equipmentType in
                        if eqpmtTypeDict[equipmentType] != 0 {
                            VStack(alignment: .leading) {
                                Text(equipmentTypeToString(eqmtType: equipmentType))
                                    .font(Constants.Fonts.h3)
                                    .padding()
                                    .fixedSize(horizontal: true, vertical: false)

                                equipmentTypeCellView(eqmtType: equipmentType)
                                    .frame(alignment: .leading)

                                Spacer()
                            }
                            .frame(width: 247)
                            .fixedSize(horizontal: true, vertical: false)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Constants.Colors.gray01, lineWidth: 1)
                                    .upliftShadow(Constants.Shadows.smallLight)
                            )
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.vertical, vertPadding)
    }

    private func equipmentTypeToString(eqmtType: EquipmentType) -> String {

        if eqmtType == EquipmentType.cardio {
            return "Cardio Machines"
        } else if eqmtType == EquipmentType.freeWeights {
            return "Free Weights"
        } else if eqmtType == EquipmentType.miscellaneous {
            return "Miscellaneous"
        } else if eqmtType == EquipmentType.multiCable {
            return "Multiple Cables"
        } else if eqmtType == EquipmentType.plateLoaded {
            return "Plate Loaded Machines"
        } else if eqmtType == EquipmentType.racksAndBenches {
            return "Racks & Benches"
        } else if eqmtType == EquipmentType.selectorized {
            return "Precor Selectorized Machines"
        } else {
            return "Invalid Equipment Type"
        }
    }

    func equipmentTypeCellView(eqmtType: EquipmentType) -> some View {
        ForEach(fc?.equipment.filter({$0.equipmentType == eqmtType}) ?? [], id: \.self) { eqmt in
            if true {
                HStack {
                    Text(eqmt.name)
                        .font(Constants.Fonts.labelLight)
                    Spacer()
                    if let quantity = eqmt.quantity {
                        Text(String(quantity ))
                            .font(Constants.Fonts.labelLight)
                    }
                }
                .padding(.horizontal)
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
