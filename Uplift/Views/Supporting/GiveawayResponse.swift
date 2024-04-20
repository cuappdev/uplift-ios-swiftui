//
//  GiveawayResponse.swift
//  Uplift
//
//  Created by Belle Hu on 4/13/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// View representing the giveaway popup response after submitting.
struct GiveawayResponse: View {

    // MARK: - Properties
    @Binding var popupIsPresented: Bool

    // MARK: - UI

    var body: some View {
        VStack {
            ZStack {
                Constants.Images.giveawayResponded
                Button {
                    popupIsPresented = false
                } label: {
                    Constants.Images.xIcon
                        .frame(width: 29, height: 29, alignment: .trailing)
                        .padding(EdgeInsets(top: 13, leading: 311, bottom: 428, trailing: 0))
                }
            }
        }
        .frame(width: 351, height: 469, alignment: .top)
        .cornerRadius(20)
    }

}

//#Preview {
//    GiveawayResponse()
//}
