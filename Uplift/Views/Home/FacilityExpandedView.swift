//
//  FacilityExpandedView.swift
//  Uplift
//
//  Created by Vin Bui on 12/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// View representing a facility that can be expanded.
struct FacilityExpandedView: View {

    // MARK: - Properties

    let facility: Facility

    @StateObject private var viewModel = ViewModel()

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            headerView

            viewModel.isExpanded ? hoursCalendar : nil
            viewModel.isExpanded ? hoursView : nil
        }
        .onAppear {
            viewModel.determineHours(facility: facility)
        }
    }

    private var headerView: some View {
        HStack {
            facilityIcon
                .padding(.trailing, 8)

            Text(facility.name.uppercased())
                .font(Constants.Fonts.f2)
                .foregroundStyle(Constants.Colors.black)

            Spacer()

            facilityStatus
                .padding(.trailing, 16)

            Triangle()
                .fill(Constants.Colors.black)
                .rotationEffect(Angle(degrees: viewModel.isExpanded ? 180 : 90))
                .frame(width: 8, height: 8)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                viewModel.isExpanded.toggle()
            }
        }
    }

    @ViewBuilder
    private var facilityIcon: some View {
        Group {
            if let facilityType = facility.facilityType {
                switch facilityType {
                case .pool:
                    Constants.Images.pool
                case .bowling:
                    Constants.Images.bowling
                case .court:
                    Constants.Images.basketball
                default:
                    EmptyView()
                }
            }
        }
        .foregroundStyle(Constants.Colors.black)
    }

    private var facilityStatus: some View {
        Group {
            switch facility.status {
            case .closed:
                Text("Closed")
                    .foregroundStyle(Constants.Colors.closed)
            case .open:
                Text("Open")
                    .foregroundStyle(Constants.Colors.open)
            case .none:
                EmptyView()
            }
        }
        .font(Constants.Fonts.f2)
    }

    private var hoursCalendar: some View {
        HStack(spacing: 20) {
            ForEach(DayOfWeek.sortedDaysOfWeek(start: .monday), id: \.self) { day in
                Text(day.dayOfWeekAbbreviation())
                    .frame(width: 24, height: 24)
                    .background {
                        if Date.now.getDayOfWeek() == day || viewModel.selectedDay == day {
                            Circle()
                                .fill(viewModel.selectedDay == day ? Constants.Colors.yellow : Constants.Colors.gray01)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            viewModel.selectedDay = day
                            viewModel.determineHours(facility: facility)
                        }
                    }
            }
        }
        .font(Constants.Fonts.h4)
        .foregroundStyle(Constants.Colors.black)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }

    private var hoursView: some View {
        HStack(spacing: 12) {
            VStack(spacing: 8) {
                if viewModel.selectedHours.isEmpty {
                    Text("Closed")
                        .font(Constants.Fonts.bodyLight)
                        .frame(height: 18)
                } else {
                    ForEach(viewModel.selectedHours, id: \.self) { hours in
                        Text(hours.formatOpenCloseHours())
                            .font(Constants.Fonts.bodyLight)
                            .frame(height: 18)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(viewModel.selectedHours, id: \.self) { hours in
                    if let text = viewModel.getHoursText(hours: hours) {
                        Text(text)
                            .font(Constants.Fonts.labelLight)
                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                            .background {
                                poolOnlyBackground
                            }
                    } else {
                        Text("")
                            .frame(height: 18)
                    }
                }
            }
        }
        .foregroundStyle(Constants.Colors.black)
    }

    // MARK: - Supporting

    private var poolOnlyBackground: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Constants.Colors.yellow)
                .frame(width: 2)

            Rectangle()
                .fill(Constants.Colors.lightYellow.opacity(0.2))
        }
    }

}

#Preview {
    FacilityExpandedView(facility: DummyData.uplift.getGym(data: DummyData.uplift.helenNewman).facilities[0])
}
