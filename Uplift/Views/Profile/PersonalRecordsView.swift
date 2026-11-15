//
//  PersonalRecordsView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PersonalRecordsView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - UI

    var body: some View {
        content
            .pushedScreen(title: "My PRs")
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.records.isEmpty {
            emptyState
        } else {
            List {
                ForEach(viewModel.records) { record in
                    recordRow(record)
                        .listRowSeparator(.hidden)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.delete(record)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(.plain)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(systemName: "dumbbell.fill")
                .font(.system(size: Constants.PersonalRecords.emptyIconSize))
                .foregroundStyle(Constants.Colors.gray02)

            Text("No PRs yet")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)

            Text("Log your best lift and watch your card level up.")
                .font(Constants.Fonts.bodyNormal)
                .foregroundStyle(Constants.Colors.gray04)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(.horizontal, Constants.Padding.homeHorizontal)
    }

    private func recordRow(_ record: PersonalRecord) -> some View {
        HStack(spacing: Constants.Friends.rowSpacing) {
            Constants.Images.prSeal
                .resizable()
                .scaledToFit()
                .frame(width: Constants.PersonalRecords.rowIconSize, height: Constants.PersonalRecords.rowIconSize)

            VStack(alignment: .leading, spacing: Constants.Friends.labelSpacing) {
                Text(record.lift)
                    .font(Constants.Fonts.h3)
                    .foregroundStyle(Constants.Colors.black)

                Text(viewModel.bestText(of: record))
                    .font(Constants.Fonts.labelNormal)
                    .foregroundStyle(Constants.Colors.gray04)
            }

            Spacer()

            if let best = record.best {
                Text(viewModel.dateText(of: best))
                    .font(Constants.Fonts.labelNormal)
                    .foregroundStyle(Constants.Colors.gray03)
            }
        }
        .padding(.vertical, Constants.PersonalRecords.rowPadding)
    }

}
