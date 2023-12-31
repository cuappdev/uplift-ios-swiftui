//
//  SlidingTabBarView.swift
//  Uplift
//
//  Created by Vin Bui on 12/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// View representing a tab bar that contains nested views inside.
struct SlidingTabBarView<T: Hashable>: View {

    // MARK: - Properties

    let config: TabBarConfig
    let items: [Item]

    @Binding var selectedTab: T
    @Namespace var namespace

    // MARK: - UI

    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.tab) { item in
                tab(for: item)
            }
        }
    }

    private func tab(for item: Item) -> some View {
        VStack(alignment: .center, spacing: 16) {
            Text(item.title)
                .font(selectedTab == item.tab ? config.selectedFont : config.unselectedFont)
                .foregroundStyle(config.color)
                .padding(.top)

            if selectedTab == item.tab {
                config.selectedUnderlineColor
                    .frame(height: 2)
                    .matchedGeometryEffect(
                        id: "underline",
                        in: namespace,
                        properties: .frame
                    )
            } else {
                config.unselectedUnderlineColor
                    .frame(height: 2)
            }
        }
        .onTapGesture {
            withAnimation(.spring) {
                selectedTab = item.tab
            }
        }
    }

}

extension SlidingTabBarView {

    /// A tab bar item.
    struct Item {
        let tab: T
        let title: String
    }

    /// Configuration for a tab bar.
    struct TabBarConfig {
        var color: Color = Constants.Colors.black
        var selectedFont: Font = Constants.Fonts.labelBold
        var selectedUnderlineColor: Color = Constants.Colors.yellow
        var unselectedFont: Font = Constants.Fonts.labelMedium
        var unselectedUnderlineColor: Color = Constants.Colors.white
    }

}
