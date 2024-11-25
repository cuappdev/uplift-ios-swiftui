//
//  FitnessCenterView.swift
//  Uplift
//
//  Created by Vin Bui on 12/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI
import Charts
import UpliftAPI

/// View for displaying fitness center information such as capacities, hours, equipment, etc.
struct FitnessCenterView: View {

    // MARK: - Properties

    let fc: Facility?
    let gym: Gym
    @State private var hourlyCapacities: [HourlyAverageCapacity] = []
    @StateObject private var viewModel = ViewModel()

    // MARK: - Constants

    let vertPadding: CGFloat = 20

    // MARK: - UI

    var body: some View {
        VStack {
//            capacitiesSection
//            DividerLine()
            hoursSection
            DividerLine()
            popularTimesSection
            DividerLine()
            equipmentSection
        }
        .onAppear {
            viewModel.fetchDaysOfWeek()

            if let fc {
                viewModel.fetchFitnessCenterHours(for: fc)
            }
        }
        .onAppear {
            // TODO: Temporary
            hourlyCapacities = [
                HourlyAverageCapacity(capacity: 10, hour: createHour(hour: 6), timeSuffix: "a"),
                HourlyAverageCapacity(capacity: 30, hour: createHour(hour: 7), timeSuffix: "a"),
                HourlyAverageCapacity(capacity: 5, hour: createHour(hour: 8), timeSuffix: "a"),
                HourlyAverageCapacity(capacity: 40, hour: createHour(hour: 9), timeSuffix: "a"),
                HourlyAverageCapacity(capacity: 80, hour: createHour(hour: 10), timeSuffix: "a"),
                HourlyAverageCapacity(capacity: 90, hour: createHour(hour: 11), timeSuffix: "a"),
                HourlyAverageCapacity(capacity: 100, hour: createHour(hour: 12), timeSuffix: "p"),
                HourlyAverageCapacity(capacity: 10, hour: createHour(hour: 13), timeSuffix: "p"),
                HourlyAverageCapacity(capacity: 30, hour: createHour(hour: 14), timeSuffix: "p"),
                HourlyAverageCapacity(capacity: 10, hour: createHour(hour: 15), timeSuffix: "p")
            ]
        }
    }

    // TODO: Delete after implementing networking
    private func createHour(hour: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.hour = hour
        let calendar = Calendar.current
        return calendar.date(from: dateComponent) ?? Date()
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
        VStack(spacing: 8) {
            HStack(alignment: .center) {
                sectionHeader(text: "Hours")

                Text("·")
                    .foregroundStyle(Constants.Colors.black)
                    .font(Constants.Fonts.h2)

                if gym.fitnessCenterIsOpen() {
                    Text("Open")
                        .foregroundStyle(Constants.Colors.open)
                        .font(Constants.Fonts.h2)
                } else {
                    Text("Closed")
                        .foregroundStyle(Constants.Colors.closed)
                        .font(Constants.Fonts.h2)
                }

                Spacer()

            }

            HStack {
                expandedHours

                Spacer()
            }
        }
        .padding(.vertical, vertPadding)
    }

    private var expandedHours: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Constants.Images.clock

                expandHoursButton

                // Fix alignment issues
                viewModel.fitnessCenterHours.first != "Closed" ? Spacer() : nil
            }

            if viewModel.expandHours {
                ForEach(viewModel.daysOfWeek.dropFirst().indices, id: \.self) { index in
                    HStack(spacing: 12) {
                        Text(viewModel.daysOfWeek[index])
                            .font(Constants.Fonts.f2)
                            .frame(width: 40, alignment: .leading)

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

    private var popularTimesSection: some View {
        VStack(spacing: 16) {
            HStack {
                sectionHeader(text: "Popular Times")

                Spacer()
            }

            Chart(hourlyCapacities, id: \.self) { hourCapacity in
                BarMark(
                    x: .value("Hour", hourCapacity.hour, unit: .hour),
                    y: .value("Capacity", hourCapacity.capacity)
                )
                .foregroundStyle(Constants.Colors.lightYellow)
            }
        }
        .padding(.vertical, vertPadding)
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
