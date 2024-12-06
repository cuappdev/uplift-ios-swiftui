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
    @State private var hourlyCapacities: [HourlyAverageCapacity] = [
        HourlyAverageCapacity(averagePercent: 0.30, hourOfDay: 7),
        HourlyAverageCapacity(averagePercent: 0.5, hourOfDay: 8),
        HourlyAverageCapacity(averagePercent: 0.40, hourOfDay: 9),
        HourlyAverageCapacity(averagePercent: 0.80, hourOfDay: 10),
        HourlyAverageCapacity(averagePercent: 0.90, hourOfDay: 11),
        HourlyAverageCapacity(averagePercent: 0.10, hourOfDay: 12),
        HourlyAverageCapacity(averagePercent: 0.10, hourOfDay: 13),
        HourlyAverageCapacity(averagePercent: 0.30, hourOfDay: 14),
        HourlyAverageCapacity(averagePercent: 0.10, hourOfDay: 15),
        HourlyAverageCapacity(averagePercent: 0.40, hourOfDay: 16),
        HourlyAverageCapacity(averagePercent: 0.70, hourOfDay: 17),
        HourlyAverageCapacity(averagePercent: 0.80, hourOfDay: 18),
        HourlyAverageCapacity(averagePercent: 1.00, hourOfDay: 19),
        HourlyAverageCapacity(averagePercent: 0.40, hourOfDay: 20),
        HourlyAverageCapacity(averagePercent: 0.40, hourOfDay: 21),
        HourlyAverageCapacity(averagePercent: 0.40, hourOfDay: 22),
        HourlyAverageCapacity(averagePercent: 0.40, hourOfDay: 23)
    ]
    @StateObject private var viewModel = ViewModel()
    @State private var chartLabelSize = CGSize.zero

    // MARK: - Constants

    let vertPadding: CGFloat = 20
    let barWidth = 18

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
    }

    // TODO: Delete after implementing networking
    private func convertHourToDate(_ hour: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.hour = hour
        dateComponent.minute = 0
        dateComponent.second = 0
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

    private func calculateChartOffset(_ posX: Int) -> CGFloat {
        let textWidth = Int(chartLabelSize.width)
        let chartWidth = Int(UIScreen.main.bounds.width - (2 * Constants.Padding.gymDetailHorizontal))
        let x = Int(posX)

        if textWidth / 2 + x > chartWidth {
            let offset = -1 * (textWidth / 2 + x - chartWidth)
            return CGFloat(offset)
        } else if x - (textWidth / 2) < 0 {
            let offset = (textWidth / 2) - x
            return CGFloat(offset)
        }

        return 0
    }

    private var popularTimesSection: some View {
        VStack(spacing: 16) {
            HStack {
                sectionHeader(text: "Popular Times")

                Spacer()
            }

            Chart {
                ForEach(hourlyCapacities, id: \.self) { hourCapacity in
                    BarMark(
                        x: .value("Hour", convertHourToDate(hourCapacity.hourOfDay)),
                        y: .value("Capacity", hourCapacity.averagePercent * 0.8),
                        width: 18
                    )
                    .foregroundStyle(
                        viewModel.currentHour == hourCapacity.hourOfDay
                        ? Constants.Colors.yellow
                        : Constants.Colors.lightYellow
                    )

                    RuleMark(
                        x: .value("Hour", convertHourToDate(hourCapacity.hourOfDay)),
                        yStart: .value("Capacity", hourCapacity.averagePercent * 0.8),
                        yEnd: .value("Capacity", 0.88)
                    )
                    .foregroundStyle(
                        viewModel.currentHour == hourCapacity.hourOfDay
                        ? Constants.Colors.gray03
                        : .clear
                    )
                }
            }
            .frame(height: 124)
            .chartYScale(domain: 0...1)
            .chartXAxis {
                AxisMarks(preset: .aligned, values: .stride(by: .hour)) { value in
                    if value.index % 3 == 0 {
                        AxisValueLabel(format: .dateTime.hour(.defaultDigits(amPM: .narrow)))
                            .font(Constants.Fonts.labelMedium)
                            .foregroundStyle(Constants.Colors.black)
                    }
                }
            }
            .padding(.horizontal, CGFloat(barWidth) / 2)
            .chartYAxis(.hidden)
            .chartOverlay(alignment: .top) { chart in
                HStack(spacing: 4) {
                    Text("\(Date.now.hourString)")
                        .font(Constants.Fonts.h4)

                    // TODO: Update with true capacity label
                    Text("Usually not too busy")
                        .font(Constants.Fonts.labelMedium)
                }
                .foregroundStyle(Constants.Colors.gray04)
                .background {
                    GeometryReader { proxy in
                        // Getting the chart label size to be used to position the chart label
                        Color.clear
                            .onAppear {
                                chartLabelSize = proxy.size
                            }
                            .onChange(of: proxy.size) { newVal in
                                chartLabelSize = newVal
                            }
                    }
                }
                .position(
                    x: CGFloat(barWidth / 2) + (
                        chart.position(forX: convertHourToDate(viewModel.currentHour)) ?? 0
                    )
                )
                .offset(
                    x: calculateChartOffset(
                        barWidth / 2 + Int(chart.position(forX: convertHourToDate(viewModel.currentHour)) ?? 0)
                    )
                )
            }
        }
        .padding(.vertical, vertPadding)
    }

    private var equipmentSection: some View {
        VStack(spacing: 12) {
            sectionHeader(text: "EQUIPMENT")

            // TODO: Fix equipments section
//            equipmentScrollView()
        }
        .padding(.vertical, vertPadding)
    }

//    private func equipmentScrollView() -> some View {
//        ScrollView(.horizontal) {
//            HStack(spacing: 12) {
//                ForEach(fc?.equipment.allTypes() ?? [], id: \.self) { equipmentType in
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text(equipmentType.description)
//                            .lineLimit(1)
//                            .foregroundStyle(Constants.Colors.black)
//                            .font(Constants.Fonts.h3)
//                            .padding(.bottom, 2)
//
//                        equipmentTypeCellView(eqmtType: equipmentType)
//                            .frame(alignment: .leading)
//
//                        Spacer()
//                    }
//                    .padding(16)
//                    .frame(width: 247)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 4)
//                            .stroke(Constants.Colors.gray01, lineWidth: 1)
//                            .upliftShadow(Constants.Shadows.smallLight)
//                    )
//                }
//            }
//        }
//        .scrollIndicators(.hidden)
//    }

//    private func equipmentTypeCellView(eqmtType: EquipmentType) -> some View {
//        ForEach(fc?.equipment.filter({$0.equipmentType == eqmtType}) ?? [], id: \.self) { eqmt in
//            HStack(spacing: 12) {
//                Text(eqmt.name)
//                    .foregroundStyle(Constants.Colors.black)
//                    .font(Constants.Fonts.labelLight)
//                    .multilineTextAlignment(.leading)
//                    .frame(width: 190, alignment: .leading)
//
//                Text(eqmt.quantity == nil ? "" : String(eqmt.quantity ?? 0))
//                    .foregroundStyle(Constants.Colors.black)
//                    .font(Constants.Fonts.labelLight)
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//            }
//        }
//    }

    // MARK: - Supporting

    private func sectionHeader(text: String) -> some View {
        Text(text)
            .foregroundStyle(Constants.Colors.black)
            .font(Constants.Fonts.h2)
    }

}
